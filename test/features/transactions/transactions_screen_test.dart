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
import 'package:vaulta/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction_filter.dart';
import 'package:vaulta/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:vaulta/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:vaulta/features/transactions/presentation/screens/transaction_detail_screen.dart';
import 'package:vaulta/features/transactions/presentation/screens/transactions_screen.dart';
import 'package:vaulta/features/transactions/presentation/transactions_paths.dart';
import 'package:vaulta/features/transactions/presentation/widgets/transaction_filter_bar.dart';

class _MockTransactionsRepository extends Mock
    implements TransactionsRepository {}

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
];

final _now = DateTime.now();

final _transactions = [
  Transaction(
    id: 'txn_101',
    accountId: 'acc_chk',
    title: 'Blue Fig Caf\u00e9',
    category: TransactionCategory.dining,
    amount: Money.parse('-4.75', Currency.usd),
    occurredAt: DateTime(_now.year, _now.month, _now.day, 10, 24),
    reference: 'VLT-2026-482913',
    status: TransactionStatus.pending,
  ),
  Transaction(
    id: 'txn_108',
    accountId: 'acc_jod',
    title: 'Zain',
    category: TransactionCategory.utilities,
    amount: Money.parse('-24.500', Currency.jod),
    occurredAt: DateTime(_now.year, _now.month, _now.day - 1, 13, 20),
    reference: 'VLT-2026-771204',
    balanceAfter: Money.parse('3415.750', Currency.jod),
  ),
];

void main() {
  late _MockTransactionsRepository repository;
  late _MockAccountsRepository accountsRepository;

  setUpAll(() {
    registerFallbackValue(const TransactionFilter());
    registerFallbackValue(DisputeReason.other);
  });

  setUp(() {
    repository = _MockTransactionsRepository();
    accountsRepository = _MockAccountsRepository();
    when(accountsRepository.watchAccounts)
        .thenAnswer((_) => Stream.value(Result.success(_accounts)));
    when(accountsRepository.refreshAccounts)
        .thenAnswer((_) async => Result.success(_accounts));
    when(
      () => repository.getTransactions(
        filter: any(named: 'filter'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer(
      (_) async => Result.success(
        TransactionsPage(items: _transactions, nextCursor: null),
      ),
    );
    when(() => repository.getTransaction(any())).thenAnswer(
      (_) async => Result.success(_transactions.first),
    );
  });

  Widget harness() {
    final router = GoRouter(
      initialLocation: TransactionsPaths.root,
      routes: [
        GoRoute(
          path: TransactionsPaths.root,
          builder: (context, state) => TransactionsScreen(
            initialAccountId: state.uri.queryParameters['account'],
          ),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => TransactionDetailScreen(
                transactionId: state.pathParameters['id'] ?? '',
              ),
            ),
          ],
        ),
      ],
    );
    return ProviderScope(
      overrides: [
        transactionsRepositoryProvider.overrideWithValue(repository),
        accountsRepositoryProvider.overrideWithValue(accountsRepository),
      ],
      child: MaterialApp.router(theme: AppTheme.dark(), routerConfig: router),
    );
  }

  testWidgets('shows skeletons, then rows under day headers', (tester) async {
    await tester.pumpWidget(harness());
    expect(find.byType(SkeletonBox), findsWidgets);

    await tester.pumpAndSettle();

    expect(find.byType(SkeletonBox), findsNothing);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('Blue Fig Caf\u00e9'), findsOneWidget);
    // JOD renders 3 minor-unit digits — the canary currency.
    expect(find.textContaining('24.500'), findsOneWidget);
    expect(find.text('That\u2019s everything.'), findsOneWidget);
  });

  testWidgets('an empty unfiltered feed shows the empty state', (tester) async {
    when(
      () => repository.getTransactions(
        filter: any(named: 'filter'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer(
      (_) async => const Result.success(
        TransactionsPage(items: [], nextCursor: null),
      ),
    );

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(find.text('No transactions yet'), findsOneWidget);
  });

  testWidgets('a first-page failure shows retry, which reloads',
      (tester) async {
    when(
      () => repository.getTransactions(
        filter: any(named: 'filter'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => const Result.failure(NetworkFailure()));

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(
      find.text('Can\u2019t reach Vaulta. Check your connection.'),
      findsOneWidget,
    );

    when(
      () => repository.getTransactions(
        filter: any(named: 'filter'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer(
      (_) async => Result.success(
        TransactionsPage(items: _transactions, nextCursor: null),
      ),
    );
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Blue Fig Caf\u00e9'), findsOneWidget);
  });

  testWidgets('search debounces, then requests with the query', (tester) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'fig');
    await tester.pump(
      TransactionFilterBar.debounce + const Duration(milliseconds: 50),
    );
    await tester.pumpAndSettle();

    final captured = verify(
      () => repository.getTransactions(
        filter: captureAny(named: 'filter'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).captured;
    expect((captured.last as TransactionFilter).query, 'fig');
  });

  testWidgets('?account= pre-focuses the feed on that account', (tester) async {
    final router = GoRouter(
      initialLocation: TransactionsPaths.forAccount('acc_chk'),
      routes: [
        GoRoute(
          path: TransactionsPaths.root,
          builder: (context, state) => TransactionsScreen(
            initialAccountId: state.uri.queryParameters['account'],
          ),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionsRepositoryProvider.overrideWithValue(repository),
          accountsRepositoryProvider.overrideWithValue(accountsRepository),
        ],
        child: MaterialApp.router(theme: AppTheme.dark(), routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    final captured = verify(
      () => repository.getTransactions(
        filter: captureAny(named: 'filter'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).captured;
    expect((captured.last as TransactionFilter).accountId, 'acc_chk');
  });

  testWidgets('opens the receipt from a row, showing reference and balance',
      (tester) async {
    when(() => repository.getTransaction('txn_108')).thenAnswer(
      (_) async => Result.success(_transactions.last),
    );

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Zain'));
    await tester.pumpAndSettle();

    expect(find.text('VLT-2026-771204'), findsOneWidget);
    expect(find.text('Balance after'), findsOneWidget);
    expect(find.textContaining('3,415.750'), findsOneWidget);
    expect(find.text('Report an issue'), findsOneWidget);
  });

  testWidgets('the dispute sheet submits and confirms with the reference',
      (tester) async {
    when(
      () => repository.submitDispute(
        transactionId: any(named: 'transactionId'),
        reason: any(named: 'reason'),
      ),
    ).thenAnswer(
      (_) async => const Result.success(
        DisputeReceipt(id: 'dsp_7', transactionId: 'txn_101'),
      ),
    );

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Blue Fig Caf\u00e9'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Report an issue'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('I was charged twice'));
    await tester.pump();
    await tester.tap(find.text('Submit dispute'));
    await tester.pumpAndSettle();

    verify(
      () => repository.submitDispute(
        transactionId: 'txn_101',
        reason: DisputeReason.duplicate,
      ),
    ).called(1);
    expect(find.textContaining('dsp_7'), findsOneWidget);
  });
}
