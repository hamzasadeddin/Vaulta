import 'package:meta/meta.dart';
import 'package:vaulta/core/money/money.dart';

enum CardType { physical, virtual }

/// `unknown` is the degrade target for networks this client doesn't know
/// yet — mapping an unrecognized scheme onto Visa or Mastercard would be
/// dishonest labeling on a payment instrument.
enum CardNetwork { visa, mastercard, unknown }

enum CardStatus { active, frozen }

/// Spending limits plus current usage, all in the card's currency.
@immutable
class CardLimits {
  const CardLimits({
    required this.daily,
    required this.monthly,
    required this.spentToday,
    required this.spentThisMonth,
  });

  final Money daily;
  final Money monthly;
  final Money spentToday;
  final Money spentThisMonth;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardLimits &&
          other.daily == daily &&
          other.monthly == monthly &&
          other.spentToday == spentToday &&
          other.spentThisMonth == spentThisMonth;

  @override
  int get hashCode => Object.hash(daily, monthly, spentToday, spentThisMonth);
}

/// A payment card linked to one account. Carries only the last four PAN
/// digits — the full number never enters this aggregate; it lives in the
/// short-lived [CardPan] returned by an explicit, gated reveal.
@immutable
class BankCard {
  const BankCard({
    required this.id,
    required this.accountId,
    required this.label,
    required this.type,
    required this.network,
    required this.status,
    required this.panLast4,
    required this.expiryMonth,
    required this.expiryYear,
    required this.limits,
  });

  final String id;
  final String accountId;
  final String label;
  final CardType type;
  final CardNetwork network;
  final CardStatus status;
  final String panLast4;
  final int expiryMonth;
  final int expiryYear;
  final CardLimits limits;

  bool get isFrozen => status == CardStatus.frozen;

  /// `09/28` — the embossed format.
  String get expiryLabel => '${expiryMonth.toString().padLeft(2, '0')}/'
      '${(expiryYear % 100).toString().padLeft(2, '0')}';

  /// Narrow on purpose: only the fields mutations touch (the optimistic
  /// freeze flip). Everything else is server-owned and arrives whole.
  BankCard copyWith({CardStatus? status, CardLimits? limits}) {
    return BankCard(
      id: id,
      accountId: accountId,
      label: label,
      type: type,
      network: network,
      status: status ?? this.status,
      panLast4: panLast4,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      limits: limits ?? this.limits,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankCard &&
          other.id == id &&
          other.accountId == accountId &&
          other.label == label &&
          other.type == type &&
          other.network == network &&
          other.status == status &&
          other.panLast4 == panLast4 &&
          other.expiryMonth == expiryMonth &&
          other.expiryYear == expiryYear &&
          other.limits == limits;

  @override
  int get hashCode => Object.hash(
        id,
        accountId,
        label,
        type,
        network,
        status,
        panLast4,
        expiryMonth,
        expiryYear,
        limits,
      );
}

/// The sensitive payload of a PAN reveal. Treated as a secret, not a
/// string: [toString] is masked so a stray log statement, error report or
/// debug dump can never print the number, and holders are expected to drop
/// it quickly (the presentation layer auto-hides after a timeout).
@immutable
class CardPan {
  const CardPan({
    required this.pan,
    required this.cvv,
    required this.expiryMonth,
    required this.expiryYear,
  });

  final String pan;
  final String cvv;
  final int expiryMonth;
  final int expiryYear;

  /// `4111 2222 3333 4444` — grouped for display.
  String get grouped {
    final buffer = StringBuffer();
    for (var i = 0; i < pan.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(pan[i]);
    }
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardPan &&
          other.pan == pan &&
          other.cvv == cvv &&
          other.expiryMonth == expiryMonth &&
          other.expiryYear == expiryYear;

  @override
  int get hashCode => Object.hash(pan, cvv, expiryMonth, expiryYear);

  @override
  String toString() {
    final tail = pan.length < 4 ? '????' : pan.substring(pan.length - 4);
    // Never the PAN or CVV — this type may cross logging code paths.
    return 'CardPan(\u2022\u2022\u2022\u2022 $tail)';
  }
}
