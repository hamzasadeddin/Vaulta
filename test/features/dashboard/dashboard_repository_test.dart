import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:vaulta/features/dashboard/data/models/dashboard_dtos.dart';
import 'package:vaulta/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:vaulta/features/dashboard/domain/entities/recent_transaction.dart';

class _MockRemote extends Mock implements DashboardRemoteDataSource {}

const _dto = DashboardSummaryDto(
  accounts: [
    AccountSummaryDto(
      id: 'acc_jod',
      name: 'Amman Account',
      currency: 'JOD',
      balanceMinor: 3415750,
      history: [
        BalancePointDto(date: '2026-07-10', balanceMinor: 3000000),
        BalancePointDto(date: '2026-07-16', balanceMinor: 3415750),
      ],
    ),
  ],
  recentTransactions: [
    TransactionDto(
      id: 'txn_1',
      accountId: 'acc_jod',
      title: 'Zain',
      amountMinor: -24500,
      currency: 'JOD',
      occurredAt: '2026-07-15T10:00:00Z',
      category: 'utilities',
      status: 'pending',
    ),
  ],
);

void main() {
  late _MockRemote remote;
  late DashboardRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = DashboardRepositoryImpl(remote: remote);
  });

  group('DashboardRepositoryImpl', () {
    test('maps DTOs to domain at the currency\u2019s precision', () async {
      when(remote.summary).thenAnswer((_) async => _dto);

      final result = await repository.getSummary();

      final summary = result.valueOrNull!;
      final account = summary.accounts.single;
      // JOD carries three minor-unit digits: 3415750 → 3415.750.
      expect(account.balance.amount, Decimal.parse('3415.750'));
      expect(account.currency, Currency.jod);
      // 3000000 → 3415750 is +13.85% (basis points, truncated).
      expect(account.historyChangePercent, Decimal.parse('13.85'));
      expect(account.history, hasLength(2));

      final txn = summary.recentTransactions.single;
      expect(txn.amount.amount, Decimal.parse('-24.500'));
      expect(txn.category, TransactionCategory.utilities);
      expect(txn.isPending, isTrue);
      expect(txn.isCredit, isFalse);
    });

    test('unknown category and status fall back safely', () async {
      when(remote.summary).thenAnswer(
        (_) async => const DashboardSummaryDto(
          accounts: [],
          recentTransactions: [
            TransactionDto(
              id: 'txn_2',
              accountId: 'acc',
              title: 'Mystery',
              amountMinor: 100,
              currency: 'USD',
              occurredAt: '2026-07-15T10:00:00Z',
              category: 'cryptovoodoo',
              status: 'teleported',
            ),
          ],
        ),
      );

      final result = await repository.getSummary();

      final txn = result.valueOrNull!.recentTransactions.single;
      expect(txn.category, TransactionCategory.other);
      expect(txn.status, TransactionStatus.completed);
    });

    test('maps connection errors to NetworkFailure', () async {
      when(remote.summary).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/dashboard/summary'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.getSummary();

      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });
}
