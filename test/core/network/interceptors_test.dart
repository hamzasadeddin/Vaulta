import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/network/auth_tokens.dart';
import 'package:vaulta/core/network/interceptors/auth_interceptor.dart';
import 'package:vaulta/core/network/interceptors/idempotency_interceptor.dart';

class _MockDio extends Mock implements Dio {}

class _MockRefresher extends Mock implements AuthTokenRefresher {}

/// Dio normally awaits handler futures; in unit tests nobody does, so an
/// error-completed future would surface as an unhandled async error.
/// `future` is @protected (dio-internal), hence the targeted ignores.
RequestInterceptorHandler _requestHandler() {
  final handler = RequestInterceptorHandler();
  // `future` is dio-internal; touched only to swallow error completions.
  // ignore: invalid_use_of_protected_member
  handler.future.ignore();
  return handler;
}

ErrorInterceptorHandler _errorHandler() {
  final handler = ErrorInterceptorHandler();
  // `future` is dio-internal; touched only to swallow error completions.
  // ignore: invalid_use_of_protected_member
  handler.future.ignore();
  return handler;
}

DioException _unauthorized(RequestOptions options) => DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
      response: Response<dynamic>(requestOptions: options, statusCode: 401),
    );

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
  });

  group('IdempotencyInterceptor', () {
    final interceptor = IdempotencyInterceptor();

    RequestOptions run(String method, {Map<String, dynamic>? headers}) {
      final options = RequestOptions(
        path: '/transfers',
        method: method,
        headers: headers,
      );
      interceptor.onRequest(options, _requestHandler());
      return options;
    }

    test('stamps mutating methods', () {
      for (final method in ['POST', 'PUT', 'PATCH', 'DELETE']) {
        final options = run(method);
        expect(
          options.headers[IdempotencyInterceptor.header],
          isNotEmpty,
          reason: '$method should carry an idempotency key',
        );
      }
    });

    test('leaves reads alone', () {
      expect(
        run('GET').headers.containsKey(IdempotencyInterceptor.header),
        isFalse,
      );
    });

    test('never overwrites a caller-provided key', () {
      final options = run(
        'POST',
        headers: {'idempotency-key': 'transfer-draft-42'},
      );
      // dio's header map is case-insensitive: both spellings resolve to the
      // caller's value, and no fresh UUID must replace it.
      expect(options.headers['idempotency-key'], 'transfer-draft-42');
      expect(
        options.headers[IdempotencyInterceptor.header],
        'transfer-draft-42',
      );
    });
  });

  group('AuthInterceptor', () {
    late _MockDio dio;
    late InMemoryAuthTokenStore store;
    late _MockRefresher refresher;
    late AuthInterceptor interceptor;

    setUp(() {
      dio = _MockDio();
      store = InMemoryAuthTokenStore();
      refresher = _MockRefresher();
      interceptor = AuthInterceptor(
        dio: dio,
        tokenStore: store,
        refresher: refresher,
      );
    });

    test('attaches bearer token on request', () async {
      await store.write(
        const AuthTokens(accessToken: 'access-1', refreshToken: 'refresh-1'),
      );
      final options = RequestOptions(path: '/accounts');
      await interceptor.onRequest(options, _requestHandler());
      expect(options.headers['Authorization'], 'Bearer access-1');
    });

    test('skips public endpoints', () async {
      await store.write(
        const AuthTokens(accessToken: 'access-1', refreshToken: 'refresh-1'),
      );
      final options = RequestOptions(
        path: '/auth/login',
        extra: {AuthInterceptor.skipAuthKey: true},
      );
      await interceptor.onRequest(options, _requestHandler());
      expect(options.headers.containsKey('Authorization'), isFalse);
    });

    test('refreshes once on 401 and retries with the new token', () async {
      await store.write(
        const AuthTokens(accessToken: 'stale', refreshToken: 'refresh-1'),
      );
      when(() => refresher.refresh('refresh-1')).thenAnswer(
        (_) async =>
            const AuthTokens(accessToken: 'fresh', refreshToken: 'refresh-2'),
      );

      final options = RequestOptions(path: '/accounts');
      await interceptor.onRequest(options, _requestHandler());

      when(() => dio.fetch<dynamic>(any())).thenAnswer(
        (invocation) async => Response<dynamic>(
          requestOptions:
              invocation.positionalArguments.first as RequestOptions,
          statusCode: 200,
        ),
      );

      await interceptor.onError(_unauthorized(options), _errorHandler());

      expect(options.headers['Authorization'], 'Bearer fresh');
      expect((await store.read())?.refreshToken, 'refresh-2');
      verify(() => refresher.refresh('refresh-1')).called(1);
    });

    test('reuses a token refreshed by a queued sibling request', () async {
      await store.write(
        const AuthTokens(accessToken: 'stale', refreshToken: 'refresh-1'),
      );
      final options = RequestOptions(path: '/accounts');
      await interceptor.onRequest(options, _requestHandler());

      // Simulate: while this request was in flight, another one refreshed.
      await store.write(
        const AuthTokens(accessToken: 'fresh', refreshToken: 'refresh-2'),
      );
      when(() => dio.fetch<dynamic>(any())).thenAnswer(
        (invocation) async => Response<dynamic>(
          requestOptions:
              invocation.positionalArguments.first as RequestOptions,
          statusCode: 200,
        ),
      );

      await interceptor.onError(_unauthorized(options), _errorHandler());

      expect(options.headers['Authorization'], 'Bearer fresh');
      verifyNever(() => refresher.refresh(any()));
    });

    test('clears the session when refresh fails', () async {
      await store.write(
        const AuthTokens(accessToken: 'stale', refreshToken: 'refresh-1'),
      );
      when(() => refresher.refresh(any())).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/auth/refresh')),
      );

      final options = RequestOptions(path: '/accounts');
      await interceptor.onRequest(options, _requestHandler());

      var sessionExpired = false;
      final expiring = AuthInterceptor(
        dio: dio,
        tokenStore: store,
        refresher: refresher,
        onSessionExpired: () async => sessionExpired = true,
      );

      await expiring.onError(_unauthorized(options), _errorHandler());
      expect(await store.read(), isNull);
      expect(sessionExpired, isTrue);
    });
  });
}
