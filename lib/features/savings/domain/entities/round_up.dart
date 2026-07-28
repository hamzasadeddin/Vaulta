import 'package:meta/meta.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';

/// Rounds a spend up to the next whole unit and hands back the *remainder*
/// — the spare change that sweeps into a pot.
///
/// The whole rule is integer arithmetic on **minor units**, which is what
/// makes it correct across currencies with different precision. Rounding
/// $4.30 up to $5.00 leaves 70 cents; rounding **4.312 JOD** up to 5.000
/// leaves 0.688 — and a rule that hard-codes 2 minor digits would compute
/// the JOD case wrong. JOD (3 digits) is therefore the canary here, the
/// same way it is for limits and FX elsewhere. No `double` touches this.
@immutable
class RoundUpRule {
  const RoundUpRule({this.nearest = 1})
      : assert(nearest >= 1, 'round up to at least one whole unit');

  /// How many whole major units to round up to — 1 rounds every spend up
  /// to the next whole (`$1`, `1 JOD`); 5 rounds to the next `$5`.
  final int nearest;

  /// The spare change for a single [spend], in the spend's currency.
  ///
  /// Zero for a spend that already sits on a unit boundary (nothing to
  /// round) and for a non-positive amount (a refund or credit is not a
  /// spend). Never negative.
  Money remainderFor(Money spend) {
    if (!spend.isPositive) return Money.zero(spend.currency);
    final unit = _unitMinor(spend.currency);
    final overshoot = spend.minorUnits % unit;
    if (overshoot == BigInt.zero) return Money.zero(spend.currency);
    return Money.fromMinorUnits(unit - overshoot, spend.currency);
  }

  BigInt _unitMinor(Currency currency) =>
      BigInt.from(nearest) * BigInt.from(10).pow(currency.minorUnitDigits);
}

/// Sums the round-ups of many spends into one pending sweep.
///
/// A thin fold over [RoundUpRule], separated from it so the per-spend math
/// and the aggregate can be tested apart. Every spend must be in
/// [currency]: `Money`'s `+` enforces that and throws on a mismatch, which
/// is the honest failure — a total that silently mixed currencies would be
/// worse than none.
@immutable
class RoundUpAccrual {
  const RoundUpAccrual(this.rule);

  final RoundUpRule rule;

  /// Total spare change accrued across [spends], all in [currency].
  Money accrue(Iterable<Money> spends, Currency currency) {
    var total = Money.zero(currency);
    for (final spend in spends) {
      total += rule.remainderFor(spend);
    }
    return total;
  }
}
