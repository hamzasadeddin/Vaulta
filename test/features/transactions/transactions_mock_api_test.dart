import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:vaulta/core/config/app_config.dart';
import 'package:vaulta/core/network/auth_tokens.dart';
import 'package:vaulta/core/network/dio_client.dart';
import 'package:vaulta/core/network/interceptors/auth_interceptor.dart';
import 'package:vaulta/core/network/mock/mock_api_interceptor.dart';

/// `/transactions*` through the full pipeline — the same harness as the
/// accounts pipeline tests. Pins the Phase 6 contract: keyset pagination
/// with no duplicates or gaps, server-side filters, day-stable determinism,
/// running balances that land on the shared fixture balance, and the
/// dispute entry point.
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

  Future<Map<String, dynamic>> page(Map<String, dynamic> query) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/transactions',
      queryParameters: query,
    );
    return response.data!;
  }

  List<Map<String, dynamic>> items(Map<String, dynamic> body) =>
      (body['transactions'] as List<dynamic>).cast<Map<String, dynamic>>();

  group('GET /transactions', () {
    test('first page is newest-first with the curated recents on top',
        () async {
      final body = await page({});
      final txns = items(body);

      expect(txns, hasLength(25), reason: 'default limit');
      expect(body['nextCursor'], isNotNull);
      expect(txns.first['id'], 'txn_101');
      expect(txns.first['status'], 'pending');
      expect(txns.first['reference'], startsWith('VLT-'));

      for (var i = 1; i < txns.length; i++) {
        final previous = txns[i - 1]['occurredAt'] as String;
        final current = txns[i]['occurredAt'] as String;
        expect(
          previous.compareTo(current) >= 0,
          isTrue,
          reason: 'occurredAt must be non-increasing',
        );
      }
    });

    test('the same request yields identical bytes (day-stable pool)', () async {
      final first = await page({'limit': 40});
      final second = await page({'limit': 40});
      expect(jsonEncode(first), jsonEncode(second));
    });

    test('a cursor walk covers the filtered set exactly once', () async {
      final seen = <String>{};
      String? cursor;
      var pages = 0;
      do {
        final body = await page({
          'accountId': 'acc_sav',
          'limit': 5,
          if (cursor != null) 'cursor': cursor,
        });
        for (final txn in items(body)) {
          expect(txn['accountId'], 'acc_sav');
          expect(
            seen.add(txn['id'] as String),
            isTrue,
            reason: 'no id may appear on two pages',
          );
        }
        cursor = body['nextCursor'] as String?;
        pages++;
        expect(pages, lessThan(50), reason: 'walk must terminate');
      } while (cursor != null);

      final everything =
          items(await page({'accountId': 'acc_sav', 'limit': 100}));
      expect(seen, everything.map((txn) => txn['id']).toSet());
    });

    test('category, status and search filters apply server-side', () async {
      final groceries =
          items(await page({'category': 'groceries', 'limit': 50}));
      expect(groceries, isNotEmpty);
      expect(groceries.every((txn) => txn['category'] == 'groceries'), isTrue);

      final pending = items(await page({'status': 'pending', 'limit': 50}));
      expect(pending.map((txn) => txn['id']), contains('txn_101'));
      expect(pending.every((txn) => txn['status'] == 'pending'), isTrue);

      final search = items(await page({'q': 'netfl', 'limit': 50}));
      expect(search, isNotEmpty);
      expect(
        search.every(
          (txn) => (txn['title'] as String).toLowerCase().contains('netfl'),
        ),
        isTrue,
      );
    });

    test('limit clamps to the 1–100 window', () async {
      expect(items(await page({'limit': 3})), hasLength(3));
      final oversized = items(await page({'limit': 5000}));
      expect(oversized.length, lessThanOrEqualTo(100));
    });

    test('a malformed cursor is rejected as 422', () async {
      expect(
        () => page({'cursor': 'not-base64!!'}),
        throwsA(
          isA<DioException>().having(
            (error) => error.response?.statusCode,
            'statusCode',
            422,
          ),
        ),
      );
    });

    test('running balances chain onto the shared fixture balance', () async {
      final txns = items(await page({'accountId': 'acc_chk', 'limit': 60}));

      final settled =
          txns.where((txn) => txn['status'] == 'completed').toList();
      expect(
        settled.first['balanceAfterMinor'],
        1248050,
        reason: 'newest settled entry lands on the fixture balance',
      );
      for (var i = 1; i < settled.length; i++) {
        final newer = settled[i - 1];
        final older = settled[i];
        expect(
          older['balanceAfterMinor'],
          (newer['balanceAfterMinor'] as int) - (newer['amountMinor'] as int),
          reason: 'balance rewinds by the newer entry\u2019s amount',
        );
      }

      final unsettled = txns.where((txn) => txn['status'] != 'completed');
      for (final txn in unsettled) {
        expect(txn.containsKey('balanceAfterMinor'), isFalse);
      }
    });

    test('the dashboard recents are the head of the same pool', () async {
      final summary =
          (await dio.get<Map<String, dynamic>>('/dashboard/summary')).data!;
      final recents = (summary['recentTransactions'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final feed = items(await page({'limit': 50}));

      for (final recent in recents) {
        final matches = feed.where((txn) => txn['id'] == recent['id']).toList();
        expect(
          matches,
          hasLength(1),
          reason: '${recent['id']} must appear in the feed exactly once',
        );
        expect(matches.single['amountMinor'], recent['amountMinor']);
        expect(matches.single['occurredAt'], recent['occurredAt']);
      }
    });
  });

  group('GET /transactions/:id', () {
    test('returns the same record the list serves', () async {
      final listed = items(await page({'limit': 1})).single;
      final detail = (await dio.get<Map<String, dynamic>>(
        '/transactions/${listed['id']}',
      ))
          .data!;
      expect(detail, listed);
    });

    test('unknown ids are 404', () async {
      expect(
        () => dio.get<Map<String, dynamic>>('/transactions/txn_nope'),
        throwsA(
          isA<DioException>().having(
            (error) => error.response?.statusCode,
            'statusCode',
            404,
          ),
        ),
      );
    });
  });

  group('POST /transactions/:id/dispute', () {
    test('a valid dispute is acknowledged with a reference', () async {
      final response = await dio.post<Map<String, dynamic>>(
        '/transactions/txn_101/dispute',
        data: {'reason': 'unauthorized'},
      );
      expect(response.statusCode, 202);
      expect(response.data!['disputeId'], startsWith('dsp_'));
      expect(response.data!['transactionId'], 'txn_101');
    });

    test('an invalid reason is 422 with field errors', () async {
      expect(
        () => dio.post<Map<String, dynamic>>(
          '/transactions/txn_101/dispute',
          data: {'reason': 'vibes'},
        ),
        throwsA(
          isA<DioException>().having(
            (error) => error.response?.statusCode,
            'statusCode',
            422,
          ),
        ),
      );
    });

    test('disputing an unknown transaction is 404', () async {
      expect(
        () => dio.post<Map<String, dynamic>>(
          '/transactions/txn_nope/dispute',
          data: {'reason': 'duplicate'},
        ),
        throwsA(
          isA<DioException>().having(
            (error) => error.response?.statusCode,
            'statusCode',
            404,
          ),
        ),
      );
    });
  });
}
