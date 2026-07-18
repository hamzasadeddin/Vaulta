import 'dart:math' as math;

import 'package:dio/dio.dart';

/// Serves the Vaulta API from canned JSON so the app runs fully offline.
///
/// Sits **last** in the interceptor chain: requests pass through idempotency,
/// auth, retry and logging first, so the entire real pipeline is exercised —
/// only the socket is fake. Error responses are rejected as
/// [DioExceptionType.badResponse] with `callFollowingErrorInterceptor`, so
/// the auth interceptor handles mock 401s exactly like real ones.
///
/// Demo rules:
/// - login: any well-formed email + password of 8+ chars
/// - OTP code: `123456`
/// - refresh: any token previously issued by this mock
class MockApiInterceptor extends Interceptor {
  MockApiInterceptor({this.latency = const Duration(milliseconds: 350)});

  /// Simulated network delay; pass [Duration.zero] in tests.
  final Duration latency;

  static const otpCode = '123456';

  /// One source of truth for account data — the dashboard summary and every
  /// `/accounts*` route derive from it, so balances never disagree between
  /// screens. IBANs are mod-97 valid so Phase 8's validator accepts them.
  static const _accountFixtures = <_AccountFixture>[
    _AccountFixture(
      id: 'acc_chk',
      name: 'Main Checking',
      type: 'checking',
      iban: 'JO82VBNK0001000000000010204573',
      currency: 'USD',
      balanceMinor: 1248050,
      openedAt: '2022-03-14T00:00:00.000',
      dashboardDeltasMinor: [
        52100, -8620, -1250, 31000, -4370, 425000, -12480,
        -8790, -1599, -21500, -6213, -50000, -475, //
      ],
    ),
    _AccountFixture(
      id: 'acc_sav',
      name: 'Savings',
      type: 'savings',
      iban: 'JO55VBNK0001000000000010204574',
      currency: 'EUR',
      balanceMinor: 893200,
      openedAt: '2023-01-05T00:00:00.000',
      dashboardDeltasMinor: [
        0, 25000, 0, 0, 25000, 0, 0, 25000, 0, 0, 25000, 0, 0, //
      ],
    ),
    _AccountFixture(
      id: 'acc_jod',
      name: 'Amman Account',
      type: 'checking',
      iban: 'JO73VBNK0002000000000010209981',
      currency: 'JOD',
      balanceMinor: 3415750,
      openedAt: '2021-11-20T00:00:00.000',
      dashboardDeltasMinor: [
        -14200, 0, 88000, -9350, 0, -24500, 12000,
        0, -7800, 150000, -5400, 0, -18750, //
      ],
    ),
  ];

  static final _historyPath = RegExp(r'^/accounts/([^/]+)/history$');
  static final _statementsPath = RegExp(r'^/accounts/([^/]+)/statements$');
  static final _statementDetailPath =
      RegExp(r'^/accounts/([^/]+)/statements/([^/]+)$');

