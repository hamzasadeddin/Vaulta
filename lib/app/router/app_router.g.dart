// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The session state machine owns navigation: every auth state has exactly
/// one legal surface, enforced here rather than scattered across screens.
/// Typed-route codegen (go_router_builder) is deferred until the route
/// count justifies a third generator.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// The session state machine owns navigation: every auth state has exactly
/// one legal surface, enforced here rather than scattered across screens.
/// Typed-route codegen (go_router_builder) is deferred until the route
/// count justifies a third generator.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// The session state machine owns navigation: every auth state has exactly
  /// one legal surface, enforced here rather than scattered across screens.
  /// Typed-route codegen (go_router_builder) is deferred until the route
  /// count justifies a third generator.
  AppRouterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'appRouterProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'490827b36cdfbed7ed399a5adda71b3a68d046f4';
