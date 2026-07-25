import 'package:meta/meta.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';

/// Where a queued confirm is in its life.
///
/// [inFlight] is durable on purpose. A process killed mid-request leaves
/// the row in that state, and startup recovery moves it back to
/// [pending] — the idempotency key makes the re-send safe, and the
/// alternative (assuming it landed) would silently drop a transfer.
enum OutboxStatus { pending, inFlight, sent, needsAttention }

/// Why a queued confirm stopped and needs a person.
///
/// Every arm is a server answer we may not paper over: three of them mean
/// the draft is gone and the transfer has to be re-priced before it can
/// move, and the fourth means we gave up asking.
enum OutboxAttention {
  /// `409 QUOTE_EXPIRED` — the held rate died while the device was
  /// offline. Nothing was sent.
  rateExpired,

  /// `404` — the draft is no longer on the server. Reached only after
  /// the idempotency replay missed, so the transfer did *not* settle.
  draftGone,

  /// `422` — the server refused the transfer itself (balance, payee).
  rejected,

  /// Repeated server errors. We never got an answer either way, and the
  /// idempotency key means asking again is still safe — but a queue that
  /// retries forever is a queue nobody can reason about.
  exhausted,
}

/// What the queue renders while there is no network.
///
/// A snapshot, not a live read: the whole point of the outbox is to be
/// legible with the server unreachable, so the amounts it shows are the
/// ones the user reviewed, frozen at the moment they tapped confirm.
@immutable
class OutboxSnapshot {
  const OutboxSnapshot({
    required this.destinationLabel,
    required this.destinationDetail,
    required this.totalDebit,
    required this.destinationAmount,
  });

  final String destinationLabel;
  final String destinationDetail;

  /// What leaves the source account, in the source currency.
  final Money totalDebit;

  /// What lands, in the destination currency.
  final Money destinationAmount;

  bool get isCrossCurrency => totalDebit.currency != destinationAmount.currency;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutboxSnapshot &&
          other.destinationLabel == destinationLabel &&
          other.destinationDetail == destinationDetail &&
          other.totalDebit == totalDebit &&
          other.destinationAmount == destinationAmount;

  @override
  int get hashCode => Object.hash(
        destinationLabel,
        destinationDetail,
        totalDebit,
        destinationAmount,
      );
}

/// A confirm the user authorised but the network could not deliver.
///
/// The entry stores three things that look redundant and are not:
///
/// - [transferId] + [idempotencyKey] replay the *same* confirm, so a
///   drain after a restart can only ever produce one transfer.
/// - [request] re-prices from scratch when the draft is dead. A re-quote
///   is a new draft (handoff 8 §38), so the original request — not the
///   original quote — is what has to survive.
/// - [snapshot] renders the queue offline.
@immutable
class OutboxEntry {
  const OutboxEntry({
    required this.id,
    required this.transferId,
    required this.idempotencyKey,
    required this.request,
    required this.snapshot,
    required this.queuedAt,
    this.status = OutboxStatus.pending,
    this.attempts = 0,
    this.serverErrors = 0,
    this.nextAttemptAt,
    this.attention,
    this.reference,
  });

  /// Delays between retries, by attempt number. Capped rather than
  /// unbounded: a device offline for a day should still wake up promptly
  /// once it is back, not two hours later.
  static const retryDelays = <Duration>[
    Duration(seconds: 2),
    Duration(seconds: 10),
    Duration(seconds: 30),
    Duration(minutes: 2),
    Duration(minutes: 10),
  ];

  /// How many *server* errors are tolerated before the entry asks for a
  /// person. Transport failures do not count — see [afterFailure].
  static const maxServerErrors = 8;

  /// Local id. Not the transfer id: an entry exists before the server
  /// has agreed to anything, and survives being re-priced.
  final String id;

  /// The draft this entry confirms.
  final String transferId;

  final String idempotencyKey;

  /// Everything needed to ask for a new price without a network round
  /// trip to rebuild it.
  final TransferRequest request;

  final OutboxSnapshot snapshot;

  final DateTime queuedAt;
  final OutboxStatus status;

  /// Total delivery attempts — drives the backoff curve.
  final int attempts;

  /// Attempts that reached the bank and got an error from it. Separate
  /// from [attempts] because the two mean opposite things: a transport
  /// failure is "we know nothing", a 5xx is "the bank is unhappy".
  final int serverErrors;

  /// Earliest the next attempt may run. `null` means immediately.
  final DateTime? nextAttemptAt;

  /// Set only when [status] is [OutboxStatus.needsAttention].
  final OutboxAttention? attention;

  /// The settled transfer's customer-facing reference, once [status] is
  /// [OutboxStatus.sent].
  final String? reference;

  /// Ready to be attempted now. Backoff is a floor, not a schedule — a
  /// connectivity hint may wake the drain earlier, and this is what stops
  /// it from hammering.
  bool isDueAt(DateTime now) {
    if (status != OutboxStatus.pending) return false;
    final next = nextAttemptAt;
    return next == null || !now.isBefore(next);
  }

