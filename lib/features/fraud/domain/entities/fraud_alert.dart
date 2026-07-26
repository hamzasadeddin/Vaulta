import 'package:meta/meta.dart';
import 'package:vaulta/core/money/money.dart';

/// Why the bank flagged a payment.
///
/// A closed set with an [unknown] degrade target, the same discipline
/// `CardNetwork`/`CardStatus` use: an alert channel this client doesn't
/// recognize yet must still surface *something the user can act on*
/// rather than be dropped — the freeze is the point, not the label.
enum FraudReason {
  /// Charged far from the cardholder's usual footprint.
  unusualLocation,

  /// Card-not-present — an online or keyed transaction, no chip.
  cardNotPresent,

  /// A single payment well above this card's normal ceiling.
  highValue,

  /// Several payments in quick succession — card-testing behaviour.
  velocity,

  /// Flagged, reason not classified by this client's version.
  unknown,
}

/// Where an alert is in its short life.
///
/// Unlike an outbox entry, an alert is **not** durable and has no
/// server-owned lifecycle to reconcile — it is a notification, and its
/// terminal states are the user's answer to it:
///
/// - [active] — shown, awaiting a decision.
/// - [frozen] — the user froze the card from the alert. Terminal, but
///   held on screen briefly as reassurance ("you're protected") until
///   acknowledged, the same shape as a delivered outbox entry.
/// - [dismissed] — the user said "this was me." Terminal; drops from view.
enum FraudAlertStatus { active, frozen, dismissed }

/// A suspected-fraud notification about one card.
///
/// Self-contained by design. Everything the alert needs to render and to
/// act — the card it concerns, a human label for that card, the payment
/// that tripped it — travels *with* the alert, because the push may land
/// while the cards list has never been loaded (the user hasn't opened the
/// Cards tab this session). The freeze still has to work from here, so
/// the alert carries [cardId] rather than assuming a loaded card.
@immutable
class FraudAlert {
  const FraudAlert({
    required this.id,
    required this.cardId,
    required this.cardLabel,
    required this.cardLast4,
    required this.reason,
    required this.merchant,
    required this.amount,
    required this.detectedAt,
    this.location,
    this.status = FraudAlertStatus.active,
  });

  final String id;

  /// The card to freeze. Not a loaded `BankCard` — an id, so the action
  /// works before (or without) the cards list ever being fetched.
  final String cardId;

  /// Denormalized for offline-legible display, like `OutboxSnapshot`:
  /// the alert must read correctly with nothing else loaded.
  final String cardLabel;
  final String cardLast4;

  final FraudReason reason;
  final String merchant;

  /// The suspect payment, in the card's currency.
  final Money amount;

  final DateTime detectedAt;

  /// Free-text place (`Kraków, PL`), when the reason is location-based.
  final String? location;

  final FraudAlertStatus status;

  bool get isActive => status == FraudAlertStatus.active;

  /// Terminal either way — the user has answered the alert.
  bool get isResolved => status != FraudAlertStatus.active;

  /// The card was frozen from this alert and the user has not yet
  /// dismissed the confirmation.
  bool get wasFrozen => status == FraudAlertStatus.frozen;

  /// After the card is frozen. Terminal, but visible until acknowledged.
  FraudAlert freeze() => _copyWith(status: FraudAlertStatus.frozen);

  /// After "this was me," or after the frozen confirmation is cleared.
  FraudAlert dismiss() => _copyWith(status: FraudAlertStatus.dismissed);

  FraudAlert _copyWith({FraudAlertStatus? status}) => FraudAlert(
        id: id,
        cardId: cardId,
        cardLabel: cardLabel,
        cardLast4: cardLast4,
        reason: reason,
        merchant: merchant,
        amount: amount,
        detectedAt: detectedAt,
        location: location,
        status: status ?? this.status,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FraudAlert &&
          other.id == id &&
          other.cardId == cardId &&
          other.cardLabel == cardLabel &&
          other.cardLast4 == cardLast4 &&
          other.reason == reason &&
          other.merchant == merchant &&
          other.amount == amount &&
          other.detectedAt == detectedAt &&
          other.location == location &&
          other.status == status;

  @override
  int get hashCode => Object.hash(
        id,
        cardId,
        cardLabel,
        cardLast4,
        reason,
        merchant,
        amount,
        detectedAt,
        location,
        status,
      );
}
