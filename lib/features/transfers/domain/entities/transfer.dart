import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:vaulta/core/iban/iban.dart';
import 'package:vaulta/core/money/money.dart';

/// Where a transfer's money lands.
///
/// A sealed union so every surface that renders, serializes or prices a
/// destination handles all three cases — adding a fourth (a pot, a
/// merchant) is a compile error at each site rather than a silent
/// fall-through.
@immutable
sealed class TransferDestination {
  const TransferDestination();
}

/// Between two of the user's own accounts. Never carries a fee.
final class OwnAccountDestination extends TransferDestination {
  const OwnAccountDestination(this.accountId);

  final String accountId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnAccountDestination && other.accountId == accountId;

  @override
  int get hashCode => Object.hash(OwnAccountDestination, accountId);
}

/// A saved payee, resolved server-side from its id.
final class BeneficiaryDestination extends TransferDestination {
  const BeneficiaryDestination(this.beneficiaryId);

  final String beneficiaryId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeneficiaryDestination && other.beneficiaryId == beneficiaryId;

  @override
  int get hashCode => Object.hash(BeneficiaryDestination, beneficiaryId);
}

/// A one-off payee entered by IBAN. The [Iban] type guarantees the check
/// digits already passed — the server still re-validates.
final class IbanDestination extends TransferDestination {
  const IbanDestination({required this.iban, required this.holderName});

  final Iban iban;
  final String holderName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IbanDestination &&
          other.iban == iban &&
          other.holderName == holderName;

  @override
  int get hashCode => Object.hash(iban, holderName);
}

/// What the user asked for, before the server prices it.
@immutable
class TransferRequest {
  const TransferRequest({
    required this.sourceAccountId,
    required this.destination,
    required this.amount,
    this.note,
    this.scheduledFor,
  });

  final String sourceAccountId;
  final TransferDestination destination;

  /// Always in the *source* account's currency — the amount the user
  /// typed. Any conversion is the server's job.
  final Money amount;

  final String? note;

  /// `null` sends immediately; a future date schedules it.
  final DateTime? scheduledFor;
}

/// The server's priced, reviewable draft. Nothing has moved yet.
///
/// [idempotencyKey] is issued with the draft rather than minted at send
/// time, so a confirm that is retried — by `dio_smart_retry`, by a
/// double-tap, or by a queued outbox entry replayed after a restart —
/// carries the same key and can only ever produce one transfer.
@immutable
class TransferQuote {
  const TransferQuote({
    required this.id,
    required this.idempotencyKey,
    required this.sourceAccountId,
    required this.destinationLabel,
    required this.destinationDetail,
    required this.amount,
    required this.fee,
    required this.totalDebit,
    required this.destinationAmount,
    this.rate,
    this.scheduledFor,
    this.expiresAt,
  });

  final String id;
  final String idempotencyKey;
  final String sourceAccountId;

  /// Display name of the payee (`Layla Haddad`, `Savings`).
  final String destinationLabel;

  /// Secondary line — masked IBAN or account type.
  final String destinationDetail;

  /// Debited from the source, in the source currency.
  final Money amount;

  final Money fee;

  /// `amount + fee` — what actually leaves the account.
  final Money totalDebit;

  /// Credited to the destination, in the destination's currency. Equal to
  /// [amount] on same-currency transfers.
  final Money destinationAmount;

  /// Exact FX rate, `null` when no conversion applies. A [Decimal] and
  /// never a `double` — a rate multiplies money.
  final Decimal? rate;

  final DateTime? scheduledFor;

  /// When the held price dies, or `null` when nothing is held.
  ///
  /// Only cross-currency quotes carry a lock — a same-currency transfer
  /// has no rate that can move, so there is nothing to expire. Computed
  /// on arrival from the server's *relative* TTL rather than read off its
  /// timestamp, so a device with a skewed clock still counts down the
  /// duration the bank actually granted.
  final DateTime? expiresAt;

  bool get isCrossCurrency => amount.currency != destinationAmount.currency;

  bool get isScheduled => scheduledFor != null;

  /// Whether this quote holds a price at all.
  bool get isLocked => expiresAt != null;

  /// The clock is a parameter, not a call to `DateTime.now()`: the domain
  /// layer stays pure and every expiry test is deterministic.
  bool isExpiredAt(DateTime now) {
    final expiry = expiresAt;
    return expiry != null && !now.isBefore(expiry);
  }

  /// Time left on the lock, floored at zero. `null` when unlocked, which
  /// callers render as "no countdown" rather than as "expired".
  Duration? remainingAt(DateTime now) {
    final expiry = expiresAt;
    if (expiry == null) return null;
    final left = expiry.difference(now);
    return left.isNegative ? Duration.zero : left;
  }
}

/// Outcome of a confirmed transfer.
///
/// `pending` is the degrade target for an unrecognized status: claiming
/// `completed` would tell the user money arrived when it may not have,
/// and claiming `failed` would invite a duplicate send. Pending is the
/// only honest default.
enum TransferStatus { completed, pending, scheduled, failed }

/// A transfer the server has accepted — the receipt.
@immutable
class Transfer {
  const Transfer({
    required this.id,
    required this.reference,
    required this.status,
    required this.sourceAccountId,
    required this.destinationLabel,
    required this.destinationDetail,
    required this.amount,
    required this.fee,
    required this.totalDebit,
    required this.destinationAmount,
    required this.createdAt,
    this.rate,
    this.scheduledFor,
    this.balanceAfter,
  });

  final String id;

  /// Customer-facing reference printed on the receipt (`VLT-2026-…`).
  final String reference;

  final TransferStatus status;
  final String sourceAccountId;
  final String destinationLabel;
  final String destinationDetail;
  final Money amount;
  final Money fee;
  final Money totalDebit;
  final Money destinationAmount;
  final DateTime createdAt;
  final Decimal? rate;
  final DateTime? scheduledFor;

  /// Source balance after settlement — absent while pending or scheduled,
  /// because nothing has moved yet.
  final Money? balanceAfter;

  bool get isCrossCurrency => amount.currency != destinationAmount.currency;

  bool get isScheduled => status == TransferStatus.scheduled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transfer &&
          other.id == id &&
          other.reference == reference &&
          other.status == status &&
          other.sourceAccountId == sourceAccountId &&
          other.destinationLabel == destinationLabel &&
          other.destinationDetail == destinationDetail &&
          other.amount == amount &&
          other.fee == fee &&
          other.totalDebit == totalDebit &&
          other.destinationAmount == destinationAmount &&
          other.createdAt == createdAt &&
          other.rate == rate &&
          other.scheduledFor == scheduledFor &&
          other.balanceAfter == balanceAfter;

  @override
  int get hashCode => Object.hashAll([
        id,
        reference,
        status,
        sourceAccountId,
        destinationLabel,
        destinationDetail,
        amount,
        fee,
        totalDebit,
        destinationAmount,
        createdAt,
        rate,
        scheduledFor,
        balanceAfter,
      ]);
}
