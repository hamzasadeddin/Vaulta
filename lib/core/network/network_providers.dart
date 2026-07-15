import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulta/core/config/app_config.dart';
import 'package:vaulta/core/logging/logging_providers.dart';
import 'package:vaulta/core/network/auth_tokens.dart';
import 'package:vaulta/core/network/dio_client.dart';

/// In-memory by default; the auth feature (Phase 3) overrides this with a
/// `flutter_secure_storage`-backed implementation.
final authTokenStoreProvider = Provider<AuthTokenStore>(
  (ref) => InMemoryAuthTokenStore(),
);

/// `null` until the auth feature provides a real refresher (Phase 3).
/// Without one, a 401 simply expires the session.
final authTokenRefresherProvider = Provider<AuthTokenRefresher?>(
  (ref) => null,
);

/// Invoked when the session is unrecoverable (refresh failed / no refresh
/// token). The router layer (Phase 3) overrides this to redirect to login.
final sessionExpiredHandlerProvider = Provider<Future<void> Function()?>(
  (ref) => null,
);

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  return buildDio(
    config: config,
    talker: ref.watch(talkerProvider),
    tokenStore: ref.watch(authTokenStoreProvider),
    tokenRefresher: ref.watch(authTokenRefresherProvider),
    onSessionExpired: ref.watch(sessionExpiredHandlerProvider),
  );
});
