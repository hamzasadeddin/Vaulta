import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction_filter.dart';
import 'package:vaulta/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:vaulta/features/transactions/presentation/providers/transactions_providers.dart';

class _MockTransactionsRepository extends Mock
    implements TransactionsRepository {}

Transaction _txn(String id, {int minutesAgo = 0}) => Transaction(
      id: id,
      accountId: 'acc_chk',
      title: 'Txn $id',
      category: TransactionCategory.other,
      amount: Money.parse('-1.00', Currency.usd),
      occurredAt: DateTime(2026, 7, 19, 12).subtract(
        Duration(minutes: minutesAgo),
      ),
      reference: 'VLT-2026-$id',
    );

void main() {
  late _MockTransactionsRepository repository;
  late ProviderContainer container;

  final pageOne = TransactionsPage(
    items: [_txn('a'), _txn('b', minutesAgo: 5)],
    nextCursor: 'c1',
  );
  final pageTwo = TransactionsPage(
    items: [_txn('c', minutesAgo: 10)],
    nextCursor: null,
  );

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  setUpAll(() {
    registerFallbackValue(const TransactionFilter());
  });

  setUp(() {
    repository = _MockTransactionsRepository();
    container = ProviderContainer(
      overrides: [
        transactionsRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() => container.dispose());

  void stubPage({
    required Result<TransactionsPage, Failure> result,
    String? cursor,
  }) {
    when(
      () => repository.getTransactions(
        filter: any(named: 'filter'),
        cursor: cursor,
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => result);
  }

  test('loads the first page and exposes the cursor', () async {
    stubPage(result: Result.success(pageOne));

    final sub =
        container.listen(transactionsFeedControllerProvider, (_, __) {});
    expect(sub.read(), const AsyncValue<TransactionsFeed>.loading());

    await settle();
    await settle();

    final feed = sub.read().value!;
    expect(feed.items.map((t) => t.id), ['a', 'b']);
    expect(feed.hasMore, isTrue);
  });

  test('loadMore appends the next keyset page and clears the cursor', () async {
    stubPage(result: Result.success(pageOne));
    stubPage(cursor: 'c1', result: Result.success(pageTwo));

    final sub =
        container.listen(transactionsFeedControllerProvider, (_, __) {});
    await settle();
    await settle();

    await container
        .read(transactionsFeedControllerProvider.notifier)
        .loadMore();

    final feed = sub.read().value!;
    expect(feed.items.map((t) => t.id), ['a', 'b', 'c']);
    expect(feed.hasMore, isFalse);
    expect(feed.isLoadingMore, isFalse);
  });

  test('loadMore is a no-op when the feed is exhausted', () async {
    stubPage(
      result: Result.success(
        TransactionsPage(items: [_txn('a')], nextCursor: null),
      ),
    );

    container.listen(transactionsFeedControllerProvider, (_, __) {});
    await settle();
    await settle();

    await container
        .read(transactionsFeedControllerProvider.notifier)
        .loadMore();

    verify(
      () => repository.getTransactions(
        filter: any(named: 'filter'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).called(1);
  });

  test('concurrent loadMore calls collapse into one request', () async {
    stubPage(result: Result.success(pageOne));
    final pending = Completer<Result<TransactionsPage, Failure>>();
    when(
      () => repository.getTransactions(
        filter: any(named: 'filter'),
        cursor: 'c1',
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) => pending.future);

    final sub =
        container.listen(transactionsFeedControllerProvider, (_, __) {});
    await settle();
    await settle();

    final notifier =
        container.read(transactionsFeedControllerProvider.notifier);
    final first = notifier.loadMore();
    final second = notifier.loadMore();
    expect(sub.read().value!.isLoadingMore, isTrue);

    pending.complete(Result.success(pageTwo));
    await first;
    await second;

    verify(
      () => repository.getTransactions(
        filter: any(named: 'filter'),
        cursor: 'c1',
        limit: any(named: 'limit'),
      ),
    ).called(1);
    expect(sub.read().value!.items, hasLength(3));
  });

  test('a failed loadMore keeps the window and flags the footer', () async {
    stubPage(result: Result.success(pageOne));
    stubPage(cursor: 'c1', result: const Result.failure(NetworkFailure()));

    final sub =
        container.listen(transactionsFeedControllerProvider, (_, __) {});
    await settle();
    await settle();

    await container
        .read(transactionsFeedControllerProvider.notifier)
        .loadMore();

    final feed = sub.read().value!;
    expect(feed.items, hasLength(2), reason: 'loaded window survives');
    expect(feed.loadMoreFailure, isA<NetworkFailure>());
    expect(feed.isLoadingMore, isFalse);
    expect(feed.hasMore, isTrue, reason: 'cursor retained for retry');
  });

  test('refresh failure with data on screen returns the failure', () async {
    stubPage(result: Result.success(pageOne));

    final sub =
        container.listen(transactionsFeedControllerProvider, (_, __) {});
    await settle();
    await settle();

    stubPage(result: const Result.failure(TimeoutFailure()));
    final failure = await container
        .read(transactionsFeedControllerProvider.notifier)
        .refresh();

    expect(failure, isA<TimeoutFailure>());
    expect(sub.read().value!.items, hasLength(2), reason: 'data retained');
  });

  test('first-page failure with nothing on screen lands AsyncError', () async {
    stubPage(result: const Result.failure(NetworkFailure()));

    final sub =
        container.listen(transactionsFeedControllerProvider, (_, __) {});
    await settle();
    await settle();

    expect(sub.read(), isA<AsyncError<TransactionsFeed>>());
  });

  test('a filter change resets the feed and requests with the new filter',
      () async {
    stubPage(result: Result.success(pageOne));

    final sub =
        container.listen(transactionsFeedControllerProvider, (_, __) {});
    await settle();
    await settle();
    expect(sub.read().value!.items, hasLength(2));

    // Gate the reload so the reset-to-skeleton frame is observable — with a
    // synchronous mock the rebuild and the reload would drain in one settle.
    final pending = Completer<Result<TransactionsPage, Failure>>();
    when(
      () => repository.getTransactions(
        filter: any(named: 'filter'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) => pending.future);

    container
        .read(transactionsFilterControllerProvider.notifier)
        .setCategory(TransactionCategory.dining);
    await settle();
    expect(sub.read().isLoading, isTrue, reason: 'new data set → skeleton');

    pending.complete(Result.success(pageOne));
    await settle();
    final captured = verify(
      () => repository.getTransactions(
        filter: captureAny(named: 'filter'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).captured;
    expect(
      (captured.last as TransactionFilter).category,
      TransactionCategory.dining,
    );
  });

  test('focusAccount drops every other dimension', () {
    // Hold a subscription or the autoDispose notifier resets between reads.
    container.listen(transactionsFilterControllerProvider, (_, __) {});
    container.read(transactionsFilterControllerProvider.notifier)
      ..setCategory(TransactionCategory.dining)
      ..setQuery('fig')
      ..focusAccount('acc_sav');

    expect(
      container.read(transactionsFilterControllerProvider),
      const TransactionFilter(accountId: 'acc_sav'),
    );
  });
}
