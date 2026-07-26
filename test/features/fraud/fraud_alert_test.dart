import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/features/fraud/domain/entities/fraud_alert.dart';

import 'support/fake_fraud.dart';

void main() {
  group('FraudAlert', () {
    test('a fresh alert is active and unresolved', () {
      final alert = fraudAlert();
      expect(alert.isActive, isTrue);
      expect(alert.isResolved, isFalse);
      expect(alert.wasFrozen, isFalse);
    });

    test('freeze() moves to a resolved-but-visible frozen state', () {
      final frozen = fraudAlert().freeze();
      expect(frozen.status, FraudAlertStatus.frozen);
      expect(frozen.isActive, isFalse);
      expect(frozen.isResolved, isTrue);
      expect(frozen.wasFrozen, isTrue);
    });

    test('dismiss() is terminal and not a frozen confirmation', () {
      final dismissed = fraudAlert().dismiss();
      expect(dismissed.status, FraudAlertStatus.dismissed);
      expect(dismissed.isResolved, isTrue);
      expect(dismissed.wasFrozen, isFalse);
    });

    test('a transition preserves every other field', () {
      final alert = fraudAlert(reason: FraudReason.velocity);
      final frozen = alert.freeze();
      expect(frozen.id, alert.id);
      expect(frozen.cardId, alert.cardId);
      expect(frozen.cardLabel, alert.cardLabel);
      expect(frozen.reason, alert.reason);
      expect(frozen.merchant, alert.merchant);
      expect(frozen.amount, alert.amount);
      expect(frozen.detectedAt, alert.detectedAt);
      expect(frozen.location, alert.location);
    });

    test('value equality ignores identity but respects status', () {
      expect(fraudAlert(), equals(fraudAlert()));
      expect(fraudAlert().hashCode, fraudAlert().hashCode);
      expect(fraudAlert().freeze(), isNot(equals(fraudAlert())));
    });
  });
}
