import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';

Pot _pot({
  Money? balance,
  Money? goal,
  bool clearGoalDefault = false,
}) {
  return Pot(
    id: 'pot_1',
    accountId: 'acc_chk',
    name: 'Rainy Day',
    balance: balance ?? Money.parse('450.00', Currency.usd),
    goal: clearGoalDefault
        ? null
        : (goal ?? Money.parse('2000.00', Currency.usd)),
  );
}

void main() {
  group('Pot goal predicates', () {
    test('an open-ended pot has no goal and no finish line', () {
      final pot = _pot(clearGoalDefault: true);
      expect(pot.hasGoal, isFalse);
      expect(pot.goalReached, isFalse);
      expect(pot.remaining, isNull);
      expect(pot.progress, isNull);
    });

    test('goalReached flips once the balance meets the target', () {
      expect(
        _pot(balance: Money.parse('1999.99', Currency.usd)).goalReached,
        isFalse,
      );
      expect(
        _pot(balance: Money.parse('2000.00', Currency.usd)).goalReached,
        isTrue,
      );
      expect(
        _pot(balance: Money.parse('2500.00', Currency.usd)).goalReached,
        isTrue,
      );
    });

    test('remaining is the gap, floored at zero', () {
      expect(
        _pot(balance: Money.parse('450.00', Currency.usd)).remaining,
        Money.parse('1550.00', Currency.usd),
      );
      expect(
        _pot(balance: Money.parse('2500.00', Currency.usd)).remaining,
        Money.zero(Currency.usd),
      );
    });
  });

  group('Pot.progress (display ratio)', () {
    test('is the clamped balance-over-goal fraction', () {
      expect(_pot(balance: Money.parse('500.00', Currency.usd)).progress, 0.25);
      expect(_pot(balance: Money.parse('0.00', Currency.usd)).progress, 0.0);
    });

    test('clamps an over-funded pot to 1', () {
      expect(
        _pot(balance: Money.parse('3000.00', Currency.usd)).progress,
        1.0,
      );
    });

    test('is computed from exact minor units, JOD included', () {
      final pot = Pot(
        id: 'pot_amman',
        accountId: 'acc_jod',
        name: 'Amman Fund',
        balance: Money.parse('75.000', Currency.jod),
        goal: Money.parse('1000.000', Currency.jod),
      );
      expect(pot.progress, closeTo(0.075, 1e-9));
    });
  });

  group('Pot.copyWith', () {
    test('clearGoal drops the target', () {
      final open = _pot().copyWith(clearGoal: true);
      expect(open.hasGoal, isFalse);
    });

    test('replaces balance while preserving identity fields', () {
      final updated =
          _pot().copyWith(balance: Money.parse('900.00', Currency.usd));
      expect(updated.id, 'pot_1');
      expect(updated.accountId, 'acc_chk');
      expect(updated.balance, Money.parse('900.00', Currency.usd));
    });
  });

  test('value equality holds field-by-field', () {
    expect(_pot(), _pot());
    expect(
      _pot(balance: Money.parse('1.00', Currency.usd)),
      isNot(_pot(balance: Money.parse('2.00', Currency.usd))),
    );
  });
}
