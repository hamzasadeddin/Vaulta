import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/features/transactions/data/datasources/transactions_remote_data_source.dart';
import 'package:vaulta/features/transactions/data/models/transaction_dtos.dart';
import 'package:vaulta/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction_filter.dart';

class _MockRemote extends Mock implements TransactionsRemoteDataSource {}

const _txnDto = TransactionDto(
  id: 'txn_101',
  accountId: 'acc_chk',
  title: 'Blue Fig Caf\u00e9',
  category: 'dining',
  amountMinor: -475,
  currency: 'USD',
  occurredAt: '2026-07-19T10:24:00.000',
  reference: 'VLT-2026-000001',
  status: 'pending',
);

DioException _offline() => DioException(
      requestOptions: RequestOptions(path: '/transactions'),
      type: DioExceptionType.connectionError,
    );

void main() {
  late _MockRemote remote;
  late TransactionsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const TransactionFilter());
    registerFallbackValue(DisputeReason.other);
  });

  setUp(() {
    remote = _MockRemote();
    repository = TransactionsRepositoryImpl(remote: remote);
  });

  group('getTransactions', () {
    test('maps the page and forwards filter, cursor and limit', () async {
      const filter = TransactionFilter(accountId: 'acc_chk');
      when(
        () => remote.transactions(
          filter: any(named: 'filter'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => const TransactionsPageDto(
          transactions: [_txnDto],
          nextCursor: 'next',
        ),
      );

      final result = await repository.getTransactions(
        filter: filter,
        cursor: 'prev',
        limit: 10,
      );

      final page = result.valueOrNull!;
      expect(page.items.single.id, 'txn_101');
      expect(page.items.single.status, TransactionStatus.pending);
      expect(page.nextCursor, 'next');
      verify(
        () => remote.transactions(filter: filter, cursor: 'prev', limit: 10),
      ).called(1);
    });

    test('a connection error crosses as NetworkFailure, never a throw',
        () async {
      when(
        () => remote.transactions(
          filter: any(named: 'filter'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenThrow(_offline());

      final result = await repository.getTransactions(
        filter: const TransactionFilter(),
      );

      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });

  group('getTransaction', () {
    test('maps the single entry', () async {
      when(() => remote.transaction('txn_101'))
          .thenAnswer((_) async => _txnDto);

      final result = await repository.getTransaction('txn_101');

      expect(result.valueOrNull!.title, 'Blue Fig Caf\u00e9');
    });
  });

  group('submitDispute', () {
    test('maps the acknowledgement', () async {
      when(
        () => remote.submitDispute(
          transactionId: any(named: 'transactionId'),
          reason: any(named: 'reason'),
        ),
      ).thenAnswer(
        (_) async => const DisputeReceiptDto(
          disputeId: 'dsp_1',
          transactionId: 'txn_101',
        ),
      );

      final result = await repository.submitDispute(
        transactionId: 'txn_101',
        reason: DisputeReason.duplicate,
      );

      expect(result.valueOrNull!.id, 'dsp_1');
      verify(
        () => remote.submitDispute(
          transactionId: 'txn_101',
          reason: DisputeReason.duplicate,
        ),
      ).called(1);
    });
  });
}
