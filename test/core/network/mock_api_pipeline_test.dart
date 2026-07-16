import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:vaulta/core/config/app_config.dart';
import 'package:vaulta/core/network/auth_tokens.dart';
import 'package:vaulta/core/network/dio_client.dart';
import 'package:vaulta/core/network/interceptors/auth_interceptor.dart';
import 'package:vaulta/core/network/mock/mock_api_interceptor.dart';

/// These tests run the *entire* network pipeline — idempotency, auth,
/// retry, logging — against the mock API. Only the socket is fake.
void main() {
  const config = AppConfig(
    flavor: Flavor.dev,
    apiBaseUrl: 'https://mock.vaulta.test/v1',
    enableNetworkLogs: false,
    useMockApi: true,
  );

  late InMemoryAuthTokenStore store;
  late MockApiInterceptor mock;
  late Dio dio;

  Options public() => Options(extra: const {AuthInterceptor.skipAuthKey: true});

  setUp(() {
    store = InMemoryAuthTokenStore();
    mock = MockApiInterceptor(latency: Duration.zero);
    dio = buildDio(
      config: config,
      talker: Talker(),
      tokenStore: store,
      mockApi: mock,
    );
  });

  Future<String> loginForChallenge() async {
    final response = await dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': 'sam@example.com', 'password': 'hunter2hunter2'},
      options: public(),
    );
    return response.data!['challengeId'] as String;
  }

  group('mock API through the full pipeline', () {
    test('login issues an OTP challenge for valid credentials', () async {
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': 'sam@example.com', 'password': 'hunter2hunter2'},
        options: public(),
      );
      expect(response.statusCode, 200);
      expect(response.data!['challengeId'], startsWith('chl_'));
      expect(response.data!['maskedDestination'], 's***@example.com');
    });

    test('login rejects bad credentials with 401', () async {
      expect(
        () => dio.post<Map<String, dynamic>>(
          '/auth/login',
          data: {'email': 'sam@example.com', 'password': 'short'},
          options: public(),
        ),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
    });

    test('correct OTP returns tokens and user', () async {
      final challengeId = await loginForChallenge();
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/otp/verify',
        data: {'challengeId': challengeId, 'code': MockApiInterceptor.otpCode},
        options: public(),
      );
      expect(response.statusCode, 200);
      expect(response.data!['accessToken'], startsWith('mock-access-'));
      final user = response.data!['user'] as Map<String, dynamic>;
      expect(user['email'], 'sam@example.com');
    });

    test('wrong OTP returns 422 with a field error and allows retry', () async {
      final challengeId = await loginForChallenge();
      await expectLater(
        dio.post<Map<String, dynamic>>(
          '/auth/otp/verify',
          data: {'challengeId': challengeId, 'code': '000000'},
          options: public(),
        ),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            422,
          ),
        ),
      );
      // Same challenge still valid afterwards.
      final retry = await dio.post<Map<String, dynamic>>(
        '/auth/otp/verify',
        data: {'challengeId': challengeId, 'code': MockApiInterceptor.otpCode},
        options: public(),
      );
      expect(retry.statusCode, 200);
    });

    test('mutating requests carry an Idempotency-Key end to end', () async {
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': 'sam@example.com', 'password': 'hunter2hunter2'},
        options: public(),
      );
      final sent = response.requestOptions.headers['Idempotency-Key'];
      expect(sent, isNotNull);
    });

    test('expired access token is refreshed transparently on /auth/me',
        () async {
      // Seed a session whose access token the mock rejects but whose
      // refresh token it accepts — the auth interceptor must recover.
      await store.write(
        const AuthTokens(
          accessToken: 'expired-token',
          refreshToken: 'mock-refresh-1',
        ),
      );
      // Give the auth interceptor a refresher that talks to the same mock.
      final refreshDio = Dio(BaseOptions(baseUrl: config.apiBaseUrl))
        ..interceptors.add(mock);
      dio = buildDio(
        config: config,
        talker: Talker(),
        tokenStore: store,
        tokenRefresher: _MockBackedRefresher(refreshDio),
        mockApi: mock,
      );

      final response = await dio.get<Map<String, dynamic>>('/auth/me');
      expect(response.statusCode, 200);
      final tokens = await store.read();
      expect(tokens?.accessToken, startsWith('mock-access-'));
    });
  });
}

class _MockBackedRefresher implements AuthTokenRefresher {
  const _MockBackedRefresher(this._dio);

  final Dio _dio;

  @override
  Future<AuthTokens> refresh(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    return AuthTokens(
      accessToken: response.data!['accessToken'] as String,
      refreshToken: response.data!['refreshToken'] as String,
    );
  }
}
