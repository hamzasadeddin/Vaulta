import 'dart:async';

import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/fraud/data/datasources/fraud_alert_feed.dart';
import 'package:vaulta/features/fraud/domain/entities/fraud_alert.dart';
import 'package:vaulta/features/fraud/domain/repositories/fraud_repository.dart';
import 'package:vaulta/features/fraud/domain/services/fraud_notifier.dart';

/// A fraud alert with sensible defaults, so a test only spells out what
/// it's asserting on.
FraudAlert fraudAlert({
  String id = 'fraud_1',
  String cardId = 'crd_chk_virt',
  FraudReason reason = FraudReason.cardNotPresent,
  FraudAlertStatus status = FraudAlertStatus.active,
  String merchant = 'DIGITALGOODS-INTL',
  String amount = '284.00',
}) {
  return FraudAlert(
    id: id,
    cardId: cardId,
    cardLabel: 'Online shopping',
    cardLast4: '4242',
    reason: reason,
    merchant: merchant,
    amount: Money.parse(amount, Currency.usd),
    detectedAt: DateTime(2026, 7, 24, 12),
    location: 'Online',
    status: status,
  );
}

/// A feed the test drives by hand — the fraud analogue of a controllable
/// connectivity stream. Feeds `FraudRepositoryImpl` in the repository
/// tests.
class ControllableFraudFeed implements FraudAlertFeed {
  final StreamController<FraudAlert> _controller =
      StreamController<FraudAlert>.broadcast(sync: true);

  @override
  Stream<FraudAlert> get alerts => _controller.stream;

  void emit(FraudAlert alert) => _controller.add(alert);

  Future<void> close() => _controller.close();
}

/// In-memory [FraudRepository] for controller tests, so no test builds the
/// real store or its timer-driven feed. Faithful enough to assert against:
/// [push] stores and emits, [markFrozen]/[dismiss] mutate and re-emit, and
/// both record their call counts.
class FakeFraudRepository implements FraudRepository {
  final List<FraudAlert> alerts = [];
  final StreamController<void> _changes = StreamController<void>.broadcast();

  int markFrozenCalls = 0;
  int dismissCalls = 0;

  /// Simulates a push landing on the store.
  void push(FraudAlert alert) {
    alerts.insert(0, alert);
    _changes.add(null);
  }

  @override
  Stream<Result<List<FraudAlert>, Failure>> watch() async* {
    yield Result.success(List.unmodifiable(alerts));
    yield* _changes.stream
        .map((_) => Result.success(List.unmodifiable(alerts)));
  }

  @override
  Future<Result<void, Failure>> markFrozen(String id) async {
    markFrozenCalls++;
    for (var i = 0; i < alerts.length; i++) {
      if (alerts[i].id == id) alerts[i] = alerts[i].freeze();
    }
    _changes.add(null);
    return const Result.success(null);
  }

  @override
  Future<Result<void, Failure>> dismiss(String id) async {
    dismissCalls++;
    alerts.removeWhere((alert) => alert.id == id);
    _changes.add(null);
    return const Result.success(null);
  }

  Future<void> dispose() => _changes.close();
}

/// Records every notification the controller posts, so a test can assert
/// the once-per-alert contract.
class RecordingFraudNotifier implements FraudNotifier {
  final List<String> notified = [];

  @override
  Future<void> notify(FraudAlert alert) async => notified.add(alert.id);
}
