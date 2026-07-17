import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/auth/domain/repositories/auth_repository.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_providers.dart';
import 'package:vaulta/features/dashboard/domain/entities/account_summary.dart';
import 'package:vaulta/features/dashboard/domain/entities/balance_point.dart';
import 'package:vaulta/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:vaulta/features/dashboard/domain/entities/recent_transaction.dart';
import 'package:vaulta/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:vaulta/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:vaulta/features/dashboard/presentation/screens/dashboard_screen.dart';

class _MockDashboardRepository extends Mock implements DashboardRepository {}

class _MockAuthRepository extends Mock implements AuthRepository {}

final _now = DateTime.now();

final _summary = DashboardSummary(
  accounts: [
    AccountSummary(
      id: 'acc_chk',
      name: 'Main Checking',
      balance: Money.parse('12480.50', Currency.usd),
      history: [
        BalancePoint(
          date: _now.subtract(const Duration(days: 7)),
          balance: Money.parse('12000.00', Currency.usd),
        ),
        BalancePoint(
          date: _now,
          balance: Money.parse('12480.50', Currency.usd),
        ),
      ],
    ),
    AccountSummary(
      id: 'acc_sav',
      name: 'Savings',
      balance: Money.parse('8932.00', Currency.eur),
    ),
  ],
  recentTransactions: [
    RecentTransaction(
      id: 'txn_1',
      accountId: 'acc_chk',
      title: 'Careem',
      category: TransactionCategory.transport,
      amount: Money.parse('-12.50', Currency.usd),
      occurredAt: _now.subtract(const Duration(hours: 2)),
    ),
    RecentTransaction(
      id: 'txn_2',
      accountId: 'acc_chk',
      title: 'Blue Fig Caf\u00e9',
      category: TransactionCategory.dining,
      amount: Money.parse('-4.75', Currency.usd),
      occurredAt: _now.subtract(const Duration(hours: 5)),
      status: TransactionStatus.pending,
    ),
  ],
);

void main() {
  late _MockDashboardRepository dashboard;
  late _MockAuthRepository auth;

  setUp(() {
    dashboard = _MockDashboardRepository();
    auth = _MockAuthRepository();
    // No stored session in this harness; the greeting stays generic.
    when(auth.restoreSession).thenAnswer(
      (_) async => const Result.failure(AuthFailure()),
    );
  });

  Widget harness() {
    return ProviderScope(
      overrides: [
        dashboardRepositoryProvider.overrideWithValue(dashboard),
        authRepositoryProvider.overrideWithValue(auth),
      ],
      child: MaterialApp(
        theme: AppTheme.dark(),
        home: const DashboardScreen(),
      ),
    );
  }

  testWidgets('shows skeletons while loading, then the data', (tester) async {
    when(dashboard.getSummary)
        .thenAnswer((_) async => Result.success(_summary));

    await tester.pumpWidget(harness());
    expect(find.byType(SkeletonBox), findsWidgets);

    await tester.pumpAndSettle();

    expect(find.byType(SkeletonBox), findsNothing);
    expect(find.text(r'$12,480.50'), findsOneWidget);
    expect(find.text('Careem'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
  });

  testWidgets('switching account chips swaps the balance', (tester) async {
    when(dashboard.getSummary)
        .thenAnswer((_) async => Result.success(_summary));

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Savings'));
    await tester.pumpAndSettle();

    expect(find.text('\u20ac8,932.00'), findsOneWidget);
  });

  testWidgets('eye toggle masks the balance', (tester) async {
    when(dashboard.getSummary)
        .thenAnswer((_) async => Result.success(_summary));

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Hide balance'));
    await tester.pump();

    expect(find.text(r'$ ••••'), findsOneWidget);
    expect(find.text(r'$12,480.50'), findsNothing);
  });

  testWidgets('failure shows the error state; retry recovers', (tester) async {
    var calls = 0;
    when(dashboard.getSummary).thenAnswer((_) async {
      calls++;
      return calls == 1
          ? const Result.failure(NetworkFailure())
          : Result.success(_summary);
    });

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(find.textContaining('connection'), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Careem'), findsOneWidget);
  });
}
