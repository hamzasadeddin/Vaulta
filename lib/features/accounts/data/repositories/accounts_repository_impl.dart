import 'dart:async';

import 'package:vaulta/core/error/exception_mapper.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/accounts/data/datasources/accounts_local_data_source.dart';
import 'package:vaulta/features/accounts/data/datasources/accounts_remote_data_source.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/balance_point.dart';
import 'package:vaulta/features/accounts/domain/entities/history_range.dart';
import 'package:vaulta/features/accounts/domain/entities/statement.dart';
import 'package:vaulta/features/accounts/domain/repositories/accounts_repository.dart';

/// Orchestrates remote + Drift cache under the cache-first policy.
///
/// The cache is strictly best-effort: a write failure never fails a
/// successful network call, and a read failure is just a miss. This is what
/// lets the same code run on web without the sqlite wasm bundle — the
/// feature silently degrades to network-only.
class AccountsRepositoryImpl implements AccountsRepository {
  AccountsRepositoryImpl({
    required AccountsRemoteDataSource remote,
    required AccountsLocalDataSource local,
    DateTime Function()? clock,
  })  : _remote = remote,
        _local = local,
        _clock = clock ?? DateTime.now;

  final AccountsRemoteDataSource _remote;
  final AccountsLocalDataSource _local;
  final DateTime Function() _clock;

  @override
  Stream<Result<List<Account>, Failure>> watchAccounts() {
    // A try/catch around `yield*` in an async* generator does NOT catch
    // errors emitted *by* the inner stream — Dart forwards those straight
    // to the listener. So the error-to-value mapping has to live in a
    // transformer, which does see them. An unreadable cache is not fatal:
    // refreshAccounts() still serves the network path.
    return _local.watchAccounts().transform(
          StreamTransformer<List<Account>,
              Result<List<Account>, Failure>>.fromHandlers(
            handleData: (accounts, sink) => sink.add(Result.success(accounts)),
            handleError: (error, stackTrace, sink) => sink.add(
              Result.failure(
                CacheFailure(
                  message: 'Could not read cached accounts',
                  cause: error,
                  stackTrace: stackTrace,
                ),
              ),
            ),
          ),
        );
  }

  @override
  Future<Result<List<Account>, Failure>> refreshAccounts() {
    return runCatching(() async {
      final accounts = (await _remote.accounts()).toDomain();
      await _bestEffort(
        () => _local.replaceAccounts(accounts, fetchedAt: _clock()),
      );
      // Returned directly (not via the cache echo) so callers get fresh
      // data even when the cache is unavailable.
      return accounts;
    });
  }

  @override
  Future<Result<List<BalancePoint>, Failure>> getHistory(
    String accountId,
    HistoryRange range,
  ) async {
    final remoteResult = await runCatching(() async {
      final points = (await _remote.history(accountId, days: range.days))
          .toDomain();
      await _bestEffort(() => _local.replaceHistory(accountId, range, points));
      return points;
    });
    if (remoteResult.isSuccess) return remoteResult;

    // Offline fallback: stale history beats an empty chart.
    final cached = await _bestEffortValue(
      () => _local.getHistory(accountId, range),
    );
    if (cached != null && cached.isNotEmpty) return Result.success(cached);
    return remoteResult;
  }

  @override
  Future<Result<List<Statement>, Failure>> getStatements(String accountId) {
    return runCatching(
      () async => (await _remote.statements(accountId)).toDomain(),
    );
  }

  @override
  Future<Result<StatementDetail, Failure>> getStatement(
    String accountId,
    String statementId,
  ) {
    return runCatching(
      () async => (await _remote.statement(accountId, statementId)).toDomain(),
    );
  }

  /// Cache writes must never take down a successful fetch.
  Future<void> _bestEffort(Future<void> Function() write) async {
    try {
      await write();
    } on Object {
      // Swallowed by design — the cache is an optimization, not a source
      // of truth. The next successful write self-heals it.
    }
  }

  /// Cache reads that fail are just misses.
  Future<T?> _bestEffortValue<T>(Future<T> Function() read) async {
    try {
      return await read();
    } on Object {
      return null;
    }
  }
}
