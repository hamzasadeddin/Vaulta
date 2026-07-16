import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vaulta/app/placeholder_home.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_providers.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_state.dart';
import 'package:vaulta/features/auth/presentation/screens/login_screen.dart';
import 'package:vaulta/features/auth/presentation/screens/otp_screen.dart';
import 'package:vaulta/features/auth/presentation/screens/splash_screen.dart';
import 'package:vaulta/features/auth/presentation/screens/unlock_screen.dart';

part 'app_router.g.dart';

abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const otp = '/otp';
  static const unlock = '/unlock';
  static const home = '/';
}

/// The session state machine owns navigation: every auth state has exactly
/// one legal surface, enforced here rather than scattered across screens.
/// Typed-route codegen (go_router_builder) is deferred until the route
/// count justifies a third generator.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refresh = ValueNotifier(0);
  ref
    ..onDispose(refresh.dispose)
    ..listen(authControllerProvider, (_, __) => refresh.value++);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final location = state.matchedLocation;

      String? at(String target) => location == target ? null : target;

      return switch (auth) {
        AuthUnknown() => at(AppRoutes.splash),
        Unauthenticated() => at(AppRoutes.login),
        OtpPending() => at(AppRoutes.otp),
        Locked() => at(AppRoutes.unlock),
        Authenticated() => switch (location) {
            AppRoutes.splash ||
            AppRoutes.login ||
            AppRoutes.otp ||
            AppRoutes.unlock =>
              AppRoutes.home,
            _ => null,
          },
      };
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: AppRoutes.unlock,
        builder: (context, state) => const UnlockScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const PlaceholderHome(),
      ),
    ],
  );
}
