import 'package:vaulta/features/fraud/domain/entities/fraud_alert.dart';

/// The out-of-app notification surface for a fraud alert.
///
/// A port, not an implementation. The spec asks for fraud alerts "via
/// push," but the app runs fully offline against a mock with no backend
/// to push from and Chrome as the demo target, so there is nothing real
/// to deliver a system notification *from* yet. The in-app banner and
/// sheet are the working surface; this seam is where a real
/// `flutter_local_notifications` (or FCM foreground handler) is dropped in
/// during Phase 10 without touching the controller that calls it.
///
/// Called once per newly-arrived active alert — the controller
/// deduplicates, so an implementation may post unconditionally.
// ignore: one_member_abstracts
abstract interface class FraudNotifier {
  Future<void> notify(FraudAlert alert);
}
