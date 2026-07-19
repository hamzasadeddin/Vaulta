import 'package:vaulta/core/error/exception_mapper.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/transactions/data/datasources/transactions_remote_data_source.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction_filter.dart';
import 'package:vaulta/features/transactions/domain/repositories/transactions_repository.dart';

/// Remote-only implementation — see the repository contract for why the
/// paginated feed deliberately has no Drift cache.
class TransactionsRepositoryImpl implements TransactionsRepository {
  const TransactionsRepositoryImpl({
    required TransactionsRemoteDataSource remote,
  }) : _remote = remote;

  final TransactionsRemoteDataSource _remote;

  @override
  Future<Result<TransactionsPage, Failure>> getTransactions({
    required TransactionFilter filter,
    String? cursor,
    int limit = 25,
  }) {
    return runCatching(() async {
      final page = await _remote.transactions(
        filter: filter,
        cursor: cursor,
        limit: limit,
      );
      return page.toDomain();
    });
  }

  @override
  Future<Result<Transaction, Failure>> getTransaction(String transactionId) {
    return runCatching(
      () async => (await _remote.transaction(transactionId)).toDomain(),
    );
  }

  @override
  Future<Result<DisputeReceipt, Failure>> submitDispute({
    required String transactionId,
    required DisputeReason reason,
  }) {
    return runCatching(
      () async => (await _remote.submitDispute(
        transactionId: transactionId,
        reason: reason,
      ))
          .toDomain(),
    );
  }
}
