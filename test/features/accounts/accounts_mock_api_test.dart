import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:vaulta/core/config/app_config.dart';
import 'package:vaulta/core/network/auth_tokens.dart';
import 'package:vaulta/core/network/dio_client.dart';
import 'package:vaulta/core/network/interceptors/auth_interceptor.dart';
import 'package:vaulta/core/network/mock/mock_api_interceptor.dart';

/// `/accounts*` routes through the full pipeline (idempotency, auth, retry,
/// logging) — the same harness as the auth/dashboard pipeline tests. These
/// pin the fixture invariants the app relies on: shared balances with the
/// dashboard, deterministic history, internally consistent statements.
void main() {
  const config = AppConfig(
    flavor: Flavor.dev,
    apiBaseUrl: 'https://mock.vaulta.test/v1',
    enableNetworkLogs: false,
    useMockApi: true,
  );

  late InMemoryAuthTokenStore store;
  late Dio dio;

  Options public() => Options(extra: const {AuthInterceptor.skipAuthKey: true});

  setUp(() async {
    store = InMemoryAuthTokenStore();
    dio = buildDio(
      config: config,
      talker: Talker(),
      tokenStore: store,
      mockApi: MockApiInterceptor(latency: Duration.zero),
    );

    // Authenticate: login → OTP → persist tokens for the auth interceptor.
    final login = await dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': 'sam@example.com', 'password': 'hunter2hunter2'},
      options: public(),
    );
    final verify = await dio.post<Map<String, dynamic>>(
      '/auth/otp/verify',
      data: {
        'challengeId': login.data!['challengeId'],
        'code': MockApiInterceptor.otpCode,
      },
      options: public(),
    );
    await store.write(
      AuthTokens(
        accessToken: verify.data!['accessToken'] as String,
        refreshToken: verify.data!['refreshToken'] as String,
      ),
    );
  });

  group('GET /accounts', () {
    test('returns the three fixture accounts with full metadata', () async {
      final response = await dio.get<Map<String, dynamic>>('/accounts');

      final accounts = response.data!['accounts'] as List<dynamic>;
      expect(accounts, hasLength(3));
      final first = accounts.first as Map<String, dynamic>;
      expect(first['id'], 'acc_chk');
      expect(first['type'], 'checking');
      expect(first['iban'], startsWith('JO'));
      expect((first['iban'] as String).length, 30);
      expect(first['balanceMinor'], 1248050);
      expect(first['openedAt'], isA<String>());
    });

    test('rejects unauthenticated access with 401', () async {
      await store.clear();
      expect(
        () => dio.get<Map<String, dynamic>>('/accounts', options: public()),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            401,
          ),
        ),
      );
    });
  });

  group('GET /accounts/:id/history', () {
    test('honors the days window and lands on the current balance', () async {
      final response = await dio.get<Map<String, dynamic>>(
        '/accounts/acc_chk/history',
        queryParameters: {'days': 30},
      );

      expect(response.data!['currency'], 'USD');
      final points = response.data!['points'] as List<dynamic>;
      expect(points, hasLength(31), reason: 'N deltas → N+1 daily points');
      final last = points.last as Map<String, dynamic>;
      expect(
        last['balanceMinor'],
        1248050,
        reason: 'history must end at the balance every other screen shows',
      );
    });

    test('is deterministic across calls', () async {
      final first = await dio.get<Map<String, dynamic>>(
        '/accounts/acc_sav/history',
        queryParameters: {'days': 90},
      );
      final second = await dio.get<Map<String, dynamic>>(
        '/accounts/acc_sav/history',
        queryParameters: {'days': 90},
      );
      expect(first.data!['points'], second.data!['points']);
    });

    test('404s an unknown account', () async {
      expect(
        () => dio.get<Map<String, dynamic>>('/accounts/acc_nope/history'),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            404,
          ),
        ),
      );
    });
  });

  group('GET /accounts/:id/statements', () {
    test('lists three months of metadata without lines', () async {
      final response = await dio.get<Map<String, dynamic>>(
        '/accounts/acc_chk/statements',
      );

      final statements = response.data!['statements'] as List<dynamic>;
      expect(statements, hasLength(3));
      final first = statements.first as Map<String, dynamic>;
      expect(first.containsKey('lines'), isFalse);
      expect(first['currency'], 'USD');
      expect(first['transactionCount'], greaterThan(0));
    });

    test('detail is ledger-consistent: closing == opening + sum(lines)',
        () async {
      final list = await dio.get<Map<String, dynamic>>(
        '/accounts/acc_chk/statements',
      );
      final statements = list.data!['statements'] as List<dynamic>;

      for (final entry in statements) {
        final meta = entry as Map<String, dynamic>;
        final detail = await dio.get<Map<String, dynamic>>(
          '/accounts/acc_chk/statements/${meta['id']}',
        );
        final lines = detail.data!['lines'] as List<dynamic>;
        final net = lines.fold<int>(
          0,
          (sum, line) =>
              sum + ((line as Map<String, dynamic>)['amountMinor'] as int),
        );
        expect(
          detail.data!['closingBalanceMinor'],
          (detail.data!['openingBalanceMinor'] as int) + net,
        );
        expect(lines, isNotEmpty);
      }
    });

    test('consecutive statements chain: previous closing == next opening',
        () async {
      final response = await dio.get<Map<String, dynamic>>(
        '/accounts/acc_jod/statements',
      );
      final statements = (response.data!['statements'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

      // Response is newest-first (1, 2, 3 months back).
      for (var i = 0; i < statements.length - 1; i++) {
        expect(
          statements[i]['openingBalanceMinor'],
          statements[i + 1]['closingBalanceMinor'],
        );
      }
    });

    test('404s an unknown statement id', () async {
      expect(
        () => dio.get<Map<String, dynamic>>(
          '/accounts/acc_chk/statements/stm_nope',
        ),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            404,
          ),
        ),
      );
    });
  });
}
