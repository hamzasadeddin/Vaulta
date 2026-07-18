import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/core/usecase/use_case.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/balance_point.dart';
import 'package:vaulta/features/accounts/domain/entities/history_range.dart';
import 'package:vaulta/features/accounts/domain/entities/statement.dart';
import 'package:vaulta/features/accounts/domain/repositories/accounts_repository.dart';

/// Reactive cached account list (cache-first leg of the staleness policy).
class WatchAccounts implements StreamUseCase<NoParams, List<Account>> {
  const WatchAccounts(this._repository);

  final AccountsRepository _repository;

  @override
  Stream<Result<List<Account>, Failure>> call(NoParams input) =>
      _repository.watchAccounts();
}

/// Network refresh leg: fetches, rewrites the cache, returns fresh data.
class RefreshAccounts implements UseCase<NoParams, List<Account>> {
  const RefreshAccounts(this._repository);

  final AccountsRepository _repository;

  @override
  Future<Result<List<Account>, Failure>> call(NoParams input) =>
      _repository.refreshAccounts();
}

class GetBalanceHistoryParams {
  const GetBalanceHistoryParams({required this.accountId, required this.range});

  final String accountId;
  final HistoryRange range;
}

class GetBalanceHistory
    implements UseCase<GetBalanceHistoryParams, List<BalancePoint>> {
  const GetBalanceHistory(this._repository);

  final AccountsRepository _repository;

  @override
  Future<Result<List<BalancePoint>, Failure>> call(
    GetBalanceHistoryParams input,
  ) =>
      _repository.getHistory(input.accountId, input.range);
}

class GetStatements implements UseCase<String, List<Statement>> {
  const GetStatements(this._repository);

  final AccountsRepository _repository;

  @override
  Future<Result<List<Statement>, Failure>> call(String input) =>
      _repository.getStatements(input);
}

class GetStatementParams {
  const GetStatementParams({
    required this.accountId,
    required this.statementId,
  });

  final String accountId;
  final String statementId;
}

class GetStatement implements UseCase<GetStatementParams, StatementDetail> {
  const GetStatement(this._repository);

  final AccountsRepository _repository;

  @override
  Future<Result<StatementDetail, Failure>> call(GetStatementParams input) =>
      _repository.getStatement(input.accountId, input.statementId);
}
