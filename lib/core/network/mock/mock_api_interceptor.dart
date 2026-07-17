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
    return switch ('${options.method.toUpperCase()} ${options.path}') {
      'POST /auth/login' => _login(options),
      'POST /auth/otp/verify' => _verifyOtp(options),
      'POST /auth/refresh' => _refresh(options),
      'POST /auth/logout' => _respond(options, 204),
      'GET /auth/me' => _me(options),
      'GET /dashboard/summary' => _dashboardSummary(options),
      _ => null,
    };
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
        _account(
          id: 'acc_chk',
          name: 'Main Checking',
          currency: 'USD',
          balanceMinor: 1248050,
          deltasMinor: const [
            52100, -8620, -1250, 31000, -4370, 425000, -12480,
            -8790, -1599, -21500, -6213, -50000, -475, //
          ],
          now: now,
        ),
        _account(
          id: 'acc_sav',
          name: 'Savings',
          currency: 'EUR',
          balanceMinor: 893200,
          deltasMinor: const [
            0, 25000, 0, 0, 25000, 0, 0, 25000, 0, 0, 25000, 0, 0, //
          ],
          now: now,
        ),
        _account(
          id: 'acc_jod',
          name: 'Amman Account',
          currency: 'JOD',
          balanceMinor: 3415750,
          deltasMinor: const [
            -14200, 0, 88000, -9350, 0, -24500, 12000,
            0, -7800, 150000, -5400, 0, -18750, //
          ],
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
