import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/accounts/data/datasources/accounts_local_data_source.dart';
import 'package:vaulta/features/accounts/data/datasources/accounts_remote_data_source.dart';
import 'package:vaulta/features/accounts/data/models/account_dtos.dart';
import 'package:vaulta/features/accounts/data/repositories/accounts_repository_impl.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/balance_point.dart';
import 'package:vaulta/features/accounts/domain/entities/history_range.dart';

class _MockRemote extends Mock implements AccountsRemoteDataSource {}

class _MockLocal extends Mock implements AccountsLocalDataSource {}

const _accountDto = AccountDto(
  id: 'acc_chk',
  name: 'Main Checking',
  type: 'checking',
  iban: 'JO82VBNK0001000000000010204573',
  currency: 'USD',
  balanceMinor: 1248050,
  openedAt: '2022-03-14T00:00:00.000',
);

final Account _account = _accountDto.toDomain();

final List<BalancePoint> _points = [
  BalancePoint(
    date: DateTime(2026, 7),
    balance: Money.parse('12000.00', Currency.usd),
  ),
  BalancePoint(
    date: DateTime(2026, 7, 2),
    balance: Money.parse('12480.50', Currency.usd),
  ),
];

DioException _offline() => DioException(
      requestOptions: RequestOptions(path: '/accounts'),
      type: DioExceptionType.connectionError,
    );

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late AccountsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(DateTime(2026));
    registerFallbackValue(HistoryRange.quarter);
    registerFallbackValue(<Account>[]);
    registerFallbackValue(<BalancePoint>[]);
  });

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = AccountsRepositoryImpl(
      remote: remote,
      local: local,
      clock: () => DateTime(2026, 7, 18),
    );
    when(
      () => local.replaceAccounts(any(), fetchedAt: any(named: 'fetchedAt')),
    ).thenAnswer((_) async {});
    when(() => local.replaceHistory(any(), any(), any()))
        .thenAnswer((_) async {});
  });

  group('refreshAccounts', () {
    test('maps DTOs to domain and rewrites the cache', () async {
      when(remote.accounts).thenAnswer(
        (_) async => const AccountsResponseDto(accounts: [_accountDto]),
      );

      final result = await repository.refreshAccounts();

      expect(result.valueOrNull, [_account]);
      expect(
        result.valueOrNull!.first.balance,
        Money.parse('12480.50', Currency.usd),
      );
      verify(
        () => local.replaceAccounts(
          [_account],
          fetchedAt: DateTime(2026, 7, 18),
        ),
      ).called(1);
    });

    test('still succeeds when the cache write blows up', () async {
      when(remote.accounts).thenAnswer(
        (_) async => const AccountsResponseDto(accounts: [_accountDto]),
      );
      when(
        () => local.replaceAccounts(any(), fetchedAt: any(named: 'fetchedAt')),
      ).thenThrow(StateError('no sqlite here'));

      final result = await repository.refreshAccounts();

      expect(result.valueOrNull, [_account]);
    });

    test('maps a connection error to NetworkFailure', () async {
      when(remote.accounts).thenThrow(_offline());

      final result = await repository.refreshAccounts();

      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });

  group('watchAccounts', () {
    test('wraps cache emissions in Result.success', () async {
      when(local.watchAccounts).thenAnswer(
        (_) => Stream.value([_account]),
      );

      final events = await repository.watchAccounts().toList();

      expect(events, hasLength(1));
      expect(events.single.isSuccess, isTrue);
      // Compare the unwrapped list: Result/List `==` is identity-based, but
      // the `equals` matcher deep-compares lists (and Account has value
      // equality), so this asserts contents, not object identity.
      expect(events.single.valueOrNull, [_account]);
    });

    test('maps a broken cache to a single CacheFailure event', () async {
      when(local.watchAccounts).thenAnswer(
        (_) => Stream.error(StateError('cache unavailable')),
      );

      final events = await repository.watchAccounts().toList();

      expect(events, hasLength(1));
      expect(events.single.failureOrNull, isA<CacheFailure>());
    });
  });

  group('getHistory', () {
    test('returns remote points and caches them', () async {
      when(() => remote.history(any(), days: any(named: 'days'))).thenAnswer(
        (_) async => const AccountHistoryDto(
          accountId: 'acc_chk',
          currency: 'USD',
          points: [
            HistoryPointDto(
              date: '2026-07-01T00:00:00.000',
              balanceMinor: 1200000,
            ),
            HistoryPointDto(
              date: '2026-07-02T00:00:00.000',
              balanceMinor: 1248050,
            ),
          ],
        ),
      );

      final result =
          await repository.getHistory('acc_chk', HistoryRange.quarter);

      expect(result.valueOrNull, _points);
      verify(
        () => local.replaceHistory('acc_chk', HistoryRange.quarter, _points),
      ).called(1);
    });

    test('falls back to cached points when offline', () async {
      when(() => remote.history(any(), days: any(named: 'days')))
          .thenThrow(_offline());
      when(() => local.getHistory(any(), any()))
          .thenAnswer((_) async => _points);

      final result =
          await repository.getHistory('acc_chk', HistoryRange.quarter);

      expect(result.valueOrNull, _points);
    });

    test('surfaces the network failure when the cache is empty', () async {
      when(() => remote.history(any(), days: any(named: 'days')))
          .thenThrow(_offline());
      when(() => local.getHistory(any(), any())).thenAnswer((_) async => []);

      final result =
          await repository.getHistory('acc_chk', HistoryRange.quarter);

      expect(result.failureOrNull, isA<NetworkFailure>());
    });

    test('surfaces the network failure when the cache read throws too',
        () async {
      when(() => remote.history(any(), days: any(named: 'days')))
          .thenThrow(_offline());
      when(() => local.getHistory(any(), any()))
          .thenThrow(StateError('cache unavailable'));

      final result =
          await repository.getHistory('acc_chk', HistoryRange.quarter);

      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });

  group('statements', () {
    test('maps the statement list', () async {
      when(() => remote.statements(any())).thenAnswer(
        (_) async => const StatementsResponseDto(
          statements: [
            StatementDto(
              id: 'stm_acc_chk_202606',
              accountId: 'acc_chk',
              periodStart: '2026-06-01T00:00:00.000',
              periodEnd: '2026-06-30T00:00:00.000',
              currency: 'USD',
              openingBalanceMinor: 1100000,
              closingBalanceMinor: 1200000,
              transactionCount: 9,
            ),
          ],
        ),
      );

      final result = await repository.getStatements('acc_chk');

      final statement = result.valueOrNull!.single;
      expect(statement.id, 'stm_acc_chk_202606');
      expect(statement.netChange, Money.parse('1000.00', Currency.usd));
    });

    test('maps statement detail lines with the statement currency', () async {
      when(() => remote.statement(any(), any())).thenAnswer(
        (_) async => const StatementDetailDto(
          id: 'stm_acc_chk_202606',
          accountId: 'acc_chk',
          periodStart: '2026-06-01T00:00:00.000',
          periodEnd: '2026-06-30T00:00:00.000',
          currency: 'USD',
          openingBalanceMinor: 1100000,
          closingBalanceMinor: 1200000,
          transactionCount: 1,
          lines: [
            StatementLineDto(
              id: 'stl_1',
              title: 'Carrefour',
              amountMinor: -8620,
              occurredAt: '2026-06-12T10:30:00.000',
            ),
          ],
        ),
      );

      final result = await repository.getStatement('acc_chk', 'stm_x');

      final detail = result.valueOrNull!;
      expect(detail.lines.single.amount, Money.parse('-86.20', Currency.usd));
    });
  });
}
