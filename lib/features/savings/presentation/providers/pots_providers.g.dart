// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pots_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition point for the savings slice. Tests override this with a
/// mocked [PotsRepository] — the same seam as every feature.

@ProviderFor(potsRepository)
final potsRepositoryProvider = PotsRepositoryProvider._();

/// Composition point for the savings slice. Tests override this with a
/// mocked [PotsRepository] — the same seam as every feature.

final class PotsRepositoryProvider
    extends $FunctionalProvider<PotsRepository, PotsRepository, PotsRepository>
    with $Provider<PotsRepository> {
  /// Composition point for the savings slice. Tests override this with a
  /// mocked [PotsRepository] — the same seam as every feature.
  PotsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'potsRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$potsRepositoryHash();

  @$internal
  @override
  $ProviderElement<PotsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PotsRepository create(Ref ref) {
    return potsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PotsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PotsRepository>(value),
    );
  }
}

String _$potsRepositoryHash() => r'00000000000000000000000000000000000000a1';

/// The user's savings pots. Auto-dispose, and invalidated by the transfer
/// flow when a deposit or withdrawal settles — the same "money moved,
/// balances are stale" reasoning that invalidates the account list.

@ProviderFor(PotsController)
final potsControllerProvider = PotsControllerProvider._();

/// The user's savings pots. Auto-dispose, and invalidated by the transfer
/// flow when a deposit or withdrawal settles — the same "money moved,
/// balances are stale" reasoning that invalidates the account list.
final class PotsControllerProvider
    extends $NotifierProvider<PotsController, AsyncValue<List<Pot>>> {
  /// The user's savings pots. Auto-dispose, and invalidated by the transfer
  /// flow when a deposit or withdrawal settles — the same "money moved,
  /// balances are stale" reasoning that invalidates the account list.
  PotsControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'potsControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$potsControllerHash();

  @$internal
  @override
  PotsController create() => PotsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Pot>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Pot>>>(value),
    );
  }
}

String _$potsControllerHash() => r'00000000000000000000000000000000000000a2';

/// The user's savings pots. Auto-dispose, and invalidated by the transfer
/// flow when a deposit or withdrawal settles — the same "money moved,
/// balances are stale" reasoning that invalidates the account list.

abstract class _$PotsController extends $Notifier<AsyncValue<List<Pot>>> {
  AsyncValue<List<Pot>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Pot>>, AsyncValue<List<Pot>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Pot>>, AsyncValue<List<Pot>>>,
        AsyncValue<List<Pot>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
