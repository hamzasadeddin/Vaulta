// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition point for the transactions slice. Tests override this with
/// a mocked [TransactionsRepository] — the same seam as every feature.

@ProviderFor(transactionsRepository)
final transactionsRepositoryProvider = TransactionsRepositoryProvider._();

/// Composition point for the transactions slice. Tests override this with
/// a mocked [TransactionsRepository] — the same seam as every feature.

final class TransactionsRepositoryProvider extends $FunctionalProvider<
    TransactionsRepository,
    TransactionsRepository,
    TransactionsRepository> with $Provider<TransactionsRepository> {
  /// Composition point for the transactions slice. Tests override this with
  /// a mocked [TransactionsRepository] — the same seam as every feature.
  TransactionsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'transactionsRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$transactionsRepositoryHash();

  @$internal
  @override
  $ProviderElement<TransactionsRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TransactionsRepository create(Ref ref) {
    return transactionsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionsRepository>(value),
    );
  }
}

String _$transactionsRepositoryHash() =>
    r'fd08312ccc780dde51721d4cbcae724d911fed24';

/// The active feed filter. Single-select per dimension; each setter builds
/// a fresh value explicitly so passing `null` genuinely clears a dimension
/// (a conventional `copyWith` cannot distinguish "clear" from "keep").

@ProviderFor(TransactionsFilterController)
final transactionsFilterControllerProvider =
    TransactionsFilterControllerProvider._();

/// The active feed filter. Single-select per dimension; each setter builds
/// a fresh value explicitly so passing `null` genuinely clears a dimension
/// (a conventional `copyWith` cannot distinguish "clear" from "keep").
final class TransactionsFilterControllerProvider
    extends $NotifierProvider<TransactionsFilterController, TransactionFilter> {
  /// The active feed filter. Single-select per dimension; each setter builds
  /// a fresh value explicitly so passing `null` genuinely clears a dimension
  /// (a conventional `copyWith` cannot distinguish "clear" from "keep").
  TransactionsFilterControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'transactionsFilterControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$transactionsFilterControllerHash();

  @$internal
  @override
  TransactionsFilterController create() => TransactionsFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionFilter>(value),
    );
  }
}

String _$transactionsFilterControllerHash() =>
    r'baf8fb0b1df0337145b6a8e5553dbab31bd5d768';

/// The active feed filter. Single-select per dimension; each setter builds
/// a fresh value explicitly so passing `null` genuinely clears a dimension
/// (a conventional `copyWith` cannot distinguish "clear" from "keep").

abstract class _$TransactionsFilterController
    extends $Notifier<TransactionFilter> {
  TransactionFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TransactionFilter, TransactionFilter>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<TransactionFilter, TransactionFilter>,
        TransactionFilter,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
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

@ProviderFor(TransactionsFeedController)
final transactionsFeedControllerProvider =
    TransactionsFeedControllerProvider._();

/// Paginated feed controller. Holds `AsyncValue` manually (the same
/// pattern, for the same reason, as the dashboard and accounts
/// controllers): data must survive a failed refresh, and load-more mutates
/// the value in place rather than flipping the whole screen to loading.
///
/// Watching the filter means a filter change re-runs `build`, resetting to
/// the skeleton — correct, because a different filter is a different data
/// set. [_requestId] fences every in-flight request so a stale response
/// from the previous filter can never land in the new state.
final class TransactionsFeedControllerProvider extends $NotifierProvider<
    TransactionsFeedController, AsyncValue<TransactionsFeed>> {
  /// Paginated feed controller. Holds `AsyncValue` manually (the same
  /// pattern, for the same reason, as the dashboard and accounts
  /// controllers): data must survive a failed refresh, and load-more mutates
  /// the value in place rather than flipping the whole screen to loading.
  ///
  /// Watching the filter means a filter change re-runs `build`, resetting to
  /// the skeleton — correct, because a different filter is a different data
  /// set. [_requestId] fences every in-flight request so a stale response
  /// from the previous filter can never land in the new state.
  TransactionsFeedControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'transactionsFeedControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$transactionsFeedControllerHash();

  @$internal
  @override
  TransactionsFeedController create() => TransactionsFeedController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<TransactionsFeed> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<TransactionsFeed>>(value),
    );
  }
}

String _$transactionsFeedControllerHash() =>
    r'b49c03070414fadddd3825bce465823966191967';

