import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/network/auth_tokens.dart';
import 'package:vaulta/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vaulta/features/auth/data/models/auth_dtos.dart';
import 'package:vaulta/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:vaulta/features/auth/domain/entities/user.dart';
import 'package:vaulta/features/auth/presentation/forms/auth_inputs.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

const _userDto = UserDto(
  id: 'usr_1',
  fullName: 'Dana Khoury',
  email: 'dana@example.com',
  kycStatus: 'verified',
);

void main() {
  setUpAll(() {
    registerFallbackValue(
      const LoginRequestDto(email: '', password: ''),
    );
    registerFallbackValue(
      const VerifyOtpRequestDto(challengeId: '', code: ''),
    );
  });

  late _MockRemote remote;
  late InMemoryAuthTokenStore store;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    store = InMemoryAuthTokenStore();
    repository = AuthRepositoryImpl(remote: remote, tokenStore: store);
  });

  group('AuthRepositoryImpl', () {
    test('login maps DTO to domain entity', () async {
      when(() => remote.login(any())).thenAnswer(
        (_) async => const OtpChallengeDto(
          challengeId: 'chl_9',
          expiresInSeconds: 120,
          maskedDestination: 'd***@example.com',
        ),
      );

      final result = await repository.login(
        email: 'dana@example.com',
        password: 'hunter2hunter2',
      );

      final challenge = result.valueOrNull;
      expect(challenge?.id, 'chl_9');
      expect(challenge?.expiresIn, const Duration(minutes: 2));
    });

    test('verifyOtp persists tokens before returning the user', () async {
      when(() => remote.verifyOtp(any())).thenAnswer(
        (_) async => const AuthResponseDto(
          accessToken: 'mock-access-1',
          refreshToken: 'mock-refresh-1',
          user: _userDto,
        ),
      );

      final result =
          await repository.verifyOtp(challengeId: 'chl_9', code: '123456');

      expect(result.valueOrNull?.kycStatus, KycStatus.verified);
      expect(
        await store.read(),
        const AuthTokens(
          accessToken: 'mock-access-1',
          refreshToken: 'mock-refresh-1',
        ),
      );
    });

    test('restoreSession fails without stored tokens and skips the network',
        () async {
      final result = await repository.restoreSession();

      expect(result.failureOrNull, isA<AuthFailure>());
      verifyNever(remote.me);
    });

    test('restoreSession returns the user when tokens exist', () async {
      await store.write(
        const AuthTokens(accessToken: 'a', refreshToken: 'r'),
      );
      when(remote.me).thenAnswer((_) async => _userDto);

      final result = await repository.restoreSession();

      expect(result.valueOrNull?.email, 'dana@example.com');
    });

    test('logout clears tokens even when the server call fails', () async {
      await store.write(
        const AuthTokens(accessToken: 'a', refreshToken: 'r'),
      );
      when(remote.logout).thenThrow(Exception('network down'));

      final result = await repository.logout();

      expect(result.isSuccess, isTrue);
      expect(await store.read(), isNull);
    });
  });

  group('formz inputs', () {
    test('EmailInput validates shape', () {
      expect(const EmailInput.dirty().error, EmailValidationError.empty);
      expect(
        const EmailInput.dirty('not-an-email').error,
        EmailValidationError.invalid,
      );
      expect(const EmailInput.dirty('a@b.co').isValid, isTrue);
      expect(const EmailInput.dirty(' a@b.co ').isValid, isTrue);
    });

    test('PasswordInput enforces minimum length', () {
      expect(
        const PasswordInput.dirty().error,
        PasswordValidationError.empty,
      );
      expect(
        const PasswordInput.dirty('short').error,
        PasswordValidationError.tooShort,
      );
      expect(const PasswordInput.dirty('longenough').isValid, isTrue);
    });

    test('OtpCodeInput requires exactly six digits', () {
      expect(const OtpCodeInput.dirty('12345').isValid, isFalse);
      expect(const OtpCodeInput.dirty('12345a').isValid, isFalse);
      expect(const OtpCodeInput.dirty('123456').isValid, isTrue);
    });
  });
}
