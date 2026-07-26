import 'package:vaulta/features/fraud/domain/entities/fraud_alert.dart';
import 'package:vaulta/features/fraud/domain/services/fraud_notifier.dart';

/// The default [FraudNotifier]: does nothing.
///
/// The in-app banner and sheet carry the fraud experience today. This is
/// the deliberate no-op that keeps the controller's notify call honest
/// and side-effect-free until Phase 10 replaces it with a real
/// `flutter_local_notifications` implementation — a dependency the
/// project doesn't yet carry, and one that doesn't run on the Chrome demo
/// target anyway.
class NoopFraudNotifier implements FraudNotifier {
  const NoopFraudNotifier();

  @override
  Future<void> notify(FraudAlert alert) async {}
}
