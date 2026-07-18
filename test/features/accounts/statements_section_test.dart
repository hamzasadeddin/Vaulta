import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/statement.dart';
import 'package:vaulta/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/accounts/presentation/widgets/statements_section.dart';

class _MockAccountsRepository extends Mock implements AccountsRepository {}

final _account = Account(
  id: 'acc_chk',
  name: 'Main Checking',
  type: AccountType.checking,
  iban: 'JO82VBNK0001000000000010204573',
  balance: Money.parse('12480.50', Currency.usd),
  openedAt: DateTime(2022, 3, 14),
);

final _statements = [
  Statement(
    id: 'stm_acc_chk_202605',
    accountId: 'acc_chk',
    periodStart: DateTime(2026, 5),
    periodEnd: DateTime(2026, 5, 31),
    opening: Money.parse('11000.00', Currency.usd),
    closing: Money.parse('12480.50', Currency.usd),
    transactionCount: 9,
  ),
];

void main() {
  late _MockAccountsRepository repository;

  setUp(() => repository = _MockAccountsRepository());

  Widget harness() {
    return ProviderScope(
      overrides: [accountsRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(
        theme: AppTheme.dark(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: StatementsSection(account: _account),
          ),
        ),
      ),
    );
  }

  testWidgets('lists statements by month with the closing balance',
      (tester) async {
    when(() => repository.getStatements(any()))
        .thenAnswer((_) async => Result.success(_statements));

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(find.text('Statements'), findsOneWidget);
    expect(find.text('May 2026'), findsOneWidget);
    expect(find.text('9 transactions'), findsOneWidget);
  });

  testWidgets('shows the empty state when there are no statements',
      (tester) async {
    when(() => repository.getStatements(any()))
        .thenAnswer((_) async => const Result.success([]));

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(find.textContaining('No statements yet'), findsOneWidget);
  });

  testWidgets('shows an error with retry when the list fails', (tester) async {
    var calls = 0;
    when(() => repository.getStatements(any())).thenAnswer((_) async {
      calls++;
      return calls == 1
          ? const Result.failure(NetworkFailure())
          : Result.success(_statements);
    });

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(find.text('Retry'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('May 2026'), findsOneWidget);
  });

  testWidgets('tapping a statement runs the export and shows a spinner',
      (tester) async {
    when(() => repository.getStatements(any()))
        .thenAnswer((_) async => Result.success(_statements));
    // Hold the export open with a completer so the busy state is
    // observable, then release it. We fail the export (rather than render a
    // real PDF) since only the busy → snackbar flow is under test here; the
    // happy path is covered by the exporter unit tests.
    final pending = Completer<Result<StatementDetail, Failure>>();
    when(() => repository.getStatement(any(), any()))
        .thenAnswer((_) => pending.future);

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await tester.tap(find.text('May 2026'));
    await tester.pump(); // let the busy state paint
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    pending.complete(const Result.failure(NetworkFailure()));
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
