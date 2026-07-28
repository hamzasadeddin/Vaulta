import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';
import 'package:vaulta/features/savings/presentation/providers/pots_providers.dart';
import 'package:vaulta/features/savings/presentation/screens/pots_screen.dart';
import 'package:vaulta/features/savings/presentation/widgets/pots_skeleton.dart';
import 'package:vaulta/features/transactions/presentation/providers/transactions_providers.dart';

Widget _host(AsyncValue<List<Pot>> pots) {
  return ProviderScope(
    overrides: [
      potsControllerProvider.overrideWithValue(pots),
      transactionsFeedControllerProvider.overrideWithValue(
        const AsyncData(TransactionsFeed(items: [], nextCursor: null)),
      ),
    ],
    child: MaterialApp(theme: AppTheme.dark(), home: const PotsScreen()),
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

  testWidgets('lists pots with the create action', (tester) async {
    await tester.pumpWidget(_host(AsyncData([pot])));
    expect(find.text('Rainy Day'), findsOneWidget);
    expect(find.text('New pot'), findsOneWidget);
  });

  testWidgets('shows the empty state with no pots', (tester) async {
    await tester.pumpWidget(_host(const AsyncData(<Pot>[])));
    expect(find.text('No pots yet'), findsOneWidget);
  });

  testWidgets('shows the skeleton while loading', (tester) async {
    await tester.pumpWidget(_host(const AsyncLoading()));
    expect(find.byType(PotsSkeleton), findsOneWidget);
  });

  testWidgets('shows a retry on load failure', (tester) async {
    await tester.pumpWidget(
      _host(const AsyncError(NetworkFailure(), StackTrace.empty)),
    );
    expect(find.text('Try again'), findsOneWidget);
  });
}
