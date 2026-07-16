import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulta/core/config/app_config.dart';
import 'package:vaulta/core/logging/logging_providers.dart';
import 'package:vaulta/core/network/auth_tokens.dart';
import 'package:vaulta/core/network/dio_client.dart';
import 'package:vaulta/core/network/mock/mock_api_interceptor.dart';

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

/// One mock per app so challenge/session state is shared by [dioProvider]
/// and [refreshDioProvider]. `null` when the flavor talks to a real API.
final mockApiInterceptorProvider = Provider<MockApiInterceptor?>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.useMockApi ? MockApiInterceptor() : null;
});

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  return buildDio(
    config: config,
    talker: ref.watch(talkerProvider),
    tokenStore: ref.watch(authTokenStoreProvider),
    tokenRefresher: ref.watch(authTokenRefresherProvider),
    onSessionExpired: ref.watch(sessionExpiredHandlerProvider),
    mockApi: ref.watch(mockApiInterceptorProvider),
  );
});

/// Bare client for the token refresher. Deliberately has no auth
/// interceptor — the refresher is *called by* the auth interceptor, and
/// sharing [dioProvider] would create a provider cycle.
final refreshDioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {'Accept': 'application/json'},
    ),
  );
  final mock = ref.watch(mockApiInterceptorProvider);
  if (mock != null) dio.interceptors.add(mock);
  return dio;
});
