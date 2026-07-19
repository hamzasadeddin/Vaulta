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
///
/// Signed-in surfaces live in a [StatefulShellRoute]: each branch keeps its
/// own navigator (scroll positions and detail stacks survive tab switches),
/// and [AppShell] renders the adaptive chrome around them. The auth
/// redirect is untouched — any non-auth location is legal once
/// authenticated, and everything else still collapses to its single screen.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// The session state machine owns navigation: every auth state has exactly
/// one legal surface, enforced here rather than scattered across screens.
/// Typed-route codegen (go_router_builder) is deferred until the route
/// count justifies a third generator.
///
/// Signed-in surfaces live in a [StatefulShellRoute]: each branch keeps its
/// own navigator (scroll positions and detail stacks survive tab switches),
/// and [AppShell] renders the adaptive chrome around them. The auth
/// redirect is untouched — any non-auth location is legal once
/// authenticated, and everything else still collapses to its single screen.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// The session state machine owns navigation: every auth state has exactly
  /// one legal surface, enforced here rather than scattered across screens.
  /// Typed-route codegen (go_router_builder) is deferred until the route
  /// count justifies a third generator.
  ///
  /// Signed-in surfaces live in a [StatefulShellRoute]: each branch keeps its
  /// own navigator (scroll positions and detail stacks survive tab switches),
  /// and [AppShell] renders the adaptive chrome around them. The auth
  /// redirect is untouched — any non-auth location is legal once
  /// authenticated, and everything else still collapses to its single screen.
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

String _$appRouterHash() => r'd23316af411101bb2f3a9b54373896f05ddeaa0d';
