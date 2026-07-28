import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/savings/presentation/providers/pots_providers.dart';
import 'package:vaulta/features/savings/presentation/widgets/create_pot_sheet.dart';

import '../support/fake_pots.dart';

final _accounts = [
  Account(
    id: 'acc_chk',
    name: 'Main Checking',
    type: AccountType.checking,
    iban: 'JO82VBNK0001000000000010204573',
    balance: Money.parse('12480.50', Currency.usd),
    openedAt: DateTime(2022, 3, 14),
  ),
];

void main() {
  late FakePotsRepository repo;

  setUp(() => repo = FakePotsRepository());

  Widget harness() {
    return ProviderScope(
      overrides: [
        accountsControllerProvider.overrideWithValue(AsyncData(_accounts)),
        potsRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp(
        theme: AppTheme.dark(),
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => showCreatePotSheet(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('creating a pot calls the repository and closes the sheet',
      (tester) async {
    await tester.pumpWidget(harness());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('New pot'), findsOneWidget);

    // First field is the name; the goal is left blank (open-ended pot).
    await tester.enterText(find.byType(TextField).first, 'Rainy Day');
    await tester.tap(find.text('Create pot'));
    await tester.pumpAndSettle();

    expect(repo.createPotCalls, 1);
    expect(repo.lastCreate?.name, 'Rainy Day');
    expect(repo.lastCreate?.accountId, 'acc_chk');
    expect(repo.lastCreate?.goal, isNull);
    // Sheet dismissed on success.
    expect(find.text('New pot'), findsNothing);
  });

  testWidgets('an empty name blocks submission', (tester) async {
    await tester.pumpWidget(harness());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create pot'));
    await tester.pumpAndSettle();

    expect(repo.createPotCalls, 0);
    expect(find.text('Name your pot'), findsOneWidget);
  });
}
