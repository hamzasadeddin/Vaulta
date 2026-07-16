import 'package:meta/meta.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/core/usecase/use_case.dart';
import 'package:vaulta/features/auth/domain/entities/otp_challenge.dart';
import 'package:vaulta/features/auth/domain/entities/user.dart';
import 'package:vaulta/features/auth/domain/repositories/auth_repository.dart';

@immutable
class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;
}

class LoginWithPassword implements UseCase<LoginParams, OtpChallenge> {
  const LoginWithPassword(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<OtpChallenge, Failure>> call(LoginParams input) {
    return _repository.login(email: input.email, password: input.password);
  }
}

@immutable
class VerifyOtpParams {
  const VerifyOtpParams({required this.challengeId, required this.code});

  final String challengeId;
  final String code;
}

class VerifyOtp implements UseCase<VerifyOtpParams, User> {
  const VerifyOtp(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<User, Failure>> call(VerifyOtpParams input) {
    return _repository.verifyOtp(
      challengeId: input.challengeId,
      code: input.code,
    );
  }
}

class RestoreSession implements UseCase<NoParams, User> {
  const RestoreSession(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<User, Failure>> call(NoParams input) {
    return _repository.restoreSession();
  }
}

class Logout implements UseCase<NoParams, void> {
  const Logout(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void, Failure>> call(NoParams input) {
    return _repository.logout();
  }
}
