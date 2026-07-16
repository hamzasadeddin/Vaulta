import 'package:dio/dio.dart';
import 'package:vaulta/core/network/interceptors/auth_interceptor.dart';
import 'package:vaulta/features/auth/data/models/auth_dtos.dart';

/// Raw API access. Throws [DioException]; the repository maps to failures.
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  /// Public endpoints must not carry (or refresh) a bearer token.
  static final _public = Options(
    extra: const {AuthInterceptor.skipAuthKey: true},
  );

  Future<OtpChallengeDto> login(LoginRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: request.toJson(),
      options: _public,
    );
    return OtpChallengeDto.fromJson(response.data!);
  }

  Future<AuthResponseDto> verifyOtp(VerifyOtpRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/otp/verify',
      data: request.toJson(),
      options: _public,
    );
    return AuthResponseDto.fromJson(response.data!);
  }

  Future<UserDto> me() async {
    final response = await _dio.get<Map<String, dynamic>>('/auth/me');
    return UserDto.fromJson(response.data!);
  }

  Future<void> logout() => _dio.post<void>('/auth/logout');
}
