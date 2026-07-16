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
    final header = options.headers['Authorization'] as String? ?? '';
    if (!header.startsWith('Bearer mock-access-')) {
      return _respond(options, 401, {
        'message': 'Session expired',
        'code': 'UNAUTHENTICATED',
      });
    }
    return _respond(
      options,
      200,
      _user(_sessionEmail ?? 'demo@vaulta.app'),
    );
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
