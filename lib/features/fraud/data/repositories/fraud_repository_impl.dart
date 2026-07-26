import 'dart:async';

import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/fraud/data/datasources/fraud_alert_feed.dart';
import 'package:vaulta/features/fraud/domain/entities/fraud_alert.dart';
import 'package:vaulta/features/fraud/domain/repositories/fraud_repository.dart';

/// In-memory alert store, fed by [FraudAlertFeed].
///
/// The store accumulates alerts as they arrive and holds them newest
/// first. It is intentionally not durable — see [FraudRepository] for why
/// a notification, unlike a queued transfer, is not persisted across a
/// relaunch.
class FraudRepositoryImpl implements FraudRepository {
  FraudRepositoryImpl({required FraudAlertFeed feed}) : _feed = feed {
    // A push that arrives while nothing is listening must not be lost —
    // the whole point of the store is to hold it until a surface reads
    // it — so the subscription is opened here, at construction, not on
    // first `watch()`.
    _subscription = _feed.alerts.listen(
      _ingest,
      onError: (Object _, StackTrace __) {},
    );
  }

  final FraudAlertFeed _feed;
  final List<FraudAlert> _alerts = [];
  final StreamController<void> _changes = StreamController<void>.broadcast();
  StreamSubscription<FraudAlert>? _subscription;

  @override
  Stream<Result<List<FraudAlert>, Failure>> watch() async* {
    yield Result.success(_snapshot());
    yield* _changes.stream.map((_) => Result.success(_snapshot()));
  }

  @override
  Future<Result<void, Failure>> markFrozen(String id) async {
    _mutate(id, (alert) => alert.freeze());
    return const Result.success(null);
  }

  @override
  Future<Result<void, Failure>> dismiss(String id) async {
    final removed = _alerts.length;
    _alerts.removeWhere((alert) => alert.id == id);
    if (_alerts.length != removed) _changes.add(null);
    return const Result.success(null);
  }

  void _ingest(FraudAlert alert) {
    // Idempotent on id: the feed emits each event once, but a resilient
    // store should never double-count if it doesn't.
    if (_alerts.any((existing) => existing.id == alert.id)) return;
    _alerts.insert(0, alert);
    _changes.add(null);
  }

  void _mutate(String id, FraudAlert Function(FraudAlert) transform) {
    var changed = false;
    for (var i = 0; i < _alerts.length; i++) {
      if (_alerts[i].id == id) {
        _alerts[i] = transform(_alerts[i]);
        changed = true;
      }
    }
    if (changed) _changes.add(null);
  }

  List<FraudAlert> _snapshot() => List.unmodifiable(_alerts);

  void dispose() {
    unawaited(_subscription?.cancel());
    unawaited(_changes.close());
  }
}
