// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboardRepository)
final dashboardRepositoryProvider = DashboardRepositoryProvider._();

final class DashboardRepositoryProvider extends $FunctionalProvider<
    DashboardRepository,
    DashboardRepository,
    DashboardRepository> with $Provider<DashboardRepository> {
  DashboardRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dashboardRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dashboardRepositoryHash();

  @$internal
  @override
  $ProviderElement<DashboardRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DashboardRepository create(Ref ref) {
    return dashboardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardRepository>(value),
    );
  }
}

String _$dashboardRepositoryHash() =>
    r'5cc58e14a212205b56ac6f1733eaef9848a92cf6';

/// Dashboard read model. autoDispose on purpose: when the authenticated
/// shell unmounts (logout), the cache dies with it.

@ProviderFor(DashboardController)
final dashboardControllerProvider = DashboardControllerProvider._();

/// Dashboard read model. autoDispose on purpose: when the authenticated
/// shell unmounts (logout), the cache dies with it.
final class DashboardControllerProvider extends $NotifierProvider<
    DashboardController, AsyncValue<DashboardSummary>> {
  /// Dashboard read model. autoDispose on purpose: when the authenticated
  /// shell unmounts (logout), the cache dies with it.
  DashboardControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dashboardControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dashboardControllerHash();

  @$internal
  @override
  DashboardController create() => DashboardController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<DashboardSummary> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<DashboardSummary>>(value),
    );
  }
}

String _$dashboardControllerHash() =>
    r'd91778afb12ae8981a7d7284472a6ee6e6e019a4';

/// Dashboard read model. autoDispose on purpose: when the authenticated
/// shell unmounts (logout), the cache dies with it.

abstract class _$DashboardController
    extends $Notifier<AsyncValue<DashboardSummary>> {
  AsyncValue<DashboardSummary> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<DashboardSummary>, AsyncValue<DashboardSummary>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<DashboardSummary>, AsyncValue<DashboardSummary>>,
        AsyncValue<DashboardSummary>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}

/// The account whose balance and history the balance card shows.
/// `null` means "the first account in the summary".

@ProviderFor(SelectedAccountId)
final selectedAccountIdProvider = SelectedAccountIdProvider._();

/// The account whose balance and history the balance card shows.
/// `null` means "the first account in the summary".
final class SelectedAccountIdProvider
    extends $NotifierProvider<SelectedAccountId, String?> {
  /// The account whose balance and history the balance card shows.
  /// `null` means "the first account in the summary".
  SelectedAccountIdProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedAccountIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedAccountIdHash();

  @$internal
  @override
  SelectedAccountId create() => SelectedAccountId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedAccountIdHash() => r'2e729cb238b894182861354127b5b2bf0e28fbae';

/// The account whose balance and history the balance card shows.
/// `null` means "the first account in the summary".

abstract class _$SelectedAccountId extends $Notifier<String?> {
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
