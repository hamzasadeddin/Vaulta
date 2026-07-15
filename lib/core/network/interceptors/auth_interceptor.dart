import 'package:dio/dio.dart';
import 'package:vaulta/core/network/auth_tokens.dart';

/// Attaches the bearer token and transparently refreshes the session on 401.
///
/// Extends [QueuedInterceptor] so concurrent 401s are handled serially: the
/// first request refreshes; the ones queued behind it see a newer access
/// token in the store than the one they failed with, and simply retry —
/// one refresh per expiry, no thundering herd.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required Dio dio,
    required AuthTokenStore tokenStore,
    AuthTokenRefresher? refresher,
    Future<void> Function()? onSessionExpired,
  })  : _dio = dio,
        _tokenStore = tokenStore,
        _refresher = refresher,
        _onSessionExpired = onSessionExpired;

  /// Set `options.extra[AuthInterceptor.skipAuthKey] = true` on public
  /// endpoints (login, OTP) to bypass this interceptor entirely.
  static const skipAuthKey = 'vaulta.auth.skip';

  static const _retriedKey = 'vaulta.auth.retried';
  static const _usedTokenKey = 'vaulta.auth.usedToken';

  final Dio _dio;
  final AuthTokenStore _tokenStore;
  final AuthTokenRefresher? _refresher;
  final Future<void> Function()? _onSessionExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuthKey] == true) {
      return handler.next(options);
    }
    final tokens = await _tokenStore.read();
    final accessToken = tokens?.accessToken;
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
      options.extra[_usedTokenKey] = accessToken;
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final isRetryable = err.response?.statusCode == 401 &&
        options.extra[skipAuthKey] != true &&
        options.extra[_retriedKey] != true;
    if (!isRetryable) {
      return handler.next(err);
    }

    final newAccessToken = await _resolveFreshToken(
      options.extra[_usedTokenKey] as String?,
    );
    if (newAccessToken == null) {
      await _expireSession();
      return handler.next(err);
    }

    options.extra[_retriedKey] = true;
    options.extra[_usedTokenKey] = newAccessToken;
    options.headers['Authorization'] = 'Bearer $newAccessToken';
    try {
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  /// Returns a token newer than [failedToken], refreshing if needed,
  /// or `null` if the session cannot be recovered.
  Future<String?> _resolveFreshToken(String? failedToken) async {
    final current = await _tokenStore.read();

    // Another queued request already refreshed while we waited.
    final currentAccess = current?.accessToken;
    if (currentAccess != null && currentAccess != failedToken) {
      return currentAccess;
    }

    final refresher = _refresher;
    final refreshToken = current?.refreshToken;
    if (refresher == null || refreshToken == null) return null;

    try {
      final fresh = await refresher.refresh(refreshToken);
      await _tokenStore.write(fresh);
      return fresh.accessToken;
    } on Object {
      return null;
    }
  }

  Future<void> _expireSession() async {
    await _tokenStore.clear();
    await _onSessionExpired?.call();
  }
}
