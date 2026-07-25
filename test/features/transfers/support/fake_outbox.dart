import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/auth/domain/entities/user.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_state.dart';
import 'package:vaulta/features/transfers/domain/entities/outbox_entry.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/domain/repositories/outbox_repository.dart';

/// A live session for tests that let the flow reach the outbox.
///
/// The outbox only drains inside an authenticated session — that gate is
/// deliberate (a queued transfer must not replay for whoever signs in
/// next, nor move money behind a lock screen). Building the outbox
/// controller kicks a drain, so a test that reaches it has to resolve
/// auth to *something* — otherwise reading `authControllerProvider`
/// builds the real controller, whose `restore()` microtask walks the
/// auth → dio → config chain and throws because none of it is set up.
///
/// Overriding with this fixed value (`authControllerProvider
/// .overrideWithValue(signedIn)`) skips restore entirely and models the
/// only state in which an enqueue actually happens.
const AuthState signedIn = Authenticated(
  User(
    id: 'usr_test',
    fullName: 'Test User',
    email: 'test@vaulta.app',
    kycStatus: KycStatus.verified,
  ),
);

/// An in-memory outbox for tests, so no test ever constructs the real
/// Drift database (which would fire a platform channel with no binding
/// and warn about opening the DB twice).
///
/// Faithful enough to assert against: [enqueue] actually stores, [watch]
/// actually emits, and the id is derived from the quote so a test can
/// find what it queued. What it deliberately omits is the drain policy —
/// that lives in `DrainOutbox` and is tested directly, not through here.
class FakeOutboxRepository implements OutboxRepository {
  final List<OutboxEntry> entries = [];

  int enqueueCalls = 0;

  /// Flip to simulate a queue that cannot be written — the one case where
  /// the flow must report the original network failure instead of
  /// claiming the transfer is safely saved.
  bool failEnqueue = false;

  @override
  Future<Result<OutboxEntry, Failure>> enqueue({
    required TransferQuote quote,
    required TransferRequest request,
  }) async {
    enqueueCalls++;
    if (failEnqueue) {
      return const Result.failure(
        CacheFailure(message: 'outbox unavailable'),
      );
    }
    final entry = OutboxEntry(
      id: 'obx_${quote.id}',
      transferId: quote.id,
      idempotencyKey: quote.idempotencyKey,
      request: request,
      snapshot: OutboxSnapshot(
        destinationLabel: quote.destinationLabel,
        destinationDetail: quote.destinationDetail,
        totalDebit: quote.totalDebit,
        destinationAmount: quote.destinationAmount,
      ),
      queuedAt: DateTime(2026, 7, 24, 12),
    );
    entries.add(entry);
    return Result.success(entry);
  }

  @override
  Stream<Result<List<OutboxEntry>, Failure>> watch() =>
      Stream.value(Result.success(List.unmodifiable(entries)));

  @override
  Future<Result<List<OutboxEntry>, Failure>> due() async =>
      Result.success(List.unmodifiable(entries));

  @override
  Future<Result<void, Failure>> save(OutboxEntry entry) async {
    final index = entries.indexWhere((e) => e.id == entry.id);
    if (index == -1) {
      entries.add(entry);
    } else {
      entries[index] = entry;
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void, Failure>> discard(String id) async {
    entries.removeWhere((e) => e.id == id);
    return const Result.success(null);
  }

  @override
  Future<Result<void, Failure>> recoverInFlight() async =>
      const Result.success(null);

  @override
  Future<Result<void, Failure>> clearSent() async {
    entries.removeWhere((e) => e.status == OutboxStatus.sent);
    return const Result.success(null);
  }
}
