import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/balance_point.dart';
import 'package:vaulta/features/accounts/domain/entities/history_range.dart';
import 'package:vaulta/features/accounts/domain/entities/statement.dart';

/// Domain contract for the accounts feature.
///
/// Staleness policy (decided in Phase 5): **cache-first with background
/// refresh.** [watchAccounts] paints instantly from the local cache;
/// [refreshAccounts] fetches, rewrites the cache (best effort) and returns
/// the fresh list so callers never depend on the cache working.
abstract interface class AccountsRepository {
  /// Reactive view of the cached account list. Emits on every cache write.
  /// A cache that cannot be read yields a single `CacheFailure` — never an
  /// exception.
  Stream<Result<List<Account>, Failure>> watchAccounts();

  /// Network fetch + cache rewrite. Returns the fetched accounts.
  Future<Result<List<Account>, Failure>> refreshAccounts();

  /// Network-first with cache fallback: stale history beats an empty chart
  /// when offline.
  Future<Result<List<BalancePoint>, Failure>> getHistory(
    String accountId,
    HistoryRange range,
  );

  Future<Result<List<Statement>, Failure>> getStatements(String accountId);

  Future<Result<StatementDetail, Failure>> getStatement(
    String accountId,
    String statementId,
  );
}
