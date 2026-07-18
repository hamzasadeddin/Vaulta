import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/network/network_providers.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/core/storage/storage_providers.dart';
import 'package:vaulta/core/usecase/use_case.dart';
import 'package:vaulta/features/accounts/data/datasources/accounts_local_data_source.dart';
import 'package:vaulta/features/accounts/data/datasources/accounts_remote_data_source.dart';
import 'package:vaulta/features/accounts/data/repositories/accounts_repository_impl.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/balance_point.dart';
import 'package:vaulta/features/accounts/domain/entities/history_range.dart';
import 'package:vaulta/features/accounts/domain/entities/statement.dart';
import 'package:vaulta/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:vaulta/features/accounts/domain/usecases/accounts_usecases.dart';
import 'package:vaulta/features/accounts/presentation/pdf/statement_exporter.dart';

part 'accounts_providers.g.dart';

/// Composition point for the accounts slice. Tests override this with a
/// mocked [AccountsRepository] — the same seam as every other feature.
@riverpod
AccountsRepository accountsRepository(Ref ref) {
  return AccountsRepositoryImpl(
    remote: AccountsRemoteDataSource(ref.watch(dioProvider)),
    local: DriftAccountsLocalDataSource(ref.watch(appDatabaseProvider)),
  );
}

@riverpod
StatementExporter statementExporter(Ref ref) {
  return StatementExporter(repository: ref.watch(accountsRepositoryProvider));
}

/// Accounts read model, implementing the cache-first policy at the
/// controller level:
///
/// 1. subscribe to the Drift stream — a warm cache paints instantly;
/// 2. kick a network refresh — its result lands both directly (so the UI
///    works with a broken cache) and via the cache echo.
///
/// autoDispose: leaving the signed-in shell tears it down; the on-disk
/// cache itself survives for the next session.
@riverpod
class AccountsController extends _$AccountsController {
  var _disposed = false;

  @override
  AsyncValue<List<Account>> build() {
    _disposed = false;

    final subscription = WatchAccounts(ref.watch(accountsRepositoryProvider))
        .call(const NoParams())
        .listen(_onCacheEvent);
    ref.onDispose(() {
      _disposed = true;
      unawaited(subscription.cancel());
    });

    // Kick the refresh after build returns — writing state during build
    // is illegal, and this keeps first-frame cost flat.
    unawaited(Future<void>.microtask(_refresh));
    return const AsyncLoading();
  }

  /// Pull-to-refresh. Returns the failure (for a snackbar) instead of
  /// clobbering already-visible data with an error state.
  Future<Failure?> refresh() => _refresh();

  void _onCacheEvent(Result<List<Account>, Failure> event) {
    if (_disposed) return;
    event.onSuccess((accounts) {
      // An empty emission with nothing on screen is a cold cache — keep
      // the skeleton until the network answers rather than flashing an
      // empty state (or overwriting an error with []).
      if (accounts.isEmpty && !state.hasValue) return;
      state = AsyncData(accounts);
    });
    // A CacheFailure alone is never terminal — the refresh path decides.
  }

  Future<Failure?> _refresh() async {
    final result = await RefreshAccounts(ref.read(accountsRepositoryProvider))
        .call(const NoParams());
    if (_disposed) return null;
    return result.fold<Failure?>(
      onSuccess: (accounts) {
        // Set directly rather than waiting for the cache echo, so the
        // screen still works when the cache is unavailable (e.g. web
        // without the sqlite wasm bundle).
        state = AsyncData(accounts);
        return null;
      },
      onFailure: (failure) {
        if (!state.hasValue) {
          state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
        }
        return failure;
      },
    );
  }
}

/// Lookup into the loaded list — detail surfaces resolve their account
/// here instead of refetching.
@riverpod
Account? accountById(Ref ref, String accountId) {
  final accounts = ref.watch(accountsControllerProvider).value;
  if (accounts == null) return null;
  for (final account in accounts) {
    if (account.id == accountId) return account;
  }
  return null;
}

/// Which account the expanded-layout detail pane shows. Route navigation
/// (compact/medium) doesn't touch this.
@riverpod
class PaneAccountId extends _$PaneAccountId {
  @override
  String? build() => null;

  // A named method reads better than a bare setter at the call sites
  // (`.select(id)` vs `.paneAccountId = id`).
  // ignore: use_setters_to_change_properties
  void select(String accountId) => state = accountId;
}

/// Balance history for one (account, range) pair. Family keying means a
/// previously visited range repaints instantly while its provider is
/// alive; the repository adds the offline cache fallback beneath that.
@riverpod
class AccountHistory extends _$AccountHistory {
  var _disposed = false;

  @override
  AsyncValue<List<BalancePoint>> build(String accountId, HistoryRange range) {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(_load));
    return const AsyncLoading();
  }

  Future<void> retry() => _load();

  Future<void> _load() async {
    final result = await GetBalanceHistory(ref.read(accountsRepositoryProvider))
        .call(GetBalanceHistoryParams(accountId: accountId, range: range));
    if (_disposed) return;
    state = result.fold(
      onSuccess: AsyncData.new,
      onFailure: (failure) =>
          AsyncError(failure, failure.stackTrace ?? StackTrace.current),
    );
  }
}

/// Statement list for one account (metadata only; lines are fetched at
/// export time).
@riverpod
class AccountStatements extends _$AccountStatements {
  var _disposed = false;

  @override
  AsyncValue<List<Statement>> build(String accountId) {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(_load));
    return const AsyncLoading();
  }

  Future<void> retry() => _load();

  Future<void> _load() async {
    final result = await GetStatements(ref.read(accountsRepositoryProvider))
        .call(accountId);
    if (_disposed) return;
    state = result.fold(
      onSuccess: AsyncData.new,
      onFailure: (failure) =>
          AsyncError(failure, failure.stackTrace ?? StackTrace.current),
    );
  }
}
