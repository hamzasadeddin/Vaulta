// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fraud_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition point for the fraud slice. `keepAlive` for the same reason
/// the outbox is: a push can arrive on any screen, and the store that
/// holds it until the user answers must outlive whichever surface first
/// showed it.

@ProviderFor(fraudRepository)
final fraudRepositoryProvider = FraudRepositoryProvider._();

/// Composition point for the fraud slice. `keepAlive` for the same reason
/// the outbox is: a push can arrive on any screen, and the store that
/// holds it until the user answers must outlive whichever surface first
/// showed it.

final class FraudRepositoryProvider extends $FunctionalProvider<FraudRepository,
    FraudRepository, FraudRepository> with $Provider<FraudRepository> {
  /// Composition point for the fraud slice. `keepAlive` for the same reason
  /// the outbox is: a push can arrive on any screen, and the store that
  /// holds it until the user answers must outlive whichever surface first
  /// showed it.
  FraudRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'fraudRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$fraudRepositoryHash();

  @$internal
  @override
  $ProviderElement<FraudRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FraudRepository create(Ref ref) {
    return fraudRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FraudRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FraudRepository>(value),
    );
  }
}

String _$fraudRepositoryHash() => r'b4c95ae6e0818fe2b315beea0678b890618e8e97';

/// Owns the alert read model and the two decisions an alert offers:
/// freeze the card, or dismiss it.
///
/// `keepAlive` so a notification posted while the dashboard isn't mounted
/// still fires exactly once. It subscribes to the store on build and
/// pushes each newly-arrived *active* alert to the [FraudNotifier] — the
/// controller is the deduplication point, so the notifier may post
/// unconditionally.

@ProviderFor(FraudAlertController)
final fraudAlertControllerProvider = FraudAlertControllerProvider._();

/// Owns the alert read model and the two decisions an alert offers:
/// freeze the card, or dismiss it.
///
/// `keepAlive` so a notification posted while the dashboard isn't mounted
/// still fires exactly once. It subscribes to the store on build and
/// pushes each newly-arrived *active* alert to the [FraudNotifier] — the
/// controller is the deduplication point, so the notifier may post
/// unconditionally.
final class FraudAlertControllerProvider extends $NotifierProvider<
    FraudAlertController, AsyncValue<List<FraudAlert>>> {
  /// Owns the alert read model and the two decisions an alert offers:
  /// freeze the card, or dismiss it.
  ///
  /// `keepAlive` so a notification posted while the dashboard isn't mounted
  /// still fires exactly once. It subscribes to the store on build and
  /// pushes each newly-arrived *active* alert to the [FraudNotifier] — the
  /// controller is the deduplication point, so the notifier may post
  /// unconditionally.
  FraudAlertControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'fraudAlertControllerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$fraudAlertControllerHash();

  @$internal
  @override
  FraudAlertController create() => FraudAlertController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<FraudAlert>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<FraudAlert>>>(value),
    );
  }
}

String _$fraudAlertControllerHash() =>
    r'610ee2ade09ee8d8e396e5bcc30c90eec1dc32b1';

/// Owns the alert read model and the two decisions an alert offers:
/// freeze the card, or dismiss it.
///
/// `keepAlive` so a notification posted while the dashboard isn't mounted
/// still fires exactly once. It subscribes to the store on build and
/// pushes each newly-arrived *active* alert to the [FraudNotifier] — the
/// controller is the deduplication point, so the notifier may post
/// unconditionally.

abstract class _$FraudAlertController
    extends $Notifier<AsyncValue<List<FraudAlert>>> {
  AsyncValue<List<FraudAlert>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<FraudAlert>>, AsyncValue<List<FraudAlert>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<FraudAlert>>, AsyncValue<List<FraudAlert>>>,
        AsyncValue<List<FraudAlert>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
