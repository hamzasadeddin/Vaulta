import 'package:meta/meta.dart';
import 'package:vaulta/features/auth/domain/entities/otp_challenge.dart';
import 'package:vaulta/features/auth/domain/entities/user.dart';

/// Session state machine. The router redirect switches over this
/// exhaustively — adding a state without handling it is a compile error.
///
///     Unknown ──restore ok──▶ Locked ──biometric──▶ Authenticated
///        │ restore fail                                │  ▲
///        ▼                                     app bg  ▼  │ unlock
///     Unauthenticated ──login──▶ OtpPending ──verify──▶ Authenticated
sealed class AuthState {
  const AuthState();
}

/// Session restore in flight; splash is showing.
final class AuthUnknown extends AuthState {
  const AuthUnknown();
}

final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Password accepted; waiting for the second factor.
final class OtpPending extends AuthState {
  const OtpPending({required this.challenge, required this.email});

  final OtpChallenge challenge;
  final String email;
}

final class Authenticated extends AuthState {
  const Authenticated(this.user);

  final User user;
}

/// Valid session exists but the app was backgrounded or cold-started;
/// biometric unlock required before anything is shown.
final class Locked extends AuthState {
  const Locked(this.user);

  final User user;
}

extension AuthStateX on AuthState {
  bool get hasSession => switch (this) {
        Authenticated() || Locked() => true,
        _ => false,
      };

  @visibleForTesting
  User? get userOrNull => switch (this) {
        Authenticated(:final user) => user,
        Locked(:final user) => user,
        _ => null,
      };
}
