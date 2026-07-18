// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition point for the accounts slice. Tests override this with a
/// mocked [AccountsRepository] — the same seam as every other feature.

@ProviderFor(accountsRepository)
final accountsRepositoryProvider = AccountsRepositoryProvider._();

/// Composition point for the accounts slice. Tests override this with a
/// mocked [AccountsRepository] — the same seam as every other feature.

final class AccountsRepositoryProvider extends $FunctionalProvider<
    AccountsRepository,
    AccountsRepository,
    AccountsRepository> with $Provider<AccountsRepository> {
  /// Composition point for the accounts slice. Tests override this with a
  /// mocked [AccountsRepository] — the same seam as every other feature.
  AccountsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'accountsRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$accountsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AccountsRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AccountsRepository create(Ref ref) {
    return accountsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountsRepository>(value),
    );
  }
}

String _$accountsRepositoryHash() =>
    r'd8788588ea4b6a4a1d66ab14981571dbc2f7491e';

@ProviderFor(statementExporter)
final statementExporterProvider = StatementExporterProvider._();

final class StatementExporterProvider extends $FunctionalProvider<
    StatementExporter,
    StatementExporter,
    StatementExporter> with $Provider<StatementExporter> {
  StatementExporterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'statementExporterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$statementExporterHash();

  @$internal
  @override
  $ProviderElement<StatementExporter> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StatementExporter create(Ref ref) {
    return statementExporter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatementExporter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatementExporter>(value),
    );
  }
}

String _$statementExporterHash() => r'd3a0b83b0571861fb696573288e394da022504fc';

/// Accounts read model, implementing the cache-first policy at the
/// controller level:
///
/// 1. subscribe to the Drift stream — a warm cache paints instantly;
/// 2. kick a network refresh — its result lands both directly (so the UI
///    works with a broken cache) and via the cache echo.
///
/// autoDispose: leaving the signed-in shell tears it down; the on-disk
/// cache itself survives for the next session.

@ProviderFor(AccountsController)
final accountsControllerProvider = AccountsControllerProvider._();

/// Accounts read model, implementing the cache-first policy at the
/// controller level:
///
/// 1. subscribe to the Drift stream — a warm cache paints instantly;
/// 2. kick a network refresh — its result lands both directly (so the UI
///    works with a broken cache) and via the cache echo.
///
/// autoDispose: leaving the signed-in shell tears it down; the on-disk
/// cache itself survives for the next session.
final class AccountsControllerProvider
    extends $NotifierProvider<AccountsController, AsyncValue<List<Account>>> {
  /// Accounts read model, implementing the cache-first policy at the
  /// controller level:
  ///
  /// 1. subscribe to the Drift stream — a warm cache paints instantly;
  /// 2. kick a network refresh — its result lands both directly (so the UI
  ///    works with a broken cache) and via the cache echo.
  ///
  /// autoDispose: leaving the signed-in shell tears it down; the on-disk
  /// cache itself survives for the next session.
  AccountsControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'accountsControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$accountsControllerHash();

  @$internal
  @override
  AccountsController create() => AccountsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Account>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Account>>>(value),
    );
  }
}

String _$accountsControllerHash() =>
    r'67d6066168a7ef3e7751be75cfb671ba83927a92';

/// Accounts read model, implementing the cache-first policy at the
/// controller level:
///
/// 1. subscribe to the Drift stream — a warm cache paints instantly;
/// 2. kick a network refresh — its result lands both directly (so the UI
///    works with a broken cache) and via the cache echo.
///
/// autoDispose: leaving the signed-in shell tears it down; the on-disk
/// cache itself survives for the next session.

abstract class _$AccountsController
    extends $Notifier<AsyncValue<List<Account>>> {
  AsyncValue<List<Account>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Account>>, AsyncValue<List<Account>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Account>>, AsyncValue<List<Account>>>,
        AsyncValue<List<Account>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}

/// Lookup into the loaded list — detail surfaces resolve their account
/// here instead of refetching.

@ProviderFor(accountById)
final accountByIdProvider = AccountByIdFamily._();

/// Lookup into the loaded list — detail surfaces resolve their account
/// here instead of refetching.

