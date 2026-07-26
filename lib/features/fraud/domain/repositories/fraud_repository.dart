import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/fraud/domain/entities/fraud_alert.dart';

/// The alert store. A store, not an engine — it accumulates alerts as
/// they arrive on the push channel and records the user's answer to each,
/// but it makes no decision about freezing a card (that is a use case in
/// the cards feature, reached from the controller).
///
/// Deliberately **not** backed by Drift, unlike the outbox. A queued
/// transfer is money the user was promised would move, so it must survive
/// a force-quit; a fraud alert is a notification, and one that is stale by
/// the next launch is better re-fetched from the server than replayed from
/// disk. Persisting it would also mean persisting the freeze decision,
/// which belongs to the live session. So the store is in memory, fed by
/// the feed, for the lifetime of the app.
abstract interface class FraudRepository {
  /// The current alerts, newest first, re-emitting on every change.
  Stream<Result<List<FraudAlert>, Failure>> watch();

  /// Marks [id] frozen — the card was frozen from this alert. The freeze
  /// itself is the caller's job; this only records the outcome so the
  /// alert stops asking.
  Future<Result<void, Failure>> markFrozen(String id);

  /// Marks [id] dismissed — "this was me," or the frozen confirmation
  /// cleared. Drops from the active view.
  Future<Result<void, Failure>> dismiss(String id);
}
