import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/network/network_providers.dart';
import 'package:vaulta/features/transactions/data/datasources/transactions_remote_data_source.dart';
import 'package:vaulta/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction_filter.dart';
import 'package:vaulta/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:vaulta/features/transactions/domain/usecases/transactions_usecases.dart';

part 'transactions_providers.g.dart';

/// Composition point for the transactions slice. Tests override this with
/// a mocked [TransactionsRepository] — the same seam as every feature.
@riverpod
TransactionsRepository transactionsRepository(Ref ref) {
  return TransactionsRepositoryImpl(
    remote: TransactionsRemoteDataSource(ref.watch(dioProvider)),
  );
}

/// The active feed filter. Single-select per dimension; each setter builds
/// a fresh value explicitly so passing `null` genuinely clears a dimension
/// (a conventional `copyWith` cannot distinguish "clear" from "keep").
@riverpod
class TransactionsFilterController extends _$TransactionsFilterController {
  @override
  TransactionFilter build() => const TransactionFilter();

  void setAccount(String? accountId) {
    state = TransactionFilter(
      accountId: accountId,
      category: state.category,
      status: state.status,
      query: state.query,
    );
  }

  void setCategory(TransactionCategory? category) {
    state = TransactionFilter(
      accountId: state.accountId,
      category: category,
      status: state.status,
      query: state.query,
    );
  }

  void setStatus(TransactionStatus? status) {
    state = TransactionFilter(
      accountId: state.accountId,
      category: state.category,
      status: status,
      query: state.query,
    );
  }

  void setQuery(String query) {
    state = TransactionFilter(
      accountId: state.accountId,
      category: state.category,
      status: state.status,
      query: query,
    );
  }

  /// "View transactions" from an account detail: focus that account and
  /// drop every other dimension.
  void focusAccount(String accountId) {
    state = TransactionFilter(accountId: accountId);
  }

  void clear() => state = const TransactionFilter();
}

/// Presentation state for the infinite feed: the loaded window, the keyset
/// cursor to continue from, and the load-more flags the footer renders.
@immutable
class TransactionsFeed {
  const TransactionsFeed({
    required this.items,
    required this.nextCursor,
    this.isLoadingMore = false,
    this.loadMoreFailure,
  });

  final List<Transaction> items;
  final String? nextCursor;
  final bool isLoadingMore;

  /// Set when appending a page failed; the footer offers a retry while the
  /// already-loaded window stays on screen.
  final Failure? loadMoreFailure;

  bool get hasMore => nextCursor != null;

  TransactionsFeed copyWith({
    List<Transaction>? items,
    String? Function()? nextCursor,
    bool? isLoadingMore,
    Failure? Function()? loadMoreFailure,
  }) {
    return TransactionsFeed(
      items: items ?? this.items,
      nextCursor: nextCursor == null ? this.nextCursor : nextCursor(),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailure:
          loadMoreFailure == null ? this.loadMoreFailure : loadMoreFailure(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionsFeed &&
          other.nextCursor == nextCursor &&
          other.isLoadingMore == isLoadingMore &&
          other.loadMoreFailure == loadMoreFailure &&
          listEquals(other.items, items);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(items),
        nextCursor,
        isLoadingMore,
        loadMoreFailure,
      );
}

/// Paginated feed controller. Holds `AsyncValue` manually (the same
/// pattern, for the same reason, as the dashboard and accounts
/// controllers): data must survive a failed refresh, and load-more mutates
/// the value in place rather than flipping the whole screen to loading.
///
/// Watching the filter means a filter change re-runs `build`, resetting to
/// the skeleton — correct, because a different filter is a different data
/// set. [_requestId] fences every in-flight request so a stale response
/// from the previous filter can never land in the new state.
@riverpod
class TransactionsFeedController extends _$TransactionsFeedController {
  var _disposed = false;
  var _requestId = 0;

  @override
  AsyncValue<TransactionsFeed> build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    final filter = ref.watch(transactionsFilterControllerProvider);
    // Kick the load after build returns — writing state during build is
    // illegal, and this keeps first-frame cost flat.
    unawaited(Future<void>.microtask(() => _loadFirstPage(filter)));
    return const AsyncLoading();
  }

  /// Pull-to-refresh / error retry. Returns the failure (for a snackbar)
  /// instead of clobbering already-visible data with an error state.
  Future<Failure?> refresh() =>
      _loadFirstPage(ref.read(transactionsFilterControllerProvider));

  /// Appends the next keyset page. No-ops while a page is already in
  /// flight or when the feed is exhausted, so the scroll trigger can fire
  /// as often as it likes.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    final requestId = ++_requestId;
    state = AsyncData(
      current.copyWith(isLoadingMore: true, loadMoreFailure: () => null),
    );

    final result = await GetTransactions(_repository).call(
      GetTransactionsParams(
        filter: ref.read(transactionsFilterControllerProvider),
        cursor: current.nextCursor,
      ),
    );
    if (_stale(requestId)) return;

    state = AsyncData(
      result.fold(
        onSuccess: (page) => TransactionsFeed(
          items: [...current.items, ...page.items],
          nextCursor: page.nextCursor,
        ),
        onFailure: (failure) => current.copyWith(
          loadMoreFailure: () => failure,
        ),
      ),
    );
  }

  Future<Failure?> _loadFirstPage(TransactionFilter filter) async {
    final requestId = ++_requestId;
    final result = await GetTransactions(_repository).call(
      GetTransactionsParams(filter: filter),
    );
    if (_stale(requestId)) return null;

    return result.fold<Failure?>(
      onSuccess: (page) {
        state = AsyncData(
          TransactionsFeed(items: page.items, nextCursor: page.nextCursor),
        );
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

  TransactionsRepository get _repository =>
      ref.read(transactionsRepositoryProvider);

  bool _stale(int requestId) => _disposed || requestId != _requestId;
}

/// One transaction for the receipt surface. Seeds from the loaded feed for
/// an instant paint, then fetches to confirm — which also serves deep
/// links that never went through the list. A fetch failure never replaces
/// an already-painted snapshot.
@riverpod
class TransactionDetailController extends _$TransactionDetailController {
  var _disposed = false;

  @override
  AsyncValue<Transaction> build(String transactionId) {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    unawaited(Future<void>.microtask(_load));
    final snapshot = _fromFeed();
    return snapshot == null ? const AsyncLoading() : AsyncData(snapshot);
  }

  Future<void> retry() => _load();

  Future<void> _load() async {
    final result = await GetTransaction(
      ref.read(transactionsRepositoryProvider),
    ).call(transactionId);
    if (_disposed) return;
    result.fold(
      onSuccess: (txn) => state = AsyncData(txn),
      onFailure: (failure) {
        if (!state.hasValue) {
          state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
        }
      },
    );
  }

  /// Snapshot semantics on purpose: a `read` (not `watch`) so a feed
  /// refresh doesn't rebuild every open receipt; the network fetch above
  /// is the source of truth.
  Transaction? _fromFeed() {
    final items =
        ref.read(transactionsFeedControllerProvider).value?.items ?? const [];
    for (final txn in items) {
      if (txn.id == transactionId) return txn;
    }
    return null;
  }
}

/// Which transaction the expanded-layout detail pane shows. Route
/// navigation (compact/medium) doesn't touch this.
@riverpod
class PaneTransactionId extends _$PaneTransactionId {
  @override
  String? build() => null;

  // A named method reads better than a bare setter at the call sites
  // (`.select(id)` vs `.paneTransactionId = id`).
  // ignore: use_setters_to_change_properties
  void select(String transactionId) => state = transactionId;
}
