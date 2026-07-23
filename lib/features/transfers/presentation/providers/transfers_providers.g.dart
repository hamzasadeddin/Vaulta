// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfers_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition point for the transfers slice. Tests override this with a
/// mocked [TransfersRepository] — the same seam as every feature.

@ProviderFor(transfersRepository)
final transfersRepositoryProvider = TransfersRepositoryProvider._();

/// Composition point for the transfers slice. Tests override this with a
/// mocked [TransfersRepository] — the same seam as every feature.

final class TransfersRepositoryProvider extends $FunctionalProvider<
    TransfersRepository,
    TransfersRepository,
    TransfersRepository> with $Provider<TransfersRepository> {
  /// Composition point for the transfers slice. Tests override this with a
  /// mocked [TransfersRepository] — the same seam as every feature.
  TransfersRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'transfersRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$transfersRepositoryHash();

  @$internal
  @override
  $ProviderElement<TransfersRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TransfersRepository create(Ref ref) {
    return transfersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransfersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransfersRepository>(value),
    );
  }
}

String _$transfersRepositoryHash() =>
    r'3d957d861af35704f134b12bd19cfa1f15c1b7f4';

/// Saved payees for the recipient picker.

@ProviderFor(BeneficiariesController)
final beneficiariesControllerProvider = BeneficiariesControllerProvider._();

/// Saved payees for the recipient picker.
final class BeneficiariesControllerProvider extends $NotifierProvider<
    BeneficiariesController, AsyncValue<List<Beneficiary>>> {
  /// Saved payees for the recipient picker.
  BeneficiariesControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'beneficiariesControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$beneficiariesControllerHash();

  @$internal
  @override
  BeneficiariesController create() => BeneficiariesController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Beneficiary>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<Beneficiary>>>(value),
    );
  }
}

String _$beneficiariesControllerHash() =>
    r'1e7430d4e05178893163974d2f4d092b5e6e744b';

/// Saved payees for the recipient picker.

abstract class _$BeneficiariesController
    extends $Notifier<AsyncValue<List<Beneficiary>>> {
  AsyncValue<List<Beneficiary>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<Beneficiary>>, AsyncValue<List<Beneficiary>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Beneficiary>>,
            AsyncValue<List<Beneficiary>>>,
        AsyncValue<List<Beneficiary>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}

/// Drives the recipient → amount → review → receipt flow.
///
/// The confirm is **pessimistic**, unlike Phase 7's optimistic freeze: a
/// transfer is only shown as done once the server says it is. Nothing
/// about a money movement may be guessed at and rolled back.
///
/// Every edit upstream of the review step clears the quote, so a stale
/// price can never be the thing the user confirms.

@ProviderFor(TransferFlow)
final transferFlowProvider = TransferFlowProvider._();

/// Drives the recipient → amount → review → receipt flow.
///
/// The confirm is **pessimistic**, unlike Phase 7's optimistic freeze: a
/// transfer is only shown as done once the server says it is. Nothing
/// about a money movement may be guessed at and rolled back.
///
/// Every edit upstream of the review step clears the quote, so a stale
/// price can never be the thing the user confirms.
final class TransferFlowProvider
    extends $NotifierProvider<TransferFlow, TransferFlowState> {
  /// Drives the recipient → amount → review → receipt flow.
  ///
  /// The confirm is **pessimistic**, unlike Phase 7's optimistic freeze: a
  /// transfer is only shown as done once the server says it is. Nothing
  /// about a money movement may be guessed at and rolled back.
  ///
  /// Every edit upstream of the review step clears the quote, so a stale
  /// price can never be the thing the user confirms.
  TransferFlowProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'transferFlowProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$transferFlowHash();

  @$internal
  @override
  TransferFlow create() => TransferFlow();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransferFlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransferFlowState>(value),
    );
  }
}

String _$transferFlowHash() => r'736d2f20911bf63d2fdda8f909357fa87c1b7557';

/// Drives the recipient → amount → review → receipt flow.
///
/// The confirm is **pessimistic**, unlike Phase 7's optimistic freeze: a
/// transfer is only shown as done once the server says it is. Nothing
/// about a money movement may be guessed at and rolled back.
///
/// Every edit upstream of the review step clears the quote, so a stale
/// price can never be the thing the user confirms.

abstract class _$TransferFlow extends $Notifier<TransferFlowState> {
  TransferFlowState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TransferFlowState, TransferFlowState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<TransferFlowState, TransferFlowState>,
        TransferFlowState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
