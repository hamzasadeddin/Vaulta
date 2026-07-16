import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vaulta/core/network/auth_tokens.dart';
import 'package:vaulta/features/auth/domain/entities/otp_challenge.dart';
import 'package:vaulta/features/auth/domain/entities/user.dart';

part 'auth_dtos.freezed.dart';
part 'auth_dtos.g.dart';

/// DTOs mirror the wire format exactly; `toDomain()` is the only place the
/// API shape touches domain types. All auth DTOs live in one file — they
/// change together with the API contract.

@freezed
abstract class LoginRequestDto with _$LoginRequestDto {
  const factory LoginRequestDto({
    required String email,
    required String password,
  }) = _LoginRequestDto;

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDtoFromJson(json);
}

@freezed
abstract class VerifyOtpRequestDto with _$VerifyOtpRequestDto {
  const factory VerifyOtpRequestDto({
    required String challengeId,
    required String code,
  }) = _VerifyOtpRequestDto;

  factory VerifyOtpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestDtoFromJson(json);
}

@freezed
abstract class OtpChallengeDto with _$OtpChallengeDto {
  const factory OtpChallengeDto({
    required String challengeId,
    required int expiresInSeconds,
    @Default('otp') String method,
    @Default('***') String maskedDestination,
  }) = _OtpChallengeDto;

  const OtpChallengeDto._();

  factory OtpChallengeDto.fromJson(Map<String, dynamic> json) =>
      _$OtpChallengeDtoFromJson(json);

  OtpChallenge toDomain() => OtpChallenge(
        id: challengeId,
        maskedDestination: maskedDestination,
        expiresIn: Duration(seconds: expiresInSeconds),
      );
}

@freezed
abstract class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String fullName,
    required String email,
    @Default('pending') String kycStatus,
  }) = _UserDto;

  const UserDto._();

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  User toDomain() => User(
        id: id,
        fullName: fullName,
        email: email,
        kycStatus: switch (kycStatus) {
          'verified' => KycStatus.verified,
          'rejected' => KycStatus.rejected,
          _ => KycStatus.pending,
        },
      );
}

@freezed
abstract class AuthResponseDto with _$AuthResponseDto {
  const factory AuthResponseDto({
    required String accessToken,
    required String refreshToken,
    required UserDto user,
  }) = _AuthResponseDto;

  const AuthResponseDto._();

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);

  AuthTokens toTokens() =>
      AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
}
