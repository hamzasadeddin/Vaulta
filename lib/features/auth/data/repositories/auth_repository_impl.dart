import 'package:vaulta/core/error/exception_mapper.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/network/auth_tokens.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vaulta/features/auth/data/models/auth_dtos.dart';
import 'package:vaulta/features/auth/domain/entities/otp_challenge.dart';
import 'package:vaulta/features/auth/domain/entities/user.dart';
import 'package:vaulta/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthTokenStore tokenStore,
  })  : _remote = remote,
        _tokenStore = tokenStore;

  final AuthRemoteDataSource _remote;
  final AuthTokenStore _tokenStore;

  @override
  Future<Result<OtpChallenge, Failure>> login({
    required String email,
    required String password,
  }) {
    return runCatching(() async {
      final challenge = await _remote.login(
        LoginRequestDto(email: email, password: password),
      );
      return challenge.toDomain();
    });
  }

  @override
  Future<Result<User, Failure>> verifyOtp({
    required String challengeId,
    required String code,
  }) {
    return runCatching(() async {
      final response = await _remote.verifyOtp(
        VerifyOtpRequestDto(challengeId: challengeId, code: code),
      );
      // Persisting the session is part of this operation's contract:
      // a User is only returned once the tokens are durably stored.
      await _tokenStore.write(response.toTokens());
      return response.user.toDomain();
    });
  }

  @override
  Future<Result<User, Failure>> restoreSession() async {
    // "No session" is an expected outcome, not an exception — return the
    // failure rather than throwing one across the layer boundary.
    final stored = await runCatching(_tokenStore.read);
    switch (stored) {
      case Failed(:final failure):
        return Result.failure(failure);
      case Success(:final value):
        if (value == null) {
          return const Result.failure(
            AuthFailure(message: 'No stored session'),
          );
        }
        // A 401 here flows through the auth interceptor (refresh attempt);
        // if that fails the store is already cleared by the interceptor.
        return runCatching(() async => (await _remote.me()).toDomain());
    }
  }

  @override
  Future<Result<void, Failure>> logout() {
    return runCatching(() async {
      // Local session death must not depend on the network.
      await _tokenStore.clear();
      try {
        await _remote.logout();
      } on Object {
        // Best effort — server-side revocation failure is not the user's
        // problem; the refresh token is gone locally either way.
      }
    });
  }
}
