import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vaulta/core/connectivity/connectivity_monitor.dart';
import 'package:vaulta/core/storage/storage_providers.dart';
import 'package:vaulta/core/usecase/use_case.dart';
// Presentation-only read into a sibling feature, the same seam §6.22
// already allows: the queue must not move money while the session is
// signed out or locked, and session state lives in auth's presentation
// layer. No domain or data coupling crosses features.
import 'package:vaulta/features/auth/presentation/providers/auth_providers.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_state.dart';
import 'package:vaulta/features/transfers/data/datasources/outbox_local_data_source.dart';
import 'package:vaulta/features/transfers/data/repositories/outbox_repository_impl.dart';
import 'package:vaulta/features/transfers/domain/entities/outbox_entry.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/domain/repositories/outbox_repository.dart';
import 'package:vaulta/features/transfers/domain/usecases/outbox_usecases.dart';
import 'package:vaulta/features/transfers/presentation/providers/transfers_providers.dart';

part 'outbox_providers.g.dart';

/// Composition point for the outbox. `keepAlive` for the same reason the
/// session is: the queue outlives every screen, and a transfer that
/// stopped draining because the user navigated away would be a bug with
/// money in it.
@Riverpod(keepAlive: true)
OutboxRepository outboxRepository(Ref ref) {
  return OutboxRepositoryImpl(
    local: DriftOutboxLocalDataSource(ref.watch(appDatabaseProvider)),
    clock: ref.watch(transferClockProvider),
  );
}

/// Owns the queue's read model *and* its delivery loop.
///
/// One notifier rather than two because the two are the same state
/// machine seen from different ends: a drain changes rows, and rows
/// determine when the next drain should be. Splitting them would mean
/// keeping a timer in one place in sync with a list in another.
///
/// The drain is woken by four things, in descending reliability:
/// the periodic backoff timer, an explicit retry, app start, and a
/// connectivity hint. The hint is last on purpose — it reports interface
/// state, not reachability, so it may fire when nothing works and stay
/// silent when everything does (see [ConnectivityMonitor]).
@Riverpod(keepAlive: true)
class OutboxController extends _$OutboxController {
  StreamSubscription<void>? _rows;
  StreamSubscription<void>? _hint;
  Timer? _wake;
  var _draining = false;
  var _disposed = false;

  @override
  AsyncValue<List<OutboxEntry>> build() {
    _disposed = false;
    ref.onDispose(() {
      _disposed = true;
      _wake?.cancel();
      _wake = null;
      unawaited(_rows?.cancel());
      unawaited(_hint?.cancel());
    });

    _subscribe();
    unawaited(Future<void>.microtask(_start));

    // Empty, not loading. The queue is empty in the overwhelming
    // majority of sessions, and every surface that reads it renders
    // nothing when it is — so starting at `AsyncLoading` would make an
    // absent feature briefly visible on screens that should never
    // mention it. A real read replaces this within a frame.
    return const AsyncData<List<OutboxEntry>>([]);
  }

  /// Persists an authorised confirm the network could not deliver.
  ///
  /// Returns `false` when the queue itself could not be written — the
  /// caller then reports the original network failure rather than
  /// telling the user it is safely queued when it is not.
  Future<bool> enqueue({
    required TransferQuote quote,
    required TransferRequest request,
  }) async {
    final result = await ref
        .read(outboxRepositoryProvider)
        .enqueue(quote: quote, request: request);
    return result.isSuccess;
  }

  /// One pass over everything currently due.
  Future<void> drain() async {
    if (_disposed || _draining || !ref.mounted) return;
    // A queued transfer belongs to a session. Draining while signed out
    // would replay it for whoever signs in next; draining while locked
    // would move money behind a lock screen the user raised on purpose.
    //
    // Reading auth can throw if that provider was torn down first during
    // container disposal — dispose order across providers is not ours to
    // assume. `ref.mounted` above handles the common case; the guard
    // here covers the race where our own flag has not flipped yet.
    final Object? session;
    try {
      session = ref.read(authControllerProvider);
    } on Object {
      return;
    }
    if (session is! Authenticated) return;

    _draining = true;
    try {
      // Read the collaborators up front, before the await, so a dispose
      // during delivery cannot make us touch a torn-down `ref`. The
      // drain that is already running finishes against the objects it
      // started with; the guard above stops a *new* drain from starting.
      final drainOutbox = DrainOutbox(
        outbox: ref.read(outboxRepositoryProvider),
        transfers: ref.read(transfersRepositoryProvider),
        clock: ref.read(transferClockProvider),
      );
      await drainOutbox.call(const NoParams());
    } finally {
      _draining = false;
    }
  }

