import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/fraud/domain/entities/fraud_alert.dart';

/// The inbound push channel for fraud alerts.
///
/// Modelled on `ConnectivityMonitor`, and for the same reason: it is a
/// *side channel*, not a request/response call, so it lives outside Dio
/// and the `MockApiInterceptor` rather than being faked as a REST route.
/// A real build swaps in an FCM foreground stream behind this interface;
/// the freeze that an alert triggers still goes through the real
/// `/cards/:id/freeze` endpoint.
///
/// It emits domain [FraudAlert]s directly — no DTO. There is no wire
/// format or database here to map at a boundary (again like
/// `ConnectivityMonitor`, which carries no payload at all); a real FCM
/// payload in Phase 10 would introduce a `FraudAlertDto` at *that*
/// boundary, where it would earn its place.
abstract interface class FraudAlertFeed {
  /// Fires once per suspected-fraud event. Broadcast: several widgets may
  /// listen, and a late listener simply misses earlier events (the
  /// repository is what accumulates them).
  Stream<FraudAlert> get alerts;
}

/// Synthesizes a single, seed-stable alert shortly after start, so a
/// reviewer sees the whole flow — banner → sheet → one-tap freeze —
/// without a backend.
///
/// It names a **real** mock card (`crd_chk_virt`, the "Online shopping"
/// virtual card) so the freeze it triggers reconciles against the same
/// `/cards` state the Cards tab shows. Card-not-present on a virtual card
/// is the honest reason for that instrument. One alert, once — not a
/// repeating spam timer.
class MockFraudAlertFeed implements FraudAlertFeed {
  MockFraudAlertFeed({this.initialDelay = const Duration(seconds: 4)}) {
    _timer = Timer(initialDelay, _emitSeedAlert);
  }

  /// How long after start the demo alert lands. A few seconds so the
  /// dashboard has painted first and the banner's arrival is visible.
  final Duration initialDelay;

  final _controller = StreamController<FraudAlert>.broadcast(sync: true);
  Timer? _timer;

  @override
  Stream<FraudAlert> get alerts => _controller.stream;

  void _emitSeedAlert() {
    if (_controller.isClosed) return;
    _controller.add(
      FraudAlert(
        id: 'fraud_seed_1',
        cardId: 'crd_chk_virt',
        cardLabel: 'Online shopping',
        cardLast4: '••••',
        reason: FraudReason.cardNotPresent,
        merchant: 'DIGITALGOODS-INTL',
        amount: Money.parse('284.00', Currency.usd),
        detectedAt: DateTime.now(),
        location: 'Online',
      ),
    );
  }

  void dispose() {
    _timer?.cancel();
    unawaited(_controller.close());
  }
}

/// A feed that never fires. Overridden in every widget test that builds
/// the dashboard (the fraud banner listens to this) so the platform-free
/// timer above never runs in the test tree — the same role
/// `SilentConnectivityMonitor` plays for the outbox.
class SilentFraudAlertFeed implements FraudAlertFeed {
  const SilentFraudAlertFeed();

  @override
  Stream<FraudAlert> get alerts => const Stream<FraudAlert>.empty();
}

/// Overridden in tests with a controllable feed.
final fraudAlertFeedProvider = Provider<FraudAlertFeed>((ref) {
  final feed = MockFraudAlertFeed();
  ref.onDispose(feed.dispose);
  return feed;
});
