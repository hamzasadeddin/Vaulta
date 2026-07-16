import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/auth/domain/entities/otp_challenge.dart';
import 'package:vaulta/features/auth/domain/entities/user.dart';

/// Domain contract. Implemented in the data layer; consumed by use cases.
abstract interface class AuthRepository {
  /// Exchanges credentials for a second-factor challenge.
  Future<Result<OtpChallenge, Failure>> login({
    required String email,
    required String password,
  });

  /// Completes the challenge; persists the session on success.
  Future<Result<User, Failure>> verifyOtp({
    required String challengeId,
    required String code,
  });

  /// Restores a previously persisted session, if any.
  Future<Result<User, Failure>> restoreSession();

  /// Clears the local session; best-effort server notification.
  Future<Result<void, Failure>> logout();
}
