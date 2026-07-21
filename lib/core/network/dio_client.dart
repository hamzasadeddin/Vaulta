import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:vaulta/core/config/app_config.dart';
import 'package:vaulta/core/network/auth_tokens.dart';
import 'package:vaulta/core/network/interceptors/auth_interceptor.dart';
import 'package:vaulta/core/network/interceptors/idempotency_interceptor.dart';
import 'package:vaulta/core/network/mock/mock_api_interceptor.dart';
import 'package:vaulta/core/network/sensitive.dart';

/// Builds the app's single [Dio] instance.
///
/// Interceptor order matters:
/// 1. Idempotency — the key must exist before any retry duplicates the call.
/// 2. Auth — handles 401 + refresh before the retry layer sees the error.
/// 3. Retry — transient network errors only (never retries 4xx).
/// 4. Logging — observes the final request/response shape.
/// 5. Mock API (optional) — truly last, so mocked traffic still flows
///    through the entire real pipeline; only the socket is fake.
Dio buildDio({
  required AppConfig config,
  required Talker talker,
  required AuthTokenStore tokenStore,
  AuthTokenRefresher? tokenRefresher,
  Future<void> Function()? onSessionExpired,
  MockApiInterceptor? mockApi,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: const {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    IdempotencyInterceptor(),
    AuthInterceptor(
      dio: dio,
      tokenStore: tokenStore,
      refresher: tokenRefresher,
      onSessionExpired: onSessionExpired,
    ),
    RetryInterceptor(
      dio: dio,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 4),
      ],
      logPrint: talker.warning,
    ),
    if (config.enableNetworkLogs)
      // Headers (Authorization / Idempotency-Key) stay unlogged:
      // TalkerDioLoggerSettings defaults keep them off; never enable them.
      // Response bodies marked sensitive (card PAN/CVV reveals) are
      // dropped wholesale — see core/network/sensitive.dart.
      TalkerDioLogger(
        talker: talker,
        settings: TalkerDioLoggerSettings(
          responseFilter: (response) =>
              response.requestOptions.extra[kSensitiveResponseBody] != true,
        ),
      ),
    if (mockApi != null) mockApi,
  ]);

  return dio;
}
