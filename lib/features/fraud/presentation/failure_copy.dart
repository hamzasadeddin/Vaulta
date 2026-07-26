import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/features/fraud/domain/entities/fraud_alert.dart';

/// User-facing copy for the fraud feature. English-only until the l10n
/// pass in Phase 10, like every other feature's `failure_copy`.

/// One line explaining why a payment was flagged. Leads with the fact
/// that it *might* not be the user — an alert is a question, not an
/// accusation — and never blames them for their own spending.
String fraudReasonCopy(FraudAlert alert) {
  return switch (alert.reason) {
    FraudReason.unusualLocation =>
      'A payment turned up somewhere you don\u2019t usually spend'
          '${alert.location == null ? '' : ' (${alert.location})'}.',
    FraudReason.cardNotPresent =>
      'An online payment was attempted on your ${alert.cardLabel} card.',
    FraudReason.highValue =>
      'A payment much larger than usual was attempted on this card.',
    FraudReason.velocity =>
      'Several payments were attempted on this card in quick succession.',
    FraudReason.unknown =>
      'Something about this payment looked unusual for your card.',
  };
}

/// Why a one-tap freeze didn't take, and what it means for the card.
///
/// Leads with the card's state, because after tapping "Freeze card" the
/// only thing the user needs to know is whether it worked — a failed
/// freeze means the card is *still active* and they should try again.
String fraudFreezeFailureCopy(Object failure) {
  return switch (failure) {
    NetworkFailure() => 'Couldn\u2019t reach Vaulta to freeze the card \u2014 '
        'it\u2019s still active. Check your connection and try again.',
    TimeoutFailure() => 'That timed out and the card may still be active. '
        'Check the Cards tab, and try again if it isn\u2019t frozen.',
    AuthFailure() => 'Your session has expired \u2014 sign in again to '
        'freeze the card.',
    ServerFailure() => 'Something went wrong on our side and the card '
        'wasn\u2019t frozen. Try again.',
    _ => 'The card wasn\u2019t frozen. Try again.',
  };
}
