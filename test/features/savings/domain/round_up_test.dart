import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/savings/domain/entities/round_up.dart';

void main() {
  group('RoundUpRule.remainderFor', () {
    const rule = RoundUpRule();

    test('USD rounds up to the next dollar', () {
      expect(
        rule.remainderFor(Money.parse('4.30', Currency.usd)),
        Money.parse('0.70', Currency.usd),
      );
      expect(
        rule.remainderFor(Money.parse('0.01', Currency.usd)),
        Money.parse('0.99', Currency.usd),
      );
      expect(
        rule.remainderFor(Money.parse('12.99', Currency.usd)),
        Money.parse('0.01', Currency.usd),
      );
    });

    // The canary. A rule that assumed 2 minor digits would leave 0.088
    // here (rounding 4.312 to 4.40) instead of 0.688 (rounding to 5.000).
    // JOD has three, so the boundary is 1000 minor units, not 100.
    test('JOD (3 minor digits) rounds up to the next dinar', () {
      expect(
        rule.remainderFor(Money.parse('4.312', Currency.jod)),
        Money.parse('0.688', Currency.jod),
      );
      expect(
        rule.remainderFor(Money.parse('0.001', Currency.jod)),
        Money.parse('0.999', Currency.jod),
      );
      expect(
        rule.remainderFor(Money.parse('1.750', Currency.jod)),
        Money.parse('0.250', Currency.jod),
      );
    });

    // JPY has zero minor digits, so every amount already sits on a unit
    // boundary — there is never anything to round up.
    test('JPY (0 minor digits) always rounds up to nothing', () {
      expect(
        rule.remainderFor(Money.parse('100', Currency.jpy)),
        Money.zero(Currency.jpy),
      );
      expect(
        rule.remainderFor(Money.parse('7', Currency.jpy)),
        Money.zero(Currency.jpy),
      );
    });

    test('a whole amount rounds up to zero', () {
      expect(
        rule.remainderFor(Money.parse('5.00', Currency.usd)),
        Money.zero(Currency.usd),
      );
      expect(
        rule.remainderFor(Money.parse('5.000', Currency.jod)),
        Money.zero(Currency.jod),
      );
    });

    test('a non-positive amount contributes no round-up', () {
      expect(
        rule.remainderFor(Money.zero(Currency.usd)),
        Money.zero(Currency.usd),
      );
      expect(
        rule.remainderFor(Money.parse('-4.30', Currency.usd)),
        Money.zero(Currency.usd),
      );
    });

    test('nearest can round to a larger unit', () {
      const toFive = RoundUpRule(nearest: 5);
      // 12.30 -> next multiple of 5.00 is 15.00 -> 2.70.
      expect(
        toFive.remainderFor(Money.parse('12.30', Currency.usd)),
        Money.parse('2.70', Currency.usd),
      );
      // Already on a 5.00 boundary -> nothing.
      expect(
        toFive.remainderFor(Money.parse('15.00', Currency.usd)),
        Money.zero(Currency.usd),
      );
    });
  });

  group('RoundUpAccrual.accrue', () {
    const accrual = RoundUpAccrual(RoundUpRule());

    test('sums the round-ups of every spend', () {
      final total = accrual.accrue(
        [
          Money.parse('4.30', Currency.usd), // 0.70
          Money.parse('1.99', Currency.usd), // 0.01
          Money.parse('10.00', Currency.usd), // 0.00
        ],
        Currency.usd,
      );
      expect(total, Money.parse('0.71', Currency.usd));
    });

    test('an empty run accrues zero', () {
      expect(
        accrual.accrue(const [], Currency.jod),
        Money.zero(Currency.jod),
      );
    });

    test('is JOD-correct across a run', () {
      final total = accrual.accrue(
        [
          Money.parse('4.312', Currency.jod), // 0.688
          Money.parse('0.001', Currency.jod), // 0.999
        ],
        Currency.jod,
      );
      expect(total, Money.parse('1.687', Currency.jod));
    });

    test('a currency mismatch throws rather than silently mixing', () {
      expect(
        () => accrual.accrue(
          [Money.parse('4.30', Currency.eur)],
          Currency.usd,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
