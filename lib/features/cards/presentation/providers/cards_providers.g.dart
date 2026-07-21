// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cards_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition point for the cards slice. Tests override this with a
/// mocked [CardsRepository] — the same seam as every feature.

@ProviderFor(cardsRepository)
final cardsRepositoryProvider = CardsRepositoryProvider._();

/// Composition point for the cards slice. Tests override this with a
/// mocked [CardsRepository] — the same seam as every feature.

final class CardsRepositoryProvider extends $FunctionalProvider<CardsRepository,
    CardsRepository, CardsRepository> with $Provider<CardsRepository> {
  /// Composition point for the cards slice. Tests override this with a
  /// mocked [CardsRepository] — the same seam as every feature.
  CardsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cardsRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cardsRepositoryHash();

  @$internal
  @override
  $ProviderElement<CardsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CardsRepository create(Ref ref) {
    return cardsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CardsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CardsRepository>(value),
    );
  }
}

String _$cardsRepositoryHash() => r'efbe1cba4f4a84b23272250f4ee33e94e471ffb0';

/// The card list plus its mutations. Holds `AsyncValue` manually (the
/// dashboard/accounts/transactions pattern): data survives a failed
/// refresh, and mutations edit the value in place.
///
/// Freeze/unfreeze is the codebase's first *optimistic* mutation: the flip
/// lands in state immediately, the server call runs behind it, and the
/// controller either reconciles with the returned card or rolls back to
/// the pre-mutation snapshot on failure — all as `Result` values, never
/// thrown.

@ProviderFor(CardsController)
final cardsControllerProvider = CardsControllerProvider._();

/// The card list plus its mutations. Holds `AsyncValue` manually (the
/// dashboard/accounts/transactions pattern): data survives a failed
/// refresh, and mutations edit the value in place.
///
/// Freeze/unfreeze is the codebase's first *optimistic* mutation: the flip
/// lands in state immediately, the server call runs behind it, and the
/// controller either reconciles with the returned card or rolls back to
/// the pre-mutation snapshot on failure — all as `Result` values, never
/// thrown.
final class CardsControllerProvider
    extends $NotifierProvider<CardsController, AsyncValue<List<BankCard>>> {
  /// The card list plus its mutations. Holds `AsyncValue` manually (the
  /// dashboard/accounts/transactions pattern): data survives a failed
  /// refresh, and mutations edit the value in place.
  ///
  /// Freeze/unfreeze is the codebase's first *optimistic* mutation: the flip
  /// lands in state immediately, the server call runs behind it, and the
  /// controller either reconciles with the returned card or rolls back to
  /// the pre-mutation snapshot on failure — all as `Result` values, never
  /// thrown.
  CardsControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cardsControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cardsControllerHash();

  @$internal
  @override
  CardsController create() => CardsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<BankCard>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<BankCard>>>(value),
    );
  }
}

String _$cardsControllerHash() => r'0327590903b3e2892d2cd9ff1c3a3e5af8d9917b';

/// The card list plus its mutations. Holds `AsyncValue` manually (the
/// dashboard/accounts/transactions pattern): data survives a failed
/// refresh, and mutations edit the value in place.
///
/// Freeze/unfreeze is the codebase's first *optimistic* mutation: the flip
/// lands in state immediately, the server call runs behind it, and the
/// controller either reconciles with the returned card or rolls back to
/// the pre-mutation snapshot on failure — all as `Result` values, never
/// thrown.

abstract class _$CardsController extends $Notifier<AsyncValue<List<BankCard>>> {
  AsyncValue<List<BankCard>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<BankCard>>, AsyncValue<List<BankCard>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<BankCard>>, AsyncValue<List<BankCard>>>,
        AsyncValue<List<BankCard>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}

/// Lookup into the loaded list — the detail surface resolves its card here
/// instead of refetching (the `accountById` pattern).

@ProviderFor(cardById)
final cardByIdProvider = CardByIdFamily._();

/// Lookup into the loaded list — the detail surface resolves its card here
/// instead of refetching (the `accountById` pattern).

