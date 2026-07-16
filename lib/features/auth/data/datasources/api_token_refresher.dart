import 'package:dio/dio.dart';
import 'package:vaulta/core/network/auth_tokens.dart';

/// [AuthTokenRefresher] hitting `POST /auth/refresh` with the bare refresh
/// client (`refreshDioProvider`) — never the main Dio, which would recurse
/// through the auth interceptor that calls this.
class ApiTokenRefresher implements AuthTokenRefresher {
  const ApiTokenRefresher(this._dio);

  final Dio _dio;

  @override
  Future<AuthTokens> refresh(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    final data = response.data!;
    return AuthTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }
}
