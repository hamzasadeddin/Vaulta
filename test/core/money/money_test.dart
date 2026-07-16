import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';

void main() {
  group('Money.fromMinorUnits', () {
    test('handles 2-digit currencies', () {
      final money = Money.fromMinorUnits(BigInt.from(123456), Currency.usd);
      expect(money.amount, Decimal.parse('1234.56'));
    });

    test('handles 3-digit currencies (JOD)', () {
      final money = Money.fromMinorUnits(BigInt.from(12345), Currency.jod);
      expect(money.amount, Decimal.parse('12.345'));
    });

    test('handles 0-digit currencies (JPY)', () {
      final money = Money.fromMinorUnits(BigInt.from(500), Currency.jpy);
      expect(money.amount, Decimal.fromInt(500));
    });

    test('handles negatives and sub-unit magnitudes', () {
      expect(
        Money.fromMinorUnits(BigInt.from(-5), Currency.usd).amount,
        Decimal.parse('-0.05'),
      );
    });

    test('round-trips through minorUnits', () {
      for (final minor in [0, 1, -1, 999, 100001, -123456789]) {
        final money = Money.fromMinorUnits(BigInt.from(minor), Currency.jod);
        expect(money.minorUnits, BigInt.from(minor));
      }
    });
  });

  group('arithmetic', () {
    final tenUsd = Money.parse('10.00', Currency.usd);
    final threeUsd = Money.parse('3.10', Currency.usd);

    test('adds and subtracts exactly', () {
      // The classic double trap: 0.1 + 0.2.
      final sum = Money.parse('0.1', Currency.usd) +
          Money.parse('0.2', Currency.usd);
      expect(sum.amount, Decimal.parse('0.3'));
      expect((tenUsd - threeUsd).amount, Decimal.parse('6.90'));
    });

    test('negation and abs', () {
      expect((-tenUsd).isNegative, isTrue);
      expect((-tenUsd).abs(), tenUsd);
    });

    test('multiplies by int and Decimal', () {
      expect((threeUsd * 3).amount, Decimal.parse('9.30'));
      expect(
        tenUsd.times(Decimal.parse('0.7095')).rounded().amount,
        Decimal.parse('7.10'),
      );
    });

    test('rejects cross-currency operations', () {
      final jod = Money.parse('10', Currency.jod);
      expect(() => tenUsd + jod, throwsArgumentError);
      expect(() => tenUsd < jod, throwsArgumentError);
      expect(() => tenUsd.compareTo(jod), throwsArgumentError);
    });

    test('comparisons', () {
      expect(threeUsd < tenUsd, isTrue);
      expect(threeUsd <= tenUsd, isTrue);
      expect(tenUsd <= tenUsd, isTrue);
      expect(tenUsd > threeUsd, isTrue);
      expect(tenUsd >= tenUsd, isTrue);
      expect(tenUsd >= threeUsd, isTrue);
      expect(tenUsd < threeUsd, isFalse);
      expect(threeUsd > tenUsd, isFalse);
      expect(Money.zero(Currency.usd).isZero, isTrue);
      expect(tenUsd.isPositive, isTrue);
      expect((-tenUsd).isNegative, isTrue);
    });

    test('compareTo orders and enables sorting', () {
      expect(threeUsd.compareTo(tenUsd), isNegative);
      expect(tenUsd.compareTo(threeUsd), isPositive);
      expect(tenUsd.compareTo(tenUsd), isZero);

      final amounts = [tenUsd, threeUsd, Money.zero(Currency.usd)]..sort();
      expect(amounts.first.isZero, isTrue);
      expect(amounts.last, tenUsd);
    });

    test('rejects the remaining cross-currency comparisons', () {
      final jod = Money.parse('10', Currency.jod);
      expect(() => tenUsd <= jod, throwsArgumentError);
      expect(() => tenUsd > jod, throwsArgumentError);
      expect(() => tenUsd >= jod, throwsArgumentError);
      expect(() => tenUsd - jod, throwsArgumentError);
    });
  });

  group('allocate', () {
    test('splits without losing minor units', () {
      final pot = Money.fromMinorUnits(BigInt.from(100), Currency.usd);
      final parts = pot.allocate([1, 1, 1]);
      expect(
        parts.map((p) => p.minorUnits.toInt()),
        [34, 33, 33],
      );
      final total = parts.reduce((a, b) => a + b);
      expect(total, pot);
    });

    test('respects ratios', () {
      final pot = Money.fromMinorUnits(BigInt.from(1000), Currency.usd);
      final parts = pot.allocate([7, 3]);
      expect(parts[0].minorUnits, BigInt.from(700));
      expect(parts[1].minorUnits, BigInt.from(300));
    });

    test('conserves value for negative amounts', () {
      final debt = Money.fromMinorUnits(BigInt.from(-101), Currency.usd);
      final parts = debt.allocate([1, 2]);
      expect(parts.reduce((a, b) => a + b), debt);
    });

    test('rejects invalid ratios', () {
      final pot = Money.zero(Currency.usd);
      expect(() => pot.allocate([]), throwsArgumentError);
      expect(() => pot.allocate([1, -1]), throwsArgumentError);
      expect(() => pot.allocate([0, 0]), throwsArgumentError);
    });
  });

  group('parsing and equality', () {
    test('parse and tryParse', () {
      expect(
        Money.parse(' 12.345 ', Currency.jod).amount,
        Decimal.parse('12.345'),
      );
      expect(Money.tryParse('not money', Currency.usd), isNull);
      expect(() => Money.parse('abc', Currency.usd), throwsFormatException);
    });

    test('equality is value + currency based', () {
      expect(
        Money.parse('1.50', Currency.usd),
        Money.parse('1.5', Currency.usd),
      );
      expect(
        Money.parse('1.50', Currency.usd),
        isNot(Money.parse('1.50', Currency.jod)),
      );
    });

    test('hashCode agrees with equality', () {
      expect(
        Money.parse('1.50', Currency.usd).hashCode,
        Money.parse('1.5', Currency.usd).hashCode,
      );
      expect(
        Money.parse('1.50', Currency.usd).hashCode,
        isNot(Money.parse('1.50', Currency.jod).hashCode),
      );
    });

    test('toString carries the currency code', () {
      expect(Money.parse('12.345', Currency.jod).toString(), 'JOD 12.345');
    });

    test('Currency.fromCode', () {
      expect(Currency.fromCode('jod'), Currency.jod);
      expect(Currency.tryFromCode('XXX'), isNull);
      expect(() => Currency.fromCode('XXX'), throwsArgumentError);
    });
  });
}
