// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbox_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition point for the outbox. `keepAlive` for the same reason the
/// session is: the queue outlives every screen, and a transfer that
/// stopped draining because the user navigated away would be a bug with
/// money in it.

@ProviderFor(outboxRepository)
final outboxRepositoryProvider = OutboxRepositoryProvider._();

/// Composition point for the outbox. `keepAlive` for the same reason the
/// session is: the queue outlives every screen, and a transfer that
/// stopped draining because the user navigated away would be a bug with
/// money in it.

final class OutboxRepositoryProvider extends $FunctionalProvider<
    OutboxRepository,
    OutboxRepository,
    OutboxRepository> with $Provider<OutboxRepository> {
  /// Composition point for the outbox. `keepAlive` for the same reason the
  /// session is: the queue outlives every screen, and a transfer that
  /// stopped draining because the user navigated away would be a bug with
  /// money in it.
  OutboxRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'outboxRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$outboxRepositoryHash();

  @$internal
  @override
  $ProviderElement<OutboxRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OutboxRepository create(Ref ref) {
    return outboxRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OutboxRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OutboxRepository>(value),
    );
  }
}

String _$outboxRepositoryHash() => r'89a44bcb04247b5d1262f4ed41a7974ad8da97f4';

/// Owns the queue's read model *and* its delivery loop.
///
/// One notifier rather than two because the two are the same state
/// machine seen from different ends: a drain changes rows, and rows
/// determine when the next drain should be. Splitting them would mean
/// keeping a timer in one place in sync with a list in another.
///
/// The drain is woken by four things, in descending reliability:
/// the periodic backoff timer, an explicit retry, app start, and a
/// connectivity hint. The hint is last on purpose — it reports interface
/// state, not reachability, so it may fire when nothing works and stay
/// silent when everything does (see [ConnectivityMonitor]).

@ProviderFor(OutboxController)
final outboxControllerProvider = OutboxControllerProvider._();

/// Owns the queue's read model *and* its delivery loop.
///
/// One notifier rather than two because the two are the same state
/// machine seen from different ends: a drain changes rows, and rows
/// determine when the next drain should be. Splitting them would mean
/// keeping a timer in one place in sync with a list in another.
///
/// The drain is woken by four things, in descending reliability:
/// the periodic backoff timer, an explicit retry, app start, and a
/// connectivity hint. The hint is last on purpose — it reports interface
/// state, not reachability, so it may fire when nothing works and stay
/// silent when everything does (see [ConnectivityMonitor]).
final class OutboxControllerProvider
    extends $NotifierProvider<OutboxController, AsyncValue<List<OutboxEntry>>> {
  /// Owns the queue's read model *and* its delivery loop.
  ///
  /// One notifier rather than two because the two are the same state
  /// machine seen from different ends: a drain changes rows, and rows
  /// determine when the next drain should be. Splitting them would mean
  /// keeping a timer in one place in sync with a list in another.
  ///
  /// The drain is woken by four things, in descending reliability:
  /// the periodic backoff timer, an explicit retry, app start, and a
  /// connectivity hint. The hint is last on purpose — it reports interface
  /// state, not reachability, so it may fire when nothing works and stay
  /// silent when everything does (see [ConnectivityMonitor]).
  OutboxControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'outboxControllerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$outboxControllerHash();

  @$internal
  @override
  OutboxController create() => OutboxController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<OutboxEntry>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<OutboxEntry>>>(value),
    );
  }
}

String _$outboxControllerHash() => r'3ce5e398567aacfbb5f6940b977af92e4958fd9a';

/// Owns the queue's read model *and* its delivery loop.
///
/// One notifier rather than two because the two are the same state
/// machine seen from different ends: a drain changes rows, and rows
/// determine when the next drain should be. Splitting them would mean
/// keeping a timer in one place in sync with a list in another.
///
/// The drain is woken by four things, in descending reliability:
/// the periodic backoff timer, an explicit retry, app start, and a
/// connectivity hint. The hint is last on purpose — it reports interface
/// state, not reachability, so it may fire when nothing works and stay
/// silent when everything does (see [ConnectivityMonitor]).

abstract class _$OutboxController
    extends $Notifier<AsyncValue<List<OutboxEntry>>> {
  AsyncValue<List<OutboxEntry>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<OutboxEntry>>, AsyncValue<List<OutboxEntry>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<OutboxEntry>>,
            AsyncValue<List<OutboxEntry>>>,
        AsyncValue<List<OutboxEntry>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
