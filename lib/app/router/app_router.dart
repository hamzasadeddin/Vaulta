import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vaulta/app/shell/app_shell.dart';
import 'package:vaulta/features/accounts/presentation/accounts_paths.dart';
import 'package:vaulta/features/accounts/presentation/screens/account_detail_screen.dart';
import 'package:vaulta/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_providers.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_state.dart';
import 'package:vaulta/features/auth/presentation/screens/login_screen.dart';
import 'package:vaulta/features/auth/presentation/screens/otp_screen.dart';
import 'package:vaulta/features/auth/presentation/screens/splash_screen.dart';
import 'package:vaulta/features/auth/presentation/screens/unlock_screen.dart';
import 'package:vaulta/features/cards/presentation/cards_paths.dart';
import 'package:vaulta/features/cards/presentation/screens/card_detail_screen.dart';
import 'package:vaulta/features/cards/presentation/screens/cards_screen.dart';
import 'package:vaulta/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:vaulta/features/transactions/presentation/screens/transaction_detail_screen.dart';
import 'package:vaulta/features/transactions/presentation/screens/transactions_screen.dart';
import 'package:vaulta/features/transactions/presentation/transactions_paths.dart';

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
///
/// Signed-in surfaces live in a [StatefulShellRoute]: each branch keeps its
/// own navigator (scroll positions and detail stacks survive tab switches),
/// and [AppShell] renders the adaptive chrome around them. The auth
/// redirect is untouched — any non-auth location is legal once
/// authenticated, and everything else still collapses to its single screen.
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AccountsPaths.root,
                builder: (context, state) => const AccountsScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => AccountDetailScreen(
                      accountId: state.pathParameters['id'] ?? '',
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: TransactionsPaths.root,
                builder: (context, state) => TransactionsScreen(
                  initialAccountId: state.uri.queryParameters['account'],
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => TransactionDetailScreen(
                      transactionId: state.pathParameters['id'] ?? '',
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Appended last (Phase 7) so the existing branch indices — which
          // AppShell pins as constants — are untouched.
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: CardsPaths.root,
                builder: (context, state) => const CardsScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => CardDetailScreen(
                      cardId: state.pathParameters['id'] ?? '',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
