import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:vaulta/core/config/app_config.dart';
import 'package:vaulta/core/network/auth_tokens.dart';
import 'package:vaulta/core/network/dio_client.dart';
import 'package:vaulta/core/network/interceptors/auth_interceptor.dart';
import 'package:vaulta/core/network/mock/mock_api_interceptor.dart';

/// `/cards*` through the full pipeline — the accounts/transactions harness.
/// Pins the Phase 7 contract: FK-consistent fixtures, Luhn-valid PANs whose
/// last four match the list mask, freeze/limits state that persists across
/// GETs, server-side validation, and the auth gate.
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

  bool luhnValid(String pan) {
    var sum = 0;
    var doubleIt = false;
    for (var i = pan.length - 1; i >= 0; i--) {
      var digit = pan.codeUnitAt(i) - 0x30;
      if (doubleIt) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      doubleIt = !doubleIt;
    }
    return sum % 10 == 0;
  }

  Future<List<Map<String, dynamic>>> listCards() async {
    final response = await dio.get<Map<String, dynamic>>('/cards');
    return (response.data!['cards'] as List).cast<Map<String, dynamic>>();
  }

  setUp(() async {
    store = InMemoryAuthTokenStore();
    dio = buildDio(
      config: config,
      talker: Talker(),
      tokenStore: store,
      mockApi: MockApiInterceptor(latency: Duration.zero),
    );

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

  test('lists three cards that FK into real accounts', () async {
    final cards = await listCards();
    expect(cards.length, 3);
    const accountIds = {'acc_chk', 'acc_jod'};
    for (final card in cards) {
      expect(accountIds.contains(card['accountId']), isTrue);
    }
    // The JOD card carries the 3-minor-digit currency.
    final jod = cards.firstWhere((c) => c['accountId'] == 'acc_jod');
    expect(jod['currency'], 'JOD');
  });

  test('responses are byte-stable across calls', () async {
    final first = await listCards();
    final second = await listCards();
    expect(first, second);
  });

  test('reveal returns a Luhn-valid PAN whose last four match the mask',
      () async {
    final cards = await listCards();
    final card = cards.first;
    final reveal = await dio.post<Map<String, dynamic>>(
      '/cards/${card['id']}/reveal',
    );
    final pan = reveal.data!['pan'] as String;
    expect(luhnValid(pan), isTrue);
    expect(pan.substring(pan.length - 4), card['panLast4']);
    expect(reveal.data!['cvv'], isA<String>());
  });

  test('freeze persists across GETs, and unfreeze reverses it', () async {
    final active =
        (await listCards()).firstWhere((c) => c['status'] == 'active');
    final id = active['id'];

    await dio.post<Map<String, dynamic>>('/cards/$id/freeze');
    final afterFreeze = (await listCards()).firstWhere((c) => c['id'] == id);
    expect(afterFreeze['status'], 'frozen');

    await dio.post<Map<String, dynamic>>('/cards/$id/unfreeze');
    final afterUnfreeze = (await listCards()).firstWhere((c) => c['id'] == id);
    expect(afterUnfreeze['status'], 'active');
  });

  test('the JOD card starts frozen', () async {
    final jod =
        (await listCards()).firstWhere((c) => c['accountId'] == 'acc_jod');
    expect(jod['status'], 'frozen');
  });

  test('valid limits PATCH persists; invalid ones 422', () async {
    final id = (await listCards()).first['id'];

    final ok = await dio.patch<Map<String, dynamic>>(
      '/cards/$id/limits',
      data: {'dailyMinor': 30000, 'monthlyMinor': 900000},
    );
    expect(ok.statusCode, 200);

    final updated = (await listCards()).firstWhere((c) => c['id'] == id);
    expect((updated['limits'] as Map)['dailyMinor'], 30000);
    expect((updated['limits'] as Map)['monthlyMinor'], 900000);

    // daily > monthly.
    await expectLater(
      dio.patch<Map<String, dynamic>>(
        '/cards/$id/limits',
        data: {'dailyMinor': 900000, 'monthlyMinor': 30000},
      ),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          422,
        ),
      ),
    );

    // Non-positive.
    await expectLater(
      dio.patch<Map<String, dynamic>>(
        '/cards/$id/limits',
        data: {'dailyMinor': 0, 'monthlyMinor': 900000},
      ),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          422,
        ),
      ),
    );
  });

  test('an unknown card id is 404', () async {
    await expectLater(
      dio.post<Map<String, dynamic>>('/cards/crd_nope/freeze'),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          404,
        ),
      ),
    );
  });

  test('cards require authentication', () async {
    await store.clear();
    await expectLater(
      dio.get<Map<String, dynamic>>('/cards', options: public()),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          401,
        ),
      ),
    );
  });
}