/// Paginated feed controller. Holds `AsyncValue` manually (the same
/// pattern, for the same reason, as the dashboard and accounts
/// controllers): data must survive a failed refresh, and load-more mutates
/// the value in place rather than flipping the whole screen to loading.
///
/// Watching the filter means a filter change re-runs `build`, resetting to
/// the skeleton — correct, because a different filter is a different data
/// set. [_requestId] fences every in-flight request so a stale response
/// from the previous filter can never land in the new state.

abstract class _$TransactionsFeedController
    extends $Notifier<AsyncValue<TransactionsFeed>> {
  AsyncValue<TransactionsFeed> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<TransactionsFeed>, AsyncValue<TransactionsFeed>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<TransactionsFeed>, AsyncValue<TransactionsFeed>>,
        AsyncValue<TransactionsFeed>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}

/// One transaction for the receipt surface. Seeds from the loaded feed for
/// an instant paint, then fetches to confirm — which also serves deep
/// links that never went through the list. A fetch failure never replaces
/// an already-painted snapshot.

@ProviderFor(TransactionDetailController)
final transactionDetailControllerProvider =
    TransactionDetailControllerFamily._();

/// One transaction for the receipt surface. Seeds from the loaded feed for
/// an instant paint, then fetches to confirm — which also serves deep
/// links that never went through the list. A fetch failure never replaces
/// an already-painted snapshot.
final class TransactionDetailControllerProvider extends $NotifierProvider<
    TransactionDetailController, AsyncValue<Transaction>> {
  /// One transaction for the receipt surface. Seeds from the loaded feed for
  /// an instant paint, then fetches to confirm — which also serves deep
  /// links that never went through the list. A fetch failure never replaces
  /// an already-painted snapshot.
  TransactionDetailControllerProvider._(
      {required TransactionDetailControllerFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'transactionDetailControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$transactionDetailControllerHash();

  @override
  String toString() {
    return r'transactionDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TransactionDetailController create() => TransactionDetailController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Transaction> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Transaction>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionDetailControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionDetailControllerHash() =>
    r'66e573aabcd9c7dd1753466319375995c25c2980';

/// One transaction for the receipt surface. Seeds from the loaded feed for
/// an instant paint, then fetches to confirm — which also serves deep
/// links that never went through the list. A fetch failure never replaces
/// an already-painted snapshot.

final class TransactionDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
            TransactionDetailController,
            AsyncValue<Transaction>,
            AsyncValue<Transaction>,
            AsyncValue<Transaction>,
            String> {
  TransactionDetailControllerFamily._()
      : super(
          retry: null,
          name: r'transactionDetailControllerProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// One transaction for the receipt surface. Seeds from the loaded feed for
  /// an instant paint, then fetches to confirm — which also serves deep
  /// links that never went through the list. A fetch failure never replaces
  /// an already-painted snapshot.

  TransactionDetailControllerProvider call(
    String transactionId,
  ) =>
      TransactionDetailControllerProvider._(
          argument: transactionId, from: this);

  @override
  String toString() => r'transactionDetailControllerProvider';
}

/// One transaction for the receipt surface. Seeds from the loaded feed for
/// an instant paint, then fetches to confirm — which also serves deep
/// links that never went through the list. A fetch failure never replaces
/// an already-painted snapshot.

abstract class _$TransactionDetailController
    extends $Notifier<AsyncValue<Transaction>> {
  late final _$args = ref.$arg as String;
  String get transactionId => _$args;

  AsyncValue<Transaction> build(
    String transactionId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<Transaction>, AsyncValue<Transaction>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Transaction>, AsyncValue<Transaction>>,
        AsyncValue<Transaction>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

/// Which transaction the expanded-layout detail pane shows. Route
/// navigation (compact/medium) doesn't touch this.

@ProviderFor(PaneTransactionId)
final paneTransactionIdProvider = PaneTransactionIdProvider._();

/// Which transaction the expanded-layout detail pane shows. Route
/// navigation (compact/medium) doesn't touch this.
final class PaneTransactionIdProvider
    extends $NotifierProvider<PaneTransactionId, String?> {
  /// Which transaction the expanded-layout detail pane shows. Route
  /// navigation (compact/medium) doesn't touch this.
  PaneTransactionIdProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'paneTransactionIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$paneTransactionIdHash();

  @$internal
  @override
  PaneTransactionId create() => PaneTransactionId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$paneTransactionIdHash() => r'684c65609ce4020b0528f3c2529707de2f9edbdc';

/// Which transaction the expanded-layout detail pane shows. Route
/// navigation (compact/medium) doesn't touch this.

abstract class _$PaneTransactionId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String?, String?>, String?, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
