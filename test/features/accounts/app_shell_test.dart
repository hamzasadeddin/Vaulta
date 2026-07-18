import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/app/shell/app_shell.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/history_range.dart';
import 'package:vaulta/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:vaulta/features/accounts/presentation/accounts_paths.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/accounts/presentation/screens/account_detail_screen.dart';
import 'package:vaulta/features/accounts/presentation/screens/accounts_screen.dart';

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

/// Reproduces the "duplicate GlobalKey" crash: `AdaptiveScaffold` returns a
/// different `Scaffold` subtree per breakpoint, so resizing across one moves
/// the keyed `StatefulNavigationShell`. Without a stable wrapper key that was
/// a hard crash; this test drives the exact transition on the accounts branch
/// (where the expanded layout also mounts the secondary pane) and asserts no
/// framework exception is thrown.
void main() {
  late _MockAccountsRepository repository;

  setUpAll(() => registerFallbackValue(HistoryRange.quarter));

  setUp(() {
    repository = _MockAccountsRepository();
    when(repository.watchAccounts)
        .thenAnswer((_) => Stream.value(Result.success(_accounts)));
    when(repository.refreshAccounts)
        .thenAnswer((_) async => Result.success(_accounts));
    when(() => repository.getHistory(any(), any()))
        .thenAnswer((_) async => const Result.success([]));
    when(() => repository.getStatements(any()))
        .thenAnswer((_) async => const Result.success([]));
  });

  Future<void> resize(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget harness() {
    final router = GoRouter(
      initialLocation: AccountsPaths.root,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              AppShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/',
                  // Stub: this test exercises the shell, not the dashboard,
                  // and the real dashboard branch would pull in network
                  // providers. StatefulShellRoute keeps every branch alive,
                  // so the stub still mounts alongside the accounts branch.
                  builder: (context, state) =>
                      const Scaffold(body: Text('home')),
                ),
              ],
            ),
            StatefulShellBranch(
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

  testWidgets('survives resizing across every breakpoint without crashing',
      (tester) async {
    await resize(tester, const Size(400, 900)); // compact
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);

    await resize(tester, const Size(1400, 900)); // expanded (+ secondary pane)
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);

    await resize(tester, const Size(800, 900)); // medium
    await tester.pumpAndSettle();

    await resize(tester, const Size(400, 900)); // back to compact
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);

    // Any duplicate-GlobalKey reparenting would have surfaced here.
    expect(tester.takeException(), isNull);
  });
}
