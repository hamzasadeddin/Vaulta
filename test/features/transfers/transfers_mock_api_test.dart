import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:vaulta/core/config/app_config.dart';
import 'package:vaulta/core/iban/iban.dart';
import 'package:vaulta/core/network/auth_tokens.dart';
import 'package:vaulta/core/network/dio_client.dart';
import 'package:vaulta/core/network/interceptors/auth_interceptor.dart';
import 'package:vaulta/core/network/interceptors/idempotency_interceptor.dart';
import 'package:vaulta/core/network/mock/mock_api_interceptor.dart';

/// `/beneficiaries` and `/transfers*` through the full pipeline — the
/// cards/accounts harness. Pins the Phase 8 contract: server-side
/// idempotency, exact integer FX, balance movement that stays consistent
/// across every other route, and the validation gates.
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

  Future<Map<String, int>> balances() async {
    final response = await dio.get<Map<String, dynamic>>('/accounts');
    final accounts =
        (response.data!['accounts'] as List).cast<Map<String, dynamic>>();
    return {
      for (final account in accounts)
        account['id'] as String: account['balanceMinor'] as int,
    };
  }

  Future<Response<Map<String, dynamic>>> createTransfer({
    String source = 'acc_chk',
    Map<String, dynamic> destination = const {
      'type': 'beneficiary',
      'beneficiaryId': 'ben_sara',
    },
    int amountMinor = 25000,
    String? scheduledFor,
  }) {
    return dio.post<Map<String, dynamic>>(
      '/transfers',
      data: {
        'sourceAccountId': source,
        'amountMinor': amountMinor,
        'destination': destination,
        if (scheduledFor != null) 'scheduledFor': scheduledFor,
      },
    );
  }

  Future<Response<Map<String, dynamic>>> confirm(
    String transferId,
    String key,
  ) {
    return dio.post<Map<String, dynamic>>(
      '/transfers/$transferId/confirm',
      options: Options(headers: {IdempotencyInterceptor.header: key}),
    );
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

  group('GET /beneficiaries', () {
    test('serves payees whose IBANs all pass mod-97', () async {
      final response = await dio.get<Map<String, dynamic>>('/beneficiaries');
      final payees = (response.data!['beneficiaries'] as List)
          .cast<Map<String, dynamic>>();

      expect(payees.length, 4);
      for (final payee in payees) {
        expect(
          Iban.isValid(payee['iban'] as String),
          isTrue,
          reason: '${payee['id']}',
        );
      }
      // Mixed currencies so the FX corridor is reachable from USD.
      expect(
        payees.map((p) => p['currency']).toSet(),
        {'JOD', 'USD', 'EUR'},
      );
    });

    test('requires authentication', () async {
      await store.clear();
      await expectLater(
        dio.get<Map<String, dynamic>>('/beneficiaries'),
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

  group('POST /transfers', () {
    test('prices a same-currency transfer with no fee and no rate', () async {
      final response = await createTransfer();
      final quote = response.data!;

      expect(response.statusCode, 201);
      expect(quote['currency'], 'USD');
      expect(quote['destinationCurrency'], 'USD');
      expect(quote['feeMinor'], 0);
      expect(quote['rate'], isNull);
      expect(quote['amountMinor'], 25000);
      expect(quote['totalDebitMinor'], 25000);
      expect(quote['destinationAmountMinor'], 25000);
      expect(quote['idempotencyKey'], isA<String>());
      expect(quote['destinationLabel'], 'Sara Malik');
    });

    test('converts cross-currency amounts exactly, in integers', () async {
      // $250.00 → EUR at 0.920 = €230.00, plus a 0.5% fee of $1.25.
      final quote = (await createTransfer(
        destination: const {'type': 'own', 'accountId': 'acc_sav'},
      ))
          .data!;

      expect(quote['destinationCurrency'], 'EUR');
      expect(quote['rate'], '0.920');
      expect(quote['destinationAmountMinor'], 23000);
      expect(quote['feeMinor'], 125);
      expect(quote['totalDebitMinor'], 25125);
    });

    test('honours the JOD 3-minor-digit canary', () async {
      // $250.00 → JOD at 0.709 = 177.250 JOD, i.e. 177250 minor units.
      final quote = (await createTransfer(
        destination: const {'type': 'own', 'accountId': 'acc_jod'},
      ))
          .data!;

      expect(quote['destinationCurrency'], 'JOD');
      expect(quote['destinationAmountMinor'], 177250);
    });

    test('accepts a valid raw IBAN', () async {
      final quote = (await createTransfer(
        destination: const {
          'type': 'iban',
          'iban': 'JO71HBHO0020000000000012009902',
          'holderName': 'Omar Nasser',
        },
      ))
          .data!;

      expect(quote['destinationLabel'], 'Omar Nasser');
      expect(quote['destinationDetail'], contains('9902'));
      // A raw-IBAN payee settles in the sender's currency.
      expect(quote['destinationCurrency'], 'USD');
    });

    test('rejects an IBAN that fails mod-97 with a field error', () async {
      await expectLater(
        createTransfer(
          destination: const {
            'type': 'iban',
            'iban': 'JO83VBNK0001000000000010204573',
            'holderName': 'Omar Nasser',
          },
        ),
        throwsA(
          isA<DioException>()
              .having((e) => e.response?.statusCode, 'status', 422)
              .having(
                (e) => (e.response?.data as Map)['errors'],
                'errors',
                contains('iban'),
              ),
        ),
      );
    });

    test('rejects an amount larger than the balance', () async {
      await expectLater(
        createTransfer(amountMinor: 999999999),
        throwsA(
          isA<DioException>()
              .having((e) => e.response?.statusCode, 'status', 422)
              .having(
                (e) => (e.response?.data as Map)['errors'],
                'errors',
                contains('amountMinor'),
              ),
        ),
      );
    });

    test('rejects a non-positive amount', () async {
      await expectLater(
        createTransfer(amountMinor: 0),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            422,
          ),
        ),
      );
    });

    test('rejects sending an account to itself', () async {
      await expectLater(
        createTransfer(
          destination: const {'type': 'own', 'accountId': 'acc_chk'},
        ),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            422,
          ),
        ),
      );
    });

    test('rejects a schedule date in the past', () async {
      await expectLater(
        createTransfer(scheduledFor: '2020-01-01T00:00:00.000'),
        throwsA(
          isA<DioException>()
              .having((e) => e.response?.statusCode, 'status', 422)
              .having(
                (e) => (e.response?.data as Map)['errors'],
                'errors',
                contains('scheduledFor'),
              ),
        ),
      );
    });

    test('creating a draft moves no money', () async {
      final before = await balances();
      await createTransfer();
      expect(await balances(), before);
    });
  });

  group('POST /transfers/:id/confirm', () {
    test('debits the source and credits an own-account destination', () async {
      final before = await balances();
      final quote = (await createTransfer(
        destination: const {'type': 'own', 'accountId': 'acc_sav'},
      ))
          .data!;

      final response = await confirm(
        quote['id'] as String,
        quote['idempotencyKey'] as String,
      );
      final transfer = response.data!;

      expect(transfer['status'], 'completed');
      expect(transfer['reference'], startsWith('VLT-'));

      final after = await balances();
      expect(after['acc_chk'], before['acc_chk']! - 25125);
      expect(after['acc_sav'], before['acc_sav']! + 23000);
      // The receipt's balance agrees with what /accounts now reports.
      expect(transfer['balanceAfterMinor'], after['acc_chk']);
    });

    test(
        'replaying the same idempotency key returns the same transfer and '
        'never spends twice', () async {
      final before = await balances();
      final quote = (await createTransfer()).data!;
      final id = quote['id'] as String;
      final key = quote['idempotencyKey'] as String;

      final first = await confirm(id, key);
      final afterFirst = await balances();

      // The retry a timeout would trigger: identical request, identical
      // key. The server must answer from its idempotency ledger.
      final second = await confirm(id, key);
      final afterSecond = await balances();

      expect(second.data, first.data);
      expect(afterSecond, afterFirst);
      expect(afterFirst['acc_chk'], before['acc_chk']! - 25000);
    });

    test('a draft cannot be confirmed twice even without the header', () async {
      final quote = (await createTransfer()).data!;
      final id = quote['id'] as String;
      await confirm(id, quote['idempotencyKey'] as String);

      // A fresh key against a consumed draft: the draft is single-use, so
      // this is a 404 rather than a second debit.
      await expectLater(
        confirm(id, 'some-other-key'),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            404,
          ),
        ),
      );
    });

    test('an unknown draft is a 404', () async {
      await expectLater(
        confirm('trf_missing', 'key'),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            404,
          ),
        ),
      );
    });

    test('a scheduled transfer moves no money yet', () async {
      final before = await balances();
      final future = DateTime.now().add(const Duration(days: 7));
      final quote = (await createTransfer(
        scheduledFor: future.toIso8601String(),
      ))
          .data!;

      final transfer = (await confirm(
        quote['id'] as String,
        quote['idempotencyKey'] as String,
      ))
          .data!;

      expect(transfer['status'], 'scheduled');
      expect(transfer['balanceAfterMinor'], isNull);
      expect(await balances(), before);
    });

    test('a settled transfer shows up in the transactions feed', () async {
      final quote = (await createTransfer()).data!;
      await confirm(
        quote['id'] as String,
        quote['idempotencyKey'] as String,
      );

      final feed = await dio.get<Map<String, dynamic>>(
        '/transactions',
        queryParameters: {'accountId': 'acc_chk', 'limit': 50},
      );
      final rows =
          (feed.data!['transactions'] as List).cast<Map<String, dynamic>>();
      final posted = rows.where((row) => row['title'] == 'To Sara Malik');

      expect(posted, hasLength(1));
      expect(posted.single['amountMinor'], -25000);
      expect(posted.single['category'], 'transfer');
    });

    test('the dashboard summary agrees with the new balance', () async {
      final quote = (await createTransfer()).data!;
      await confirm(
        quote['id'] as String,
        quote['idempotencyKey'] as String,
      );

      final summary = await dio.get<Map<String, dynamic>>('/dashboard/summary');
      final accounts =
          (summary.data!['accounts'] as List).cast<Map<String, dynamic>>();
      final checking =
          accounts.firstWhere((account) => account['id'] == 'acc_chk');

      expect(checking['balanceMinor'], (await balances())['acc_chk']);
    });

    test('requires authentication', () async {
      final quote = (await createTransfer()).data!;
      await store.clear();

      await expectLater(
        confirm(
          quote['id'] as String,
          quote['idempotencyKey'] as String,
        ),
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

  group('FX quote lock', () {
    // A private harness: these tests need to move the server's clock, so
    // they build their own Dio around a clock-injected mock rather than
    // reusing the suite-level one.
    late DateTime now;
    late Dio locked;

    Future<Response<Map<String, dynamic>>> quoteFx({
      String source = 'acc_chk',
      String beneficiary = 'ben_layla', // JOD — forces the USD→JOD corridor
      int amountMinor = 25000,
    }) {
      return locked.post<Map<String, dynamic>>(
        '/transfers',
        data: {
          'sourceAccountId': source,
          'amountMinor': amountMinor,
          'destination': {'type': 'beneficiary', 'beneficiaryId': beneficiary},
        },
      );
    }

    Future<Response<Map<String, dynamic>>> confirmOn(String id, String key) {
      return locked.post<Map<String, dynamic>>(
        '/transfers/$id/confirm',
        options: Options(headers: {IdempotencyInterceptor.header: key}),
      );
    }

    /// Reads balances from *this* group's server. The suite-level
    /// `balances()` talks to a different MockApiInterceptor instance with
    /// its own ledger, so using it here would assert against a server
    /// that was never asked to move anything.
    Future<Map<String, int>> held() async {
      final response = await locked.get<Map<String, dynamic>>('/accounts');
      final accounts =
          (response.data!['accounts'] as List).cast<Map<String, dynamic>>();
      return {
        for (final account in accounts)
          account['id'] as String: account['balanceMinor'] as int,
      };
    }

    setUp(() async {
      now = DateTime(2026, 7, 22, 10);
      final tokens = InMemoryAuthTokenStore();
      locked = buildDio(
        config: config,
        talker: Talker(),
        tokenStore: tokens,
        mockApi: MockApiInterceptor(
          latency: Duration.zero,
          clock: () => now,
        ),
      );
      final login = await locked.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': 'sam@example.com', 'password': 'hunter2hunter2'},
        options: public(),
      );
      final verify = await locked.post<Map<String, dynamic>>(
        '/auth/otp/verify',
        data: {
          'challengeId': login.data!['challengeId'],
          'code': MockApiInterceptor.otpCode,
        },
        options: public(),
      );
      await tokens.write(
        AuthTokens(
          accessToken: verify.data!['accessToken'] as String,
          refreshToken: verify.data!['refreshToken'] as String,
        ),
      );
    });

    test('a cross-currency quote is held for a bounded window', () async {
      final quote = (await quoteFx()).data!;

      expect(quote['rate'], isNotNull);
      expect(
        quote['expiresInSeconds'],
        MockApiInterceptor.fxQuoteTtl.inSeconds,
      );
      expect(
        DateTime.parse(quote['expiresAt'] as String),
        now.add(MockApiInterceptor.fxQuoteTtl),
      );
    });

    test('a same-currency quote holds nothing', () async {
      // ben_sara is USD, so this never touches the corridor.
      final quote = (await quoteFx(beneficiary: 'ben_sara')).data!;

      expect(quote['rate'], isNull);
      expect(quote['expiresAt'], isNull);
      expect(quote['expiresInSeconds'], isNull);
    });

    test('confirming past the window is refused and moves no money', () async {
      final quote = (await quoteFx()).data!;
      final before = await held();

      now = now.add(MockApiInterceptor.fxQuoteTtl + const Duration(seconds: 1));

      await expectLater(
        confirmOn(quote['id'] as String, quote['idempotencyKey'] as String),
        throwsA(
          isA<DioException>()
              .having((e) => e.response?.statusCode, 'status', 409)
              .having(
                (e) => (e.response?.data as Map)['code'],
                'code',
                'QUOTE_EXPIRED',
              ),
        ),
      );
      expect(await held(), before);
    });

    test('the last second of the window is still confirmable', () async {
      final quote = (await quoteFx()).data!;

      now = now.add(MockApiInterceptor.fxQuoteTtl - const Duration(seconds: 1));
      final response = await confirmOn(
        quote['id'] as String,
        quote['idempotencyKey'] as String,
      );

      expect(response.statusCode, 201);
      expect(response.data!['status'], 'completed');
    });

    test('an expired draft is burned, not left lying around', () async {
      final quote = (await quoteFx()).data!;
      now = now.add(MockApiInterceptor.fxQuoteTtl);

      await expectLater(
        confirmOn(quote['id'] as String, quote['idempotencyKey'] as String),
        throwsA(isA<DioException>()),
      );
      // Second attempt: the draft is gone entirely, so this is a 404 and
      // not a second 409 against a draft the server is still holding.
      await expectLater(
        confirmOn(quote['id'] as String, quote['idempotencyKey'] as String),
        throwsA(
          isA<DioException>()
              .having((e) => e.response?.statusCode, 'status', 404),
        ),
      );
    });

    test('a settled transfer still replays long after its quote died',
        () async {
      final quote = (await quoteFx()).data!;
      final key = quote['idempotencyKey'] as String;
      final first = await confirmOn(quote['id'] as String, key);
      final after = await held();

      // Expiry may refuse work that has not happened. It may never
      // retract work that has — this is the ordering the confirm handler
      // encodes, and the reason the idempotency check runs first.
      now = now.add(const Duration(days: 1));
      final replay = await confirmOn(quote['id'] as String, key);

      expect(replay.data!['id'], first.data!['id']);
      expect(replay.data!['reference'], first.data!['reference']);
      expect(await held(), after);
    });

    test('a settled transfer carries no lock of its own', () async {
      final quote = (await quoteFx()).data!;
      final transfer = await confirmOn(
        quote['id'] as String,
        quote['idempotencyKey'] as String,
      );

      expect(transfer.data!['expiresAt'], isNull);
      expect(transfer.data!['expiresInSeconds'], isNull);
    });

    test('re-quoting issues a new draft and a new idempotency key', () async {
      final first = (await quoteFx()).data!;
      now = now.add(MockApiInterceptor.fxQuoteTtl);
      final second = (await quoteFx()).data!;

      expect(second['id'], isNot(first['id']));
      expect(second['idempotencyKey'], isNot(first['idempotencyKey']));
      // Same corridor, same amount — the price itself is unchanged, only
      // the window it is held for.
      expect(second['destinationAmountMinor'], first['destinationAmountMinor']);
      expect(
        DateTime.parse(second['expiresAt'] as String),
        now.add(MockApiInterceptor.fxQuoteTtl),
      );
    });
  });
}
