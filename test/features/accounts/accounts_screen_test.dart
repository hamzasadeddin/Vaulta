import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/balance_point.dart';
import 'package:vaulta/features/accounts/domain/entities/history_range.dart';
import 'package:vaulta/features/accounts/domain/entities/statement.dart';
import 'package:vaulta/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:vaulta/features/accounts/presentation/accounts_paths.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/accounts/presentation/screens/account_detail_screen.dart';
import 'package:vaulta/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:vaulta/features/accounts/presentation/widgets/balance_history_chart.dart';

class _MockAccountsRepository extends Mock implements AccountsRepository {}

final _accounts = [
  Account(
    id: 'acc_chk',
    name: 'Main Checking',
    type: AccountType.checking,
    iban: 'JO82VBNK0001000000000010204573',
    balance: Money.parse('12480.50', Currency.usd),
    openedAt: DateTime(2022, 3, 14),
  ),
  Account(
    id: 'acc_jod',
    name: 'Amman Account',
    type: AccountType.checking,
    iban: 'JO73VBNK0002000000000010209981',
    balance: Money.parse('3415.750', Currency.jod),
    openedAt: DateTime(2021, 11, 20),
  ),
];

final List<BalancePoint> _points = [
  for (var i = 0; i < 8; i++)
    BalancePoint(
      date: DateTime(2026, 7, 1 + i),
      balance: Money.parse('${12000 + i * 50}.00', Currency.usd),
    ),
];

final _statement = Statement(
  id: 'stm_acc_chk_202606',
  accountId: 'acc_chk',
  periodStart: DateTime(2026, 6),
  periodEnd: DateTime(2026, 6, 30),
  opening: Money.parse('11000.00', Currency.usd),
  closing: Money.parse('12000.00', Currency.usd),
  transactionCount: 9,
);

void main() {
  late _MockAccountsRepository repository;

  setUpAll(() {
    registerFallbackValue(HistoryRange.quarter);
  });

  setUp(() {
    repository = _MockAccountsRepository();
    when(repository.watchAccounts)
        .thenAnswer((_) => Stream.value(Result.success(_accounts)));
    when(repository.refreshAccounts)
        .thenAnswer((_) async => Result.success(_accounts));
    when(() => repository.getHistory(any(), any()))
        .thenAnswer((_) async => Result.success(_points));
    when(() => repository.getStatements(any()))
        .thenAnswer((_) async => Result.success([_statement]));
  });

  Widget harness() {
    final router = GoRouter(
      initialLocation: AccountsPaths.root,
      routes: [
        GoRoute(
          path: AccountsPaths.root,
          builder: (context, state) => const AccountsScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => AccountDetailScreen(
                accountId: state.pathParameters['id'] ?? '',
              ),
            ),
          ],
        ),
      ],
    );
    return ProviderScope(
      overrides: [accountsRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(theme: AppTheme.dark(), routerConfig: router),
    );
  }

  testWidgets('shows skeletons, then every account with its balance',
      (tester) async {
    await tester.pumpWidget(harness());
    expect(find.byType(SkeletonBox), findsWidgets);

    await tester.pumpAndSettle();

    expect(find.byType(SkeletonBox), findsNothing);
    expect(find.text('Main Checking'), findsOneWidget);
    expect(find.text('Amman Account'), findsOneWidget);
    expect(find.textContaining('12,480.50'), findsOneWidget);
    // JOD renders 3 minor-unit digits — the canary currency.
    expect(find.textContaining('3,415.750'), findsOneWidget);
  });

  testWidgets('opens the detail screen from a tile', (tester) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Main Checking'));
    await tester.pumpAndSettle();

    expect(find.text('Balance history'), findsOneWidget);
    expect(find.byType(BalanceHistoryChart), findsOneWidget);
    expect(
      find.text('JO82 VBNK 0001 0000 0000 0010 2045 73'),
      findsOneWidget,
    );
    expect(find.text('June 2026'), findsOneWidget);
  });

  testWidgets('switching the range requests that window', (tester) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Main Checking'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('1Y'));
    await tester.pumpAndSettle();

    verify(() => repository.getHistory('acc_chk', HistoryRange.year)).called(1);
  });

  testWidgets('shows the error state when refresh fails with a cold cache',
      (tester) async {
    when(repository.watchAccounts).thenAnswer((_) => const Stream.empty());
    when(repository.refreshAccounts)
        .thenAnswer((_) async => const Result.failure(NetworkFailure()));

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(find.text('Couldn\u2019t load your accounts'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });
}