  /// Whether resolving this needs a fresh price rather than another try.
  ///
  /// Three of the four attention reasons mean the draft is gone
  /// server-side, so there is nothing left to retry — only to re-quote.
  bool get needsReprice =>
      attention != null && attention != OutboxAttention.exhausted;

  /// The server accepted it.
  OutboxEntry settled(Transfer transfer) => copyWith(
        status: OutboxStatus.sent,
        reference: transfer.reference,
        clearNextAttemptAt: true,
        clearAttention: true,
      );

  /// Marks an attempt as started. Persisted before the request goes out,
  /// so a crash mid-flight is visible on the next launch.
  OutboxEntry starting() => copyWith(status: OutboxStatus.inFlight);

  /// Returns an in-flight entry to the queue. Safe by construction: the
  /// idempotency key means a re-send of a request that actually landed
  /// returns the original transfer instead of moving money twice.
  OutboxEntry recovered() => status == OutboxStatus.inFlight
      ? copyWith(status: OutboxStatus.pending, clearNextAttemptAt: true)
      : this;

  /// Clears the backoff so the next drain picks this up immediately.
  OutboxEntry retriedNow() => copyWith(
        status: OutboxStatus.pending,
        serverErrors: 0,
        clearNextAttemptAt: true,
        clearAttention: true,
      );

  /// Applies a failed attempt.
  ///
  /// The split is the whole safety argument of this phase, and it falls
  /// out of handoff 8 §37: **expiry may refuse work that has not
  /// happened; it may never retract work that has.** A 409 or a 404 can
  /// only be reached once the server's idempotency ledger has already
  /// said "this key never settled", so treating them as terminal cannot
  /// discard a real transfer. A transport failure says nothing at all,
  /// so it retries forever — the key makes that free.
  OutboxEntry afterFailure(Failure failure, {required DateTime now}) {
    final tried = attempts + 1;
    return switch (failure) {
      // Matched before the general ServerFailure arm: the errorCode is
      // structured, the message is developer-facing prose (§4).
      ServerFailure(errorCode: 'QUOTE_EXPIRED') =>
        _attention(OutboxAttention.rateExpired, tried),
      ServerFailure(statusCode: 404) =>
        _attention(OutboxAttention.draftGone, tried),
      ValidationFailure() => _attention(OutboxAttention.rejected, tried),
      // A dead session is not a dead transfer. Hold the entry; the next
      // drain after a refresh or a fresh sign-in carries it.
      AuthFailure() => _retry(tried, now),
      NetworkFailure() ||
      TimeoutFailure() ||
      CancelledFailure() =>
        _retry(tried, now),
      ServerFailure() ||
      UnexpectedFailure() ||
      CacheFailure() =>
        serverErrors + 1 >= maxServerErrors
            ? _attention(OutboxAttention.exhausted, tried)
            : _retry(tried, now, server: true),
    };
  }

  OutboxEntry _retry(int tried, DateTime now, {bool server = false}) {
    final index = (tried - 1).clamp(0, retryDelays.length - 1);
    return copyWith(
      status: OutboxStatus.pending,
      attempts: tried,
      serverErrors: server ? serverErrors + 1 : serverErrors,
      nextAttemptAt: now.add(retryDelays[index]),
      clearAttention: true,
    );
  }

  OutboxEntry _attention(OutboxAttention reason, int tried) => copyWith(
        status: OutboxStatus.needsAttention,
        attempts: tried,
        attention: reason,
        clearNextAttemptAt: true,
      );

  OutboxEntry copyWith({
    String? transferId,
    String? idempotencyKey,
    OutboxStatus? status,
    int? attempts,
    int? serverErrors,
    DateTime? nextAttemptAt,
    bool clearNextAttemptAt = false,
    OutboxAttention? attention,
    bool clearAttention = false,
    String? reference,
  }) {
    return OutboxEntry(
      id: id,
      transferId: transferId ?? this.transferId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      request: request,
      snapshot: snapshot,
      queuedAt: queuedAt,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      serverErrors: serverErrors ?? this.serverErrors,
      nextAttemptAt:
          clearNextAttemptAt ? null : (nextAttemptAt ?? this.nextAttemptAt),
      attention: clearAttention ? null : (attention ?? this.attention),
      reference: reference ?? this.reference,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutboxEntry &&
          other.id == id &&
          other.transferId == transferId &&
          other.idempotencyKey == idempotencyKey &&
          other.request == request &&
          other.snapshot == snapshot &&
          other.queuedAt == queuedAt &&
          other.status == status &&
          other.attempts == attempts &&
          other.serverErrors == serverErrors &&
          other.nextAttemptAt == nextAttemptAt &&
          other.attention == attention &&
          other.reference == reference;

  @override
  int get hashCode => Object.hashAll([
        id,
        transferId,
        idempotencyKey,
        request,
        snapshot,
        queuedAt,
        status,
        attempts,
        serverErrors,
        nextAttemptAt,
        attention,
        reference,
      ]);
}