final class CardByIdProvider
    extends $FunctionalProvider<BankCard?, BankCard?, BankCard?>
    with $Provider<BankCard?> {
  /// Lookup into the loaded list — the detail surface resolves its card here
  /// instead of refetching (the `accountById` pattern).
  CardByIdProvider._(
      {required CardByIdFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'cardByIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cardByIdHash();

  @override
  String toString() {
    return r'cardByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<BankCard?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BankCard? create(Ref ref) {
    final argument = this.argument as String;
    return cardById(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BankCard? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BankCard?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CardByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cardByIdHash() => r'c6ddca9f842499e0284c00c5cf93e4abadbeccfc';

/// Lookup into the loaded list — the detail surface resolves its card here
/// instead of refetching (the `accountById` pattern).

final class CardByIdFamily extends $Family
    with $FunctionalFamilyOverride<BankCard?, String> {
  CardByIdFamily._()
      : super(
          retry: null,
          name: r'cardByIdProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Lookup into the loaded list — the detail surface resolves its card here
  /// instead of refetching (the `accountById` pattern).

  CardByIdProvider call(
    String cardId,
  ) =>
      CardByIdProvider._(argument: cardId, from: this);

  @override
  String toString() => r'cardByIdProvider';
}

/// Reveal lifecycle for one card's PAN: hidden (`AsyncData(null)`) →
/// loading → revealed (`AsyncData(pan)`) → auto-hidden after
/// [autoHideAfter]. The secret only ever lives in this provider's state,
/// and the reveal itself is gated behind the biometric service.

@ProviderFor(RevealedPan)
final revealedPanProvider = RevealedPanFamily._();

/// Reveal lifecycle for one card's PAN: hidden (`AsyncData(null)`) →
/// loading → revealed (`AsyncData(pan)`) → auto-hidden after
/// [autoHideAfter]. The secret only ever lives in this provider's state,
/// and the reveal itself is gated behind the biometric service.
final class RevealedPanProvider
    extends $NotifierProvider<RevealedPan, AsyncValue<CardPan?>> {
  /// Reveal lifecycle for one card's PAN: hidden (`AsyncData(null)`) →
  /// loading → revealed (`AsyncData(pan)`) → auto-hidden after
  /// [autoHideAfter]. The secret only ever lives in this provider's state,
  /// and the reveal itself is gated behind the biometric service.
  RevealedPanProvider._(
      {required RevealedPanFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'revealedPanProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$revealedPanHash();

  @override
  String toString() {
    return r'revealedPanProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RevealedPan create() => RevealedPan();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CardPan?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<CardPan?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RevealedPanProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$revealedPanHash() => r'862d7bea60f6efb4995e6487f933cdd8494e00b5';

/// Reveal lifecycle for one card's PAN: hidden (`AsyncData(null)`) →
/// loading → revealed (`AsyncData(pan)`) → auto-hidden after
/// [autoHideAfter]. The secret only ever lives in this provider's state,
/// and the reveal itself is gated behind the biometric service.

final class RevealedPanFamily extends $Family
    with
        $ClassFamilyOverride<RevealedPan, AsyncValue<CardPan?>,
            AsyncValue<CardPan?>, AsyncValue<CardPan?>, String> {
  RevealedPanFamily._()
      : super(
          retry: null,
          name: r'revealedPanProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Reveal lifecycle for one card's PAN: hidden (`AsyncData(null)`) →
  /// loading → revealed (`AsyncData(pan)`) → auto-hidden after
  /// [autoHideAfter]. The secret only ever lives in this provider's state,
  /// and the reveal itself is gated behind the biometric service.

  RevealedPanProvider call(
    String cardId,
  ) =>
      RevealedPanProvider._(argument: cardId, from: this);

  @override
  String toString() => r'revealedPanProvider';
}

/// Reveal lifecycle for one card's PAN: hidden (`AsyncData(null)`) →
/// loading → revealed (`AsyncData(pan)`) → auto-hidden after
/// [autoHideAfter]. The secret only ever lives in this provider's state,
/// and the reveal itself is gated behind the biometric service.

abstract class _$RevealedPan extends $Notifier<AsyncValue<CardPan?>> {
  late final _$args = ref.$arg as String;
  String get cardId => _$args;

  AsyncValue<CardPan?> build(
    String cardId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CardPan?>, AsyncValue<CardPan?>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<CardPan?>, AsyncValue<CardPan?>>,
        AsyncValue<CardPan?>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
