import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/features/cards/domain/usecases/cards_usecases.dart';
// Presentation-only reads into the cards feature — the same cross-feature
// seam the outbox uses into auth. The freeze is the Phase-7 mechanic
// reused wholesale: this feature adds no second way to freeze a card. It
// depends on the cards *domain* use case (`SetCardFrozen`) plus its
// composition and controller providers, never on cards' data layer.
import 'package:vaulta/features/cards/presentation/providers/cards_providers.dart';
import 'package:vaulta/features/fraud/data/datasources/fraud_alert_feed.dart';
import 'package:vaulta/features/fraud/data/repositories/fraud_repository_impl.dart';
import 'package:vaulta/features/fraud/data/services/noop_fraud_notifier.dart';
import 'package:vaulta/features/fraud/domain/entities/fraud_alert.dart';
import 'package:vaulta/features/fraud/domain/repositories/fraud_repository.dart';
import 'package:vaulta/features/fraud/domain/services/fraud_notifier.dart';

part 'fraud_providers.g.dart';

/// Composition point for the fraud slice. `keepAlive` for the same reason
/// the outbox is: a push can arrive on any screen, and the store that
/// holds it until the user answers must outlive whichever surface first
/// showed it.
@Riverpod(keepAlive: true)
FraudRepository fraudRepository(Ref ref) {
  final repository =
      FraudRepositoryImpl(feed: ref.watch(fraudAlertFeedProvider));
  ref.onDispose(repository.dispose);
  return repository;
}

/// The out-of-app notification port. Defaults to a no-op; Phase 10
/// overrides it with a real local-notifications implementation.
///
/// Hand-written rather than `@riverpod`, the same shape as
/// `transferClockProvider` (§41): it holds no state and needs no
/// disposal, so a plain `Provider` is the right seam — and
/// `overrideWithValue` works on it directly in tests.
final fraudNotifierProvider = Provider<FraudNotifier>(
  (ref) => const NoopFraudNotifier(),
);

/// Owns the alert read model and the two decisions an alert offers:
/// freeze the card, or dismiss it.
///
/// `keepAlive` so a notification posted while the dashboard isn't mounted
/// still fires exactly once. It subscribes to the store on build and
/// pushes each newly-arrived *active* alert to the [FraudNotifier] — the
/// controller is the deduplication point, so the notifier may post
/// unconditionally.
@Riverpod(keepAlive: true)
class FraudAlertController extends _$FraudAlertController {
  StreamSubscription<void>? _rows;
  final Set<String> _notified = {};
  var _disposed = false;

  @override
  AsyncValue<List<FraudAlert>> build() {
    _disposed = false;
    ref.onDispose(() {
      _disposed = true;
      unawaited(_rows?.cancel());
    });

    _subscribe();

    // Empty, not loading: an absent feature must render nothing on the
    // surfaces that read it, never a momentary skeleton. A real read
    // replaces this within a frame. (The same choice the outbox makes.)
    return const AsyncData<List<FraudAlert>>([]);
  }

  /// Freezes the alert's card through the Phase-7 use case, then records
  /// the outcome on the alert. Returns the [Failure] for a snackbar, or
  /// `null` on success.
  ///
  /// The freeze targets a card *id*, not a loaded card, so it works even
  /// if the Cards tab was never opened this session. On success it also
  /// invalidates the cards controller, so an open Cards surface reconciles
  /// to the frozen truth on its next read rather than showing it active.
  Future<Failure?> freezeCard(FraudAlert alert) async {
    final result = await SetCardFrozen(ref.read(cardsRepositoryProvider)).call(
      SetCardFrozenParams(cardId: alert.cardId, frozen: true),
    );
    if (_disposed) return null;

    return result.fold<Failure?>(
      onSuccess: (_) {
        unawaited(ref.read(fraudRepositoryProvider).markFrozen(alert.id));
        // Reconcile any visible Cards surface against server truth. A
        // no-op when the controller isn't currently alive.
        ref.invalidate(cardsControllerProvider);
        return null;
      },
      onFailure: (failure) => failure,
    );
  }

  /// "This was me," or clears a frozen confirmation. Drops the alert.
  Future<void> dismiss(String id) async {
    await ref.read(fraudRepositoryProvider).dismiss(id);
  }

  void _subscribe() {
    try {
      _rows = ref.read(fraudRepositoryProvider).watch().listen(
        (result) {
          if (_disposed) return;
          result.fold<void>(
            onSuccess: (alerts) {
              state = AsyncData(alerts);
              _announce(alerts);
            },
            // Never blank a list we already have — an unreadable store is
            // a reason to stop trusting the read, not to tell the user
            // the alerts vanished.
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
      // Nothing to subscribe to (a silent feed in tests, say). The list
      // stays empty; the feature is simply absent.
    }
  }

  /// Posts an out-of-app notification once per newly-seen active alert.
  void _announce(List<FraudAlert> alerts) {
    final notifier = ref.read(fraudNotifierProvider);
    for (final alert in alerts) {
      if (!alert.isActive) continue;
      if (_notified.add(alert.id)) {
        unawaited(notifier.notify(alert));
      }
    }
  }
}
