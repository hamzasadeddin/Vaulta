import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/history_range.dart';
import 'package:vaulta/features/accounts/domain/entities/statement.dart';

void main() {
  final account = Account(
    id: 'acc_chk',
    name: 'Main Checking',
    type: AccountType.checking,
    iban: 'JO82VBNK0001000000000010204573',
    balance: Money.parse('12480.50', Currency.usd),
    openedAt: DateTime(2022, 3, 14),
  );

  group('Account', () {
    test('ibanTail is the last four characters', () {
      expect(account.ibanTail, '4573');
    });

    test('ibanGrouped chunks in fours, remainder last', () {
      expect(
        account.ibanGrouped,
        'JO82 VBNK 0001 0000 0000 0010 2045 73',
      );
    });

    test('currency is derived from the balance', () {
      expect(account.currency, Currency.usd);
    });

    test('value equality', () {
      final copy = Account(
        id: 'acc_chk',
        name: 'Main Checking',
        type: AccountType.checking,
        iban: 'JO82VBNK0001000000000010204573',
        balance: Money.parse('12480.50', Currency.usd),
        openedAt: DateTime(2022, 3, 14),
      );
      expect(copy, account);
      expect(copy.hashCode, account.hashCode);
    });
  });

  test('HistoryRange maps to API day windows', () {
    expect(HistoryRange.month.days, 30);
    expect(HistoryRange.quarter.days, 90);
    expect(HistoryRange.year.days, 365);
  });

  test('Statement.netChange is closing minus opening', () {
    final statement = Statement(
      id: 'stm_1',
      accountId: 'acc_chk',
      periodStart: DateTime(2026, 6),
      periodEnd: DateTime(2026, 6, 30),
      opening: Money.parse('11000.00', Currency.usd),
      closing: Money.parse('12480.50', Currency.usd),
      transactionCount: 12,
    );
    expect(statement.netChange, Money.parse('1480.50', Currency.usd));
  });
}
