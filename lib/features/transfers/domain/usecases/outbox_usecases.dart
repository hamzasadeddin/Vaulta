import 'package:meta/meta.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/core/usecase/use_case.dart';
import 'package:vaulta/features/transfers/domain/entities/outbox_entry.dart';
import 'package:vaulta/features/transfers/domain/repositories/outbox_repository.dart';
import 'package:vaulta/features/transfers/domain/repositories/transfers_repository.dart';

/// What one pass over the queue did. Returned rather than logged so a
/// caller can decide whether anything is worth telling the user about.
@immutable
class OutboxDrainReport {
  const OutboxDrainReport({
    this.attempted = 0,
    this.sent = 0,
    this.retrying = 0,
    this.needsAttention = 0,
  });

  final int attempted;
  final int sent;
  final int retrying;
  final int needsAttention;

  bool get isEmpty => attempted == 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutboxDrainReport &&
          other.attempted == attempted &&
          other.sent == sent &&
          other.retrying == retrying &&
          other.needsAttention == needsAttention;

  @override
  int get hashCode => Object.hash(attempted, sent, retrying, needsAttention);
}

/// Delivers every due entry, in order, and records what happened.
///
/// Sequential on purpose. Two queued debits from one account can each fit
/// the balance alone and not together, so sending them concurrently would
/// make which one bounces a race. It also keeps the ledger in the order
/// the user authorised.
///
/// A single confirm is replayed with its original idempotency key, so
/// every attempt here is safe *regardless of what happened to the
/// previous one* — including an attempt that actually landed before the
/// socket died. That guarantee is what makes the whole queue honest.
class DrainOutbox implements UseCase<NoParams, OutboxDrainReport> {
  DrainOutbox({
    required OutboxRepository outbox,
    required TransfersRepository transfers,
    DateTime Function()? clock,
  })  : _outbox = outbox,
        _transfers = transfers,
        _clock = clock ?? DateTime.now;

  final OutboxRepository _outbox;
  final TransfersRepository _transfers;
  final DateTime Function() _clock;

  @override
  Future<Result<OutboxDrainReport, Failure>> call(NoParams input) async {
    final dueResult = await _outbox.due();
    final readFailure = dueResult.failureOrNull;
    if (readFailure != null) return Result.failure(readFailure);
    final entries = dueResult.valueOrNull ?? const <OutboxEntry>[];

    var sent = 0;
    var retrying = 0;
    var attention = 0;

    for (final entry in entries) {
      await _outbox.save(entry.starting());

      final result = await _transfers.confirmTransfer(
        transferId: entry.transferId,
        idempotencyKey: entry.idempotencyKey,
      );

      final next = result.fold<OutboxEntry>(
        onSuccess: entry.settled,
        // The clock is read after the await, so backoff is measured from
        // when the answer arrived rather than when the request left.
        onFailure: (failure) => entry.afterFailure(failure, now: _clock()),
      );
      await _outbox.save(next);

      switch (next.status) {
        case OutboxStatus.sent:
          sent++;
        case OutboxStatus.needsAttention:
          attention++;
        case OutboxStatus.pending:
        case OutboxStatus.inFlight:
          retrying++;
      }
    }

    return Result.success(
      OutboxDrainReport(
        attempted: entries.length,
        sent: sent,
        retrying: retrying,
        needsAttention: attention,
      ),
    );
  }
}

/// Puts an entry back in the queue with its backoff cleared.
///
/// Only offered for [OutboxAttention.exhausted], where the draft is still
/// alive and the problem was ours. The other three reasons mean the
/// server has thrown the draft away — retrying those would just walk
/// into the same refusal, so the queue offers a re-price instead.
class RetryOutboxEntry implements UseCase<OutboxEntry, void> {
  const RetryOutboxEntry(this._outbox);

  final OutboxRepository _outbox;

  @override
  Future<Result<void, Failure>> call(OutboxEntry input) =>
      _outbox.save(input.retriedNow());
}