  final _challenges = <String, String>{}; // challengeId → email
  var _counter = 0;
  String? _sessionEmail;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future<void>.delayed(latency);
    final response = _route(options);
    if (response == null) {
      // Unmocked route → let it hit the real network.
      return handler.next(options);
    }
    final status = response.statusCode ?? 500;
    if (status >= 400) {
      return handler.reject(
        DioException(
          requestOptions: options,
          response: response,
          type: DioExceptionType.badResponse,
        ),
        true,
      );
    }
    handler.resolve(response, true);
  }

  Response<dynamic>? _route(RequestOptions options) {
    final method = options.method.toUpperCase();
    final path = options.path;
    final exact = switch ('$method $path') {
      'POST /auth/login' => _login(options),
      'POST /auth/otp/verify' => _verifyOtp(options),
      'POST /auth/refresh' => _refresh(options),
      'POST /auth/logout' => _respond(options, 204),
      'GET /auth/me' => _me(options),
      'GET /dashboard/summary' => _dashboardSummary(options),
      'GET /accounts' => _accountsList(options),
      _ => null,
    };
    if (exact != null) return exact;
    if (method != 'GET') return null;

    final history = _historyPath.firstMatch(path);
    if (history != null) return _accountHistory(options, history[1]!);
    final detail = _statementDetailPath.firstMatch(path);
    if (detail != null) {
      return _statementDetail(options, detail[1]!, detail[2]!);
    }
    final statements = _statementsPath.firstMatch(path);
    if (statements != null) return _statements(options, statements[1]!);
    return null;
  }

  Response<dynamic> _login(RequestOptions options) {
    final body = _body(options);
    final email = body['email'] as String? ?? '';
    final password = body['password'] as String? ?? '';
    final emailOk = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(email);
    if (!emailOk || password.length < 8) {
      return _respond(options, 401, {
        'message': 'Invalid email or password',
        'code': 'INVALID_CREDENTIALS',
      });
    }
    final challengeId = 'chl_${++_counter}';
    _challenges[challengeId] = email;
    return _respond(options, 200, {
      'challengeId': challengeId,
      'method': 'otp',
      'expiresInSeconds': 120,
      'maskedDestination': _mask(email),
    });
  }

  Response<dynamic> _verifyOtp(RequestOptions options) {
    final body = _body(options);
    final email = _challenges.remove(body['challengeId']);
    if (email == null) {
      return _respond(options, 401, {
        'message': 'Challenge expired',
        'code': 'CHALLENGE_EXPIRED',
      });
    }
    if (body['code'] != otpCode) {
      _challenges[body['challengeId'] as String] = email; // retry allowed
      return _respond(options, 422, {
        'message': 'Incorrect code',
        'errors': {
          'code': ['Incorrect or expired code'],
        },
      });
    }
    _sessionEmail = email;
    return _respond(options, 200, {
      ..._issueTokens(),
      'user': _user(email),
    });
  }

  Response<dynamic> _refresh(RequestOptions options) {
    final token = _body(options)['refreshToken'] as String? ?? '';
    if (!token.startsWith('mock-refresh-')) {
      return _respond(options, 401, {
        'message': 'Invalid refresh token',
        'code': 'INVALID_REFRESH_TOKEN',
      });
    }
    return _respond(options, 200, _issueTokens());
  }

  Response<dynamic> _me(RequestOptions options) {
    if (!_authenticated(options)) return _unauthenticated(options);
    return _respond(
      options,
      200,
      _user(_sessionEmail ?? 'demo@vaulta.app'),
    );
  }

  Response<dynamic> _dashboardSummary(RequestOptions options) {
    if (!_authenticated(options)) return _unauthenticated(options);
    final now = DateTime.now();
    return _respond(options, 200, {
      'accounts': [
        for (final fixture in _accountFixtures)
          _account(
            id: fixture.id,
            name: fixture.name,
            currency: fixture.currency,
            balanceMinor: fixture.balanceMinor,
            deltasMinor: fixture.dashboardDeltasMinor,
            now: now,
          ),
      ],
      'recentTransactions': [
        _txn(
          id: 'txn_101',
          accountId: 'acc_chk',
          title: 'Blue Fig Caf\u00e9',
          category: 'dining',
          amountMinor: -475,
          currency: 'USD',
          occurredAt: now.subtract(const Duration(hours: 2)),
          status: 'pending',
        ),
        _txn(
          id: 'txn_102',
          accountId: 'acc_chk',
          title: 'Careem',
          category: 'transport',
          amountMinor: -1250,
          currency: 'USD',
          occurredAt: now.subtract(const Duration(hours: 5)),
        ),
        _txn(
          id: 'txn_103',
          accountId: 'acc_chk',
          title: 'Carrefour',
          category: 'groceries',
          amountMinor: -8620,
          currency: 'USD',
          occurredAt: now.subtract(const Duration(days: 1, hours: 3)),
        ),
        _txn(
          id: 'txn_104',
          accountId: 'acc_chk',
          title: 'Salary \u2014 Vaulta Labs',
          category: 'salary',
          amountMinor: 425000,
          currency: 'USD',
          occurredAt: now.subtract(const Duration(days: 1, hours: 9)),
        ),
        _txn(
          id: 'txn_105',
          accountId: 'acc_chk',
          title: 'Netflix',
          category: 'entertainment',
          amountMinor: -1599,
          currency: 'USD',
          occurredAt: now.subtract(const Duration(days: 2, hours: 4)),
        ),
        _txn(
          id: 'txn_106',
          accountId: 'acc_chk',
          title: 'To Savings',
          category: 'transfer',
          amountMinor: -50000,
          currency: 'USD',
          occurredAt: now.subtract(const Duration(days: 3, hours: 1)),
        ),
        _txn(
          id: 'txn_107',
          accountId: 'acc_chk',
          title: 'Amazon',
          category: 'shopping',
          amountMinor: -6213,
          currency: 'USD',
          occurredAt: now.subtract(const Duration(days: 4, hours: 6)),
        ),
        _txn(
          id: 'txn_108',
          accountId: 'acc_jod',
          title: 'Zain',
          category: 'utilities',
          amountMinor: -24500,
          currency: 'JOD',
          occurredAt: now.subtract(const Duration(days: 5, hours: 2)),
        ),
      ],
    });
  }

  Response<dynamic> _accountsList(RequestOptions options) {
    if (!_authenticated(options)) return _unauthenticated(options);
    return _respond(options, 200, {
      'accounts': [
        for (final fixture in _accountFixtures)
          {
            'id': fixture.id,
            'name': fixture.name,
            'type': fixture.type,
            'iban': fixture.iban,
            'currency': fixture.currency,
            'balanceMinor': fixture.balanceMinor,
            'openedAt': fixture.openedAt,
          },
      ],
    });
  }

  Response<dynamic> _accountHistory(RequestOptions options, String accountId) {
    if (!_authenticated(options)) return _unauthenticated(options);
    final fixture = _fixtureById(accountId);
    if (fixture == null) return _notFound(options);
    final days =
        (int.tryParse('${options.queryParameters['days'] ?? ''}') ?? 90)
            .clamp(7, 730);
    return _respond(options, 200, {
      'accountId': fixture.id,
      'currency': fixture.currency,
      'points': _history(
        endBalanceMinor: fixture.balanceMinor,
        deltasMinor: _syntheticDeltas(fixture: fixture, days: days),
        now: DateTime.now(),
      ),
    });
  }

  Response<dynamic> _statements(RequestOptions options, String accountId) {
    if (!_authenticated(options)) return _unauthenticated(options);
    final fixture = _fixtureById(accountId);
    if (fixture == null) return _notFound(options);
    return _respond(options, 200, {
      'statements': [
        for (final statement in _statementsFor(fixture, DateTime.now()))
          ({...statement}..remove('lines')),
      ],
    });
  }

  Response<dynamic> _statementDetail(
    RequestOptions options,
    String accountId,
    String statementId,
  ) {
    if (!_authenticated(options)) return _unauthenticated(options);
    final fixture = _fixtureById(accountId);
    if (fixture == null) return _notFound(options);
    for (final statement in _statementsFor(fixture, DateTime.now())) {
      if (statement['id'] == statementId) {
        return _respond(options, 200, statement);
      }
    }
    return _notFound(options);
  }

  _AccountFixture? _fixtureById(String id) {
    for (final fixture in _accountFixtures) {
      if (fixture.id == id) return fixture;
    }
    return null;
  }

  /// Deterministic pseudo-random daily deltas, seeded per (account, window)
  /// with a content-stable hash so charts don't reshuffle between reloads.
  /// A Postgres backend would compute these points from the transactions
  /// table; the wire shape matches that view (§6.14).
  List<int> _syntheticDeltas({
    required _AccountFixture fixture,
    required int days,
  }) {
    final rng = math.Random(_seed('${fixture.id}:$days'));
    final base = math.max(1000, fixture.balanceMinor.abs() ~/ 70);
    return List<int>.generate(days, (_) {
      final roll = rng.nextInt(100);
      if (roll < 6) return base * (5 + rng.nextInt(6)); // salary / inbound
      if (roll < 26) return 0; // quiet day
      return -(base ~/ 5 + rng.nextInt(base)); // day-to-day spend
    });
  }

  /// Last three full months, walked backwards from (roughly) the current
  /// balance. Each statement is internally consistent — `closing ==
  /// opening + sum(lines)` — and chains into the previous month, exactly
  /// like a ledger-backed view would.
  List<Map<String, dynamic>> _statementsFor(
    _AccountFixture fixture,
    DateTime now,
  ) {
    final rng = math.Random(_seed(fixture.id));
    var closingMinor =
        fixture.balanceMinor - rng.nextInt(fixture.balanceMinor ~/ 25 + 1);
    final statements = <Map<String, dynamic>>[];
    for (var monthsBack = 1; monthsBack <= 3; monthsBack++) {
      final start = DateTime(now.year, now.month - monthsBack);
      final end = DateTime(now.year, now.month - monthsBack + 1, 0);
      final lines = _statementLines(
        rng: rng,
        fixture: fixture,
        start: start,
        end: end,
        index: monthsBack,
      );
      final netMinor =
          lines.fold<int>(0, (sum, line) => sum + (line['amountMinor'] as int));
      final openingMinor = closingMinor - netMinor;
      statements.add({
        'id': 'stm_${fixture.id}_'
            '${start.year}${start.month.toString().padLeft(2, '0')}',
        'accountId': fixture.id,
        'periodStart': start.toIso8601String(),
        'periodEnd': end.toIso8601String(),
        'currency': fixture.currency,
        'openingBalanceMinor': openingMinor,
        'closingBalanceMinor': closingMinor,
        'transactionCount': lines.length,
        'lines': lines,
      });
      closingMinor = openingMinor;
    }
    return statements;
  }

  List<Map<String, dynamic>> _statementLines({
    required math.Random rng,
    required _AccountFixture fixture,
    required DateTime start,
    required DateTime end,
    required int index,
  }) {
    const merchants = [
      'Carrefour',
      'Careem',
      'Blue Fig Caf\u00e9',
      'Orange JO',
      'Talabat',
      'Amazon',
      'C-Town',
      'Netflix',
      'Zain',
      'Pharmacy One',
      'Manara Books',
    ];
    final base = math.max(1000, fixture.balanceMinor.abs() ~/ 70);
    final count = 6 + rng.nextInt(6);
    final lines = <Map<String, dynamic>>[
      for (var i = 0; i < count; i++)
        {
          'id': 'stl_${fixture.id}_${index}_$i',
          'title': merchants[rng.nextInt(merchants.length)],
          'amountMinor': -(base ~/ 5 + rng.nextInt(base * 2)),
          'occurredAt': DateTime(
            start.year,
            start.month,
            1 + rng.nextInt(end.day),
            8 + rng.nextInt(12),
            rng.nextInt(60),
          ).toIso8601String(),
        },
    ];
    if (fixture.type == 'checking') {
      lines.add({
        'id': 'stl_${fixture.id}_${index}_salary',
        'title': 'Salary \u2014 Vaulta Labs',
        'amountMinor': base * 25,
        'occurredAt': DateTime(
          start.year,
          start.month,
          math.min(27, end.day),
          9,
        ).toIso8601String(),
      });
    }
    lines.sort(
      (a, b) =>
          (a['occurredAt'] as String).compareTo(b['occurredAt'] as String),
    );
    return lines;
  }

  /// Content-stable hash: `String.hashCode` isn't guaranteed stable across
  /// runs, and `Object.hash` is per-process seeded — this is neither.
  int _seed(String key) {
    var hash = 17;
    for (final unit in key.codeUnits) {
      hash = (hash * 31 + unit) & 0x3FFFFFFF;
    }
    return hash;
  }

  bool _authenticated(RequestOptions options) {
    final header = options.headers['Authorization'] as String? ?? '';
    return header.startsWith('Bearer mock-access-');
  }

  Response<dynamic> _unauthenticated(RequestOptions options) {
    return _respond(options, 401, {
      'message': 'Session expired',
      'code': 'UNAUTHENTICATED',
    });
  }

  Response<dynamic> _notFound(RequestOptions options) {
    return _respond(options, 404, {
      'message': 'Not found',
      'code': 'NOT_FOUND',
    });
  }

  Map<String, dynamic> _account({
    required String id,
    required String name,
    required String currency,
    required int balanceMinor,
    required List<int> deltasMinor,
    required DateTime now,
  }) {
    return {
      'id': id,
      'name': name,
      'currency': currency,
      'balanceMinor': balanceMinor,
      'history': _history(
        endBalanceMinor: balanceMinor,
        deltasMinor: deltasMinor,
        now: now,
      ),
    };
  }

  /// Builds a daily balance history that ends at [endBalanceMinor] today,
  /// walking backwards through [deltasMinor] (day-over-day changes).
  List<Map<String, dynamic>> _history({
    required int endBalanceMinor,
    required List<int> deltasMinor,
    required DateTime now,
  }) {
    final count = deltasMinor.length + 1;
    final balances = List<int>.filled(count, endBalanceMinor);
    for (var i = count - 2; i >= 0; i--) {
      balances[i] = balances[i + 1] - deltasMinor[i];
    }
    final today = DateTime(now.year, now.month, now.day);
    return [
      for (var i = 0; i < count; i++)
        {
          'date':
              today.subtract(Duration(days: count - 1 - i)).toIso8601String(),
          'balanceMinor': balances[i],
        },
    ];
  }

  Map<String, dynamic> _txn({
    required String id,
    required String accountId,
    required String title,
    required String category,
    required int amountMinor,
    required String currency,
    required DateTime occurredAt,
    String status = 'completed',
  }) {
    return {
      'id': id,
      'accountId': accountId,
      'title': title,
      'category': category,
      'amountMinor': amountMinor,
      'currency': currency,
      'occurredAt': occurredAt.toIso8601String(),
      'status': status,
    };
  }

  Map<String, dynamic> _issueTokens() {
    _counter++;
    return {
      'accessToken': 'mock-access-$_counter',
      'refreshToken': 'mock-refresh-$_counter',
    };
  }

  Map<String, dynamic> _user(String email) => {
        'id': 'usr_001',
        'fullName': 'Dana Khoury',
        'email': email,
        'kycStatus': 'verified',
      };

  Map<String, dynamic> _body(RequestOptions options) {
    final data = options.data;
    return data is Map<String, dynamic> ? data : const {};
  }

  String _mask(String email) {
    final parts = email.split('@');
    if (parts.length != 2 || parts.first.isEmpty) return '***';
    return '${parts.first[0]}***@${parts.last}';
  }

  Response<dynamic> _respond(
    RequestOptions options,
    int status, [
    Object? data,
  ]) {
    return Response<dynamic>(
      requestOptions: options,
      statusCode: status,
      data: data,
    );
  }
}

/// Canonical account row — the mock's stand-in for the `accounts` table.
class _AccountFixture {
  const _AccountFixture({
    required this.id,
    required this.name,
    required this.type,
    required this.iban,
    required this.currency,
    required this.balanceMinor,
    required this.openedAt,
    required this.dashboardDeltasMinor,
  });

  final String id;
  final String name;
  final String type;
  final String iban;
  final String currency;
  final int balanceMinor;
  final String openedAt;

  /// The 14-point sparkline history shown on the dashboard.
  final List<int> dashboardDeltasMinor;
}
