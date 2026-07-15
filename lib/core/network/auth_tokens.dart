import 'package:meta/meta.dart';

/// Access/refresh token pair.
@immutable
class AuthTokens {
  const AuthTokens({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthTokens &&
          other.accessToken == accessToken &&
          other.refreshToken == refreshToken;

  @override
  int get hashCode => Object.hash(accessToken, refreshToken);

  @override
  String toString() => 'AuthTokens(<redacted>)';
}

/// Where tokens live. Phase 3 provides the `flutter_secure_storage`-backed
/// implementation; the in-memory one below serves tests and the mock API.
abstract interface class AuthTokenStore {
  Future<AuthTokens?> read();

  Future<void> write(AuthTokens tokens);

  Future<void> clear();
}

/// Exchanges a refresh token for a fresh pair. Throws on failure —
/// the auth interceptor is the only caller and handles it.
///
/// Deliberately an interface rather than a typedef: Phase 3 implements it
/// with a class that owns its Dio, and tests mock it with mocktail.
// ignore: one_member_abstracts
abstract interface class AuthTokenRefresher {
  Future<AuthTokens> refresh(String refreshToken);
}

class InMemoryAuthTokenStore implements AuthTokenStore {
  AuthTokens? _tokens;

  @override
  Future<AuthTokens?> read() async => _tokens;

  @override
  Future<void> write(AuthTokens tokens) async => _tokens = tokens;

  @override
  Future<void> clear() async => _tokens = null;
}
