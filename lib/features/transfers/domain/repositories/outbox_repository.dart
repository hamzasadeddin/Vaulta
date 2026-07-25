import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/transfers/domain/entities/outbox_entry.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';

/// Durable queue of authorised-but-undelivered transfer confirms.
///
/// Deliberately a **store, not an engine**: it persists, reads and
/// deletes rows and makes no decision about when to send or what a
/// failure means. That reasoning lives in `DrainOutbox`, where it can be
/// tested without a database.
///
/// Scope is transfer confirms only. Card freeze already has an optimistic
/// update from Phase 7, and queueing it would add a second mechanism for
/// a lower-stakes action — a durable queue earns its cost on money
/// movement and nowhere else yet.
abstract interface class OutboxRepository {
  /// Reactive read model. A cache that cannot be read emits a
  /// [CacheFailure] rather than throwing, exactly like the accounts
  /// cache — the app stays usable, it just cannot show the queue.
  Stream<Result<List<OutboxEntry>, Failure>> watch();

  /// Persists a confirm the user authorised but the network refused.
  ///
  /// Takes the [quote] and the [request] it came from: the quote carries
  /// the id and idempotency key that replay *this* confirm, the request
  /// is what a re-price needs once that draft is dead.
  Future<Result<OutboxEntry, Failure>> enqueue({
    required TransferQuote quote,
    required TransferRequest request,
  });

  /// Entries eligible to be sent right now, oldest first. FIFO matters:
  /// two queued debits against one account must hit the ledger in the
  /// order the user authorised them.
  Future<Result<List<OutboxEntry>, Failure>> due();

  Future<Result<void, Failure>> save(OutboxEntry entry);

  Future<Result<void, Failure>> discard(String id);

  /// Returns rows stranded `inFlight` by a kill mid-request back to
  /// `pending`. Called once at startup — see [OutboxStatus.inFlight].
  Future<Result<void, Failure>> recoverInFlight();

  /// Drops settled entries the user has acknowledged.
  Future<Result<void, Failure>> clearSent();
}