final class AccountByIdProvider
    extends $FunctionalProvider<Account?, Account?, Account?>
    with $Provider<Account?> {
  /// Lookup into the loaded list — detail surfaces resolve their account
  /// here instead of refetching.
  AccountByIdProvider._(
      {required AccountByIdFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'accountByIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$accountByIdHash();

  @override
  String toString() {
    return r'accountByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Account?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Account? create(Ref ref) {
    final argument = this.argument as String;
    return accountById(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Account? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Account?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AccountByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$accountByIdHash() => r'c80f67d319461a7c95f1efa54ff79fef2b79ef85';

/// Lookup into the loaded list — detail surfaces resolve their account
/// here instead of refetching.

final class AccountByIdFamily extends $Family
    with $FunctionalFamilyOverride<Account?, String> {
  AccountByIdFamily._()
      : super(
          retry: null,
          name: r'accountByIdProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Lookup into the loaded list — detail surfaces resolve their account
  /// here instead of refetching.

  AccountByIdProvider call(
    String accountId,
  ) =>
      AccountByIdProvider._(argument: accountId, from: this);

  @override
  String toString() => r'accountByIdProvider';
}

/// Which account the expanded-layout detail pane shows. Route navigation
/// (compact/medium) doesn't touch this.

@ProviderFor(PaneAccountId)
final paneAccountIdProvider = PaneAccountIdProvider._();

/// Which account the expanded-layout detail pane shows. Route navigation
/// (compact/medium) doesn't touch this.
final class PaneAccountIdProvider
    extends $NotifierProvider<PaneAccountId, String?> {
  /// Which account the expanded-layout detail pane shows. Route navigation
  /// (compact/medium) doesn't touch this.
  PaneAccountIdProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'paneAccountIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$paneAccountIdHash();

  @$internal
  @override
  PaneAccountId create() => PaneAccountId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$paneAccountIdHash() => r'fb437b203338f1ed03441aab2994233b4ca9a808';

/// Which account the expanded-layout detail pane shows. Route navigation
/// (compact/medium) doesn't touch this.

abstract class _$PaneAccountId extends $Notifier<String?> {
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

/// Balance history for one (account, range) pair. Family keying means a
/// previously visited range repaints instantly while its provider is
/// alive; the repository adds the offline cache fallback beneath that.

@ProviderFor(AccountHistory)
final accountHistoryProvider = AccountHistoryFamily._();

/// Balance history for one (account, range) pair. Family keying means a
/// previously visited range repaints instantly while its provider is
/// alive; the repository adds the offline cache fallback beneath that.
final class AccountHistoryProvider
    extends $NotifierProvider<AccountHistory, AsyncValue<List<BalancePoint>>> {
  /// Balance history for one (account, range) pair. Family keying means a
  /// previously visited range repaints instantly while its provider is
  /// alive; the repository adds the offline cache fallback beneath that.
  AccountHistoryProvider._(
      {required AccountHistoryFamily super.from,
      required (
        String,
        HistoryRange,
      )
          super.argument})
      : super(
          retry: null,
          name: r'accountHistoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$accountHistoryHash();

  @override
  String toString() {
    return r'accountHistoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  AccountHistory create() => AccountHistory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<BalancePoint>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<BalancePoint>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AccountHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$accountHistoryHash() => r'5e4a2406b1a2d557d6a29b4e449920d82b4b45b9';

/// Balance history for one (account, range) pair. Family keying means a
/// previously visited range repaints instantly while its provider is
/// alive; the repository adds the offline cache fallback beneath that.

final class AccountHistoryFamily extends $Family
    with
        $ClassFamilyOverride<
            AccountHistory,
            AsyncValue<List<BalancePoint>>,
            AsyncValue<List<BalancePoint>>,
            AsyncValue<List<BalancePoint>>,
            (
              String,
              HistoryRange,
            )> {
  AccountHistoryFamily._()
      : super(
          retry: null,
          name: r'accountHistoryProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Balance history for one (account, range) pair. Family keying means a
  /// previously visited range repaints instantly while its provider is
  /// alive; the repository adds the offline cache fallback beneath that.

  AccountHistoryProvider call(
    String accountId,
    HistoryRange range,
  ) =>
      AccountHistoryProvider._(argument: (
        accountId,
        range,
      ), from: this);

  @override
  String toString() => r'accountHistoryProvider';
}

/// Balance history for one (account, range) pair. Family keying means a
/// previously visited range repaints instantly while its provider is
/// alive; the repository adds the offline cache fallback beneath that.

abstract class _$AccountHistory
    extends $Notifier<AsyncValue<List<BalancePoint>>> {
  late final _$args = ref.$arg as (
    String,
    HistoryRange,
  );
  String get accountId => _$args.$1;
  HistoryRange get range => _$args.$2;

  AsyncValue<List<BalancePoint>> build(
    String accountId,
    HistoryRange range,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<BalancePoint>>, AsyncValue<List<BalancePoint>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<BalancePoint>>,
            AsyncValue<List<BalancePoint>>>,
        AsyncValue<List<BalancePoint>>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args.$1,
              _$args.$2,
            ));
  }
}

/// Statement list for one account (metadata only; lines are fetched at
/// export time).

@ProviderFor(AccountStatements)
final accountStatementsProvider = AccountStatementsFamily._();

/// Statement list for one account (metadata only; lines are fetched at
/// export time).
final class AccountStatementsProvider
    extends $NotifierProvider<AccountStatements, AsyncValue<List<Statement>>> {
  /// Statement list for one account (metadata only; lines are fetched at
  /// export time).
  AccountStatementsProvider._(
      {required AccountStatementsFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'accountStatementsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$accountStatementsHash();

  @override
  String toString() {
    return r'accountStatementsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AccountStatements create() => AccountStatements();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Statement>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Statement>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AccountStatementsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$accountStatementsHash() => r'2ba9f75ed4487ec12c38ef7c10d6401463279c00';

/// Statement list for one account (metadata only; lines are fetched at
/// export time).

final class AccountStatementsFamily extends $Family
    with
        $ClassFamilyOverride<AccountStatements, AsyncValue<List<Statement>>,
            AsyncValue<List<Statement>>, AsyncValue<List<Statement>>, String> {
  AccountStatementsFamily._()
      : super(
          retry: null,
          name: r'accountStatementsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Statement list for one account (metadata only; lines are fetched at
  /// export time).

  AccountStatementsProvider call(
    String accountId,
  ) =>
      AccountStatementsProvider._(argument: accountId, from: this);

  @override
  String toString() => r'accountStatementsProvider';
}

/// Statement list for one account (metadata only; lines are fetched at
/// export time).

abstract class _$AccountStatements
    extends $Notifier<AsyncValue<List<Statement>>> {
  late final _$args = ref.$arg as String;
  String get accountId => _$args;

  AsyncValue<List<Statement>> build(
    String accountId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<Statement>>, AsyncValue<List<Statement>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Statement>>, AsyncValue<List<Statement>>>,
        AsyncValue<List<Statement>>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
