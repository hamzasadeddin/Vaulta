import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';
import 'package:vaulta/features/savings/presentation/providers/pots_providers.dart';
import 'package:vaulta/features/savings/presentation/screens/pot_detail_screen.dart';

Widget _host(String potId, List<Pot> pots) {
  return ProviderScope(
    overrides: [
      potsControllerProvider.overrideWithValue(AsyncData(pots)),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      home: PotDetailScreen(potId: potId),
    ),
  );
}

void main() {
  final pot = Pot(
    id: 'pot_rainy',
    accountId: 'acc_chk',
    name: 'Rainy Day',
    balance: Money.parse('450.00', Currency.usd),
    goal: Money.parse('2000.00', Currency.usd),
  );

  testWidgets('renders the pot with add and withdraw actions', (tester) async {
    await tester.pumpWidget(_host('pot_rainy', [pot]));
    expect(find.text('Rainy Day'), findsOneWidget);
    expect(find.text('Add money'), findsOneWidget);
    expect(find.text('Withdraw'), findsOneWidget);
  });

  testWidgets('shows a missing state for an unknown pot', (tester) async {
    await tester.pumpWidget(_host('pot_gone', [pot]));
    expect(find.text('That pot is no longer available.'), findsOneWidget);
  });

  testWidgets('add opens a sheet that rejects a non-positive amount',
      (tester) async {
    await tester.pumpWidget(_host('pot_rainy', [pot]));
    await tester.tap(find.text('Add money'));
    await tester.pumpAndSettle();

    expect(find.text('Add to Rainy Day'), findsOneWidget);
    // Empty amount -> validation blocks before any navigation.
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Enter an amount above zero'), findsOneWidget);
  });

  testWidgets('withdraw rejects more than the pot holds', (tester) async {
    await tester.pumpWidget(_host('pot_rainy', [pot]));
    await tester.tap(find.text('Withdraw'));
    await tester.pumpAndSettle();

    expect(find.text('Withdraw from Rainy Day'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, '999999');
    await tester.tap(find.text('Continue to withdraw'));
    await tester.pumpAndSettle();
    expect(find.text('That\u2019s more than the pot holds'), findsOneWidget);
  });
}