  /// Clears an entry's backoff and drains immediately. Only meaningful
  /// for [OutboxAttention.exhausted] — the other reasons need a new
  /// price, not another attempt.
  Future<void> retry(OutboxEntry entry) async {
    await RetryOutboxEntry(ref.read(outboxRepositoryProvider)).call(entry);
    await drain();
  }

  /// Removes an entry. Used both when the user abandons a dead transfer
  /// and when they accept a re-price, since a re-quote is a new draft
  /// and the old one must never be confirmable again (§38).
  Future<void> discard(String id) async {
    await ref.read(outboxRepositoryProvider).discard(id);
  }

  /// Drops delivered entries once the user has seen they went through.
  Future<void> acknowledgeSent() async {
    await ref.read(outboxRepositoryProvider).clearSent();
  }

  void _subscribe() {
    // Two independent subscriptions, each in its own guard. The rows
    // stream is the queue itself; the connectivity hint is an optional
    // wake source. A platform without the connectivity channel (unit
    // tests, some desktop targets) throws when its EventChannel is first
    // listened to — and that must not also tear down the rows stream, so
    // the two cannot share a try block.
    try {
      _rows = ref.read(outboxRepositoryProvider).watch().listen(
        (result) {
          if (_disposed) return;
          result.fold<void>(
            onSuccess: (entries) {
              state = AsyncData(entries);
              _scheduleWake(entries);
            },
            // Never blank a list we already have: an unreadable queue is
            // a reason to stop trusting the read, not to tell the user
            // their transfers vanished.
            onFailure: (failure) {
              if (!state.hasValue) {
                state = AsyncError(
                  failure,
                  failure.stackTrace ?? StackTrace.current,
                );
              }
            },
          );
        },
        onError: (Object _, StackTrace __) {},
      );
    } on Object {
      // Storage unavailable (e.g. web without the sqlite wasm bundle).
      // The queue is inert rather than broken; nothing else depends on it.
    }

    try {
      _hint = ref.read(connectivityMonitorProvider).onRestored.listen(
            (_) => unawaited(drain()),
            onError: (Object _, StackTrace __) {},
          );
    } on Object {
      // No connectivity channel here. The backoff timer and app-start
      // drain still deliver; we simply lose the "woke up on reconnect"
      // optimization.
    }
  }

  Future<void> _start() async {
    if (_disposed || !ref.mounted) return;
    // Anything left `inFlight` was killed mid-request. Replaying it is
    // safe — the idempotency key returns the original transfer if it
    // actually landed — and assuming it landed would silently drop one.
    try {
      await ref.read(outboxRepositoryProvider).recoverInFlight();
    } on Object {
      return;
    }
    await drain();
  }

  /// Arms a one-shot timer for the soonest entry that is not yet due.
  ///
  /// One timer for the whole queue, re-armed on every row change, rather
  /// than a timer per entry: the queue is a handful of rows at most and
  /// a single wake keeps the delivery order deterministic.
  void _scheduleWake(List<OutboxEntry> entries) {
    _wake?.cancel();
    _wake = null;
    if (_disposed) return;

    final now = ref.read(transferClockProvider)();
    DateTime? soonest;
    for (final entry in entries) {
      if (entry.status != OutboxStatus.pending) continue;
      final at = entry.nextAttemptAt;
      if (at == null) {
        soonest = now;
        break;
      }
      if (soonest == null || at.isBefore(soonest)) soonest = at;
    }
    if (soonest == null) return;

    final delay = soonest.difference(now);
    _wake = Timer(delay.isNegative ? Duration.zero : delay, () {
      if (_disposed) return;
      unawaited(drain());
    });
  }
}
