import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';
import 'package:vaulta/features/savings/presentation/providers/pots_providers.dart';
import 'package:vaulta/features/savings/presentation/widgets/round_up_card.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/presentation/providers/transactions_providers.dart';

Transaction _spend(String id, Money amount) => Transaction(
      id: id,
      accountId: 'acc_chk',
      title: id,
      category: TransactionCategory.shopping,
      amount: amount,
      occurredAt: DateTime(2026, 1, 10),
      reference: 'VLT-$id',
    );

Widget _host({
  required List<Pot> pots,
  required List<Transaction> items,
}) {
  return ProviderScope(
    overrides: [
      potsControllerProvider.overrideWithValue(AsyncData(pots)),
      transactionsFeedControllerProvider.overrideWithValue(
        AsyncData(TransactionsFeed(items: items, nextCursor: null)),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      home: const Scaffold(body: RoundUpCard()),
    ),
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

  testWidgets('shows the pending sweep and target pot', (tester) async {
    await tester.pumpWidget(
      _host(
        pots: [rainy],
        items: [_spend('t1', Money.parse('-4.30', Currency.usd))],
      ),
    );
    expect(find.text('Spare change'), findsOneWidget);
    expect(find.text('Add to Rainy Day'), findsOneWidget);
  });

  testWidgets('is invisible when no pot has round-ups on', (tester) async {
    await tester.pumpWidget(
      _host(
        pots: [rainy.copyWith(roundUpsEnabled: false)],
        items: [_spend('t1', Money.parse('-4.30', Currency.usd))],
      ),
    );
    expect(find.text('Spare change'), findsNothing);
  });
}
