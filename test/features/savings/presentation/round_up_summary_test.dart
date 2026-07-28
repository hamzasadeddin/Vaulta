import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';
import 'package:vaulta/features/savings/presentation/providers/pots_providers.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';

Transaction _txn({
  required String id,
  required Money amount,
  TransactionCategory category = TransactionCategory.shopping,
}) {
  return Transaction(
    id: id,
    accountId: 'acc_chk',
    title: id,
    category: category,
    amount: amount,
    occurredAt: DateTime(2026, 1, 10),
    reference: 'VLT-$id',
  );
}

void main() {
  final rainy = Pot(
    id: 'pot_rainy',
    accountId: 'acc_chk',
    name: 'Rainy Day',
    balance: Money.parse('450.00', Currency.usd),
    roundUpsEnabled: true,
  );

  test('accrues spare change from spends, skipping credits and transfers', () {
    final summary = computeRoundUpSummary(
      pots: [rainy],
      transactions: [
        _txn(id: 't1', amount: Money.parse('-4.30', Currency.usd)), // 0.70
        _txn(id: 't2', amount: Money.parse('-1.99', Currency.usd)), // 0.01
        _txn(
          id: 't3',
          amount: Money.parse('-50.00', Currency.usd),
          category: TransactionCategory.transfer, // excluded
        ),
        _txn(
          id: 't4',
          amount: Money.parse('2500.00', Currency.usd),
          category: TransactionCategory.salary, // credit, excluded
        ),
      ],
    );

    expect(summary.pot, rainy);
    expect(summary.total, Money.parse('0.71', Currency.usd));
    expect(summary.count, 2);
    expect(summary.hasPending, isTrue);
  });

  test('is JOD-correct end to end', () {
    final amman = Pot(
      id: 'pot_amman',
      accountId: 'acc_jod',
      name: 'Amman Fund',
      balance: Money.parse('75.000', Currency.jod),
      roundUpsEnabled: true,
    );
    final summary = computeRoundUpSummary(
      pots: [amman],
      transactions: [
        _txn(id: 'j1', amount: Money.parse('-4.312', Currency.jod)), // 0.688
        _txn(id: 'j2', amount: Money.parse('-0.001', Currency.jod)), // 0.999
      ],
    );

    expect(summary.total, Money.parse('1.687', Currency.jod));
    expect(summary.count, 2);
  });

  test('no enabled pot means nothing pending', () {
    final open = Pot(
      id: 'pot_open',
      accountId: 'acc_chk',
      name: 'Open',
      balance: Money.zero(Currency.usd),
    );
    final summary = computeRoundUpSummary(
      pots: [open],
      transactions: [
        _txn(id: 't1', amount: Money.parse('-4.30', Currency.usd)),
      ],
    );

    expect(summary.pot, isNull);
    expect(summary.hasPending, isFalse);
  });
}
