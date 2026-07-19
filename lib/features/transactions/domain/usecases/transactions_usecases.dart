import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/core/usecase/use_case.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction_filter.dart';
import 'package:vaulta/features/transactions/domain/repositories/transactions_repository.dart';

/// Default feed page size. Lives in the domain layer so the use-case
/// default and every caller reference one value (a presentation constant
/// couldn't be the domain default without an inverted dependency).
const kTransactionsPageSize = 25;

class GetTransactionsParams {
  const GetTransactionsParams({
    required this.filter,
    this.cursor,
    this.limit = kTransactionsPageSize,
  });

  final TransactionFilter filter;
  final String? cursor;
  final int limit;
}

class GetTransactions
    implements UseCase<GetTransactionsParams, TransactionsPage> {
  const GetTransactions(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Result<TransactionsPage, Failure>> call(
    GetTransactionsParams input,
  ) =>
      _repository.getTransactions(
        filter: input.filter,
        cursor: input.cursor,
        limit: input.limit,
      );
}

class GetTransaction implements UseCase<String, Transaction> {
  const GetTransaction(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Result<Transaction, Failure>> call(String input) =>
      _repository.getTransaction(input);
}

class SubmitDisputeParams {
  const SubmitDisputeParams({
    required this.transactionId,
    required this.reason,
  });

  final String transactionId;
  final DisputeReason reason;
}

class SubmitDispute implements UseCase<SubmitDisputeParams, DisputeReceipt> {
  const SubmitDispute(this._repository);

  final TransactionsRepository _repository;

  @override
  Future<Result<DisputeReceipt, Failure>> call(SubmitDisputeParams input) =>
      _repository.submitDispute(
        transactionId: input.transactionId,
        reason: input.reason,
      );
}
