import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/network/auth_tokens.dart';

void main() {
  group('Failure', () {
    test('toString names the concrete type and message', () {
      expect(
        const NetworkFailure().toString(),
        'NetworkFailure(Unable to reach the server)',
      );
      expect(
        const CacheFailure(message: 'disk full').toString(),
        'CacheFailure(disk full)',
      );
    });

    test('ServerFailure.toString carries the status and error code', () {
      const failure = ServerFailure(
        message: 'maintenance',
        statusCode: 503,
        errorCode: 'MAINTENANCE',
      );
      final text = failure.toString();
      expect(text, contains('503'));
      expect(text, contains('MAINTENANCE'));
      expect(text, contains('maintenance'));
    });

    test('every variant carries a default message', () {
      const failures = <Failure>[
        NetworkFailure(),
        TimeoutFailure(),
        AuthFailure(),
        ValidationFailure(),
        CacheFailure(),
        CancelledFailure(),
        UnexpectedFailure(),
      ];
      for (final failure in failures) {
        expect(failure.message, isNotEmpty, reason: '$failure');
      }
    });

    test('ValidationFailure defaults to no field errors', () {
      expect(const ValidationFailure().fieldErrors, isEmpty);
    });

    test('cause and stack trace are preserved for reporting', () {
      final cause = Exception('root');
      final stack = StackTrace.current;
      final failure = UnexpectedFailure(cause: cause, stackTrace: stack);
      expect(failure.cause, same(cause));
      expect(failure.stackTrace, same(stack));
    });
  });

  group('AuthTokens', () {
    // Distinctive, secret-shaped values: single letters would collide with
    // ordinary text in toString and make the leak assertion meaningless.
    const access = 'eyJhbGciOi.accesspayload.sig';
    const refresh = 'rt_9f2c41d8b7e6';
    const tokens = AuthTokens(accessToken: access, refreshToken: refresh);

    test('is a value type', () {
      expect(
        tokens,
        const AuthTokens(accessToken: access, refreshToken: refresh),
      );
      expect(
        tokens,
        isNot(const AuthTokens(accessToken: access, refreshToken: 'rt_other')),
      );
      expect(
        tokens.hashCode,
        const AuthTokens(accessToken: access, refreshToken: refresh).hashCode,
      );
    });

    test('toString never leaks token material', () {
      final text = tokens.toString();
      expect(text, isNot(contains(access)));
      expect(text, isNot(contains(refresh)));
      expect(text, contains('redacted'));
    });
  });

  group('InMemoryAuthTokenStore', () {
    test('reads back what it writes, and clears', () async {
      final store = InMemoryAuthTokenStore();
      expect(await store.read(), isNull);

      const tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');
      await store.write(tokens);
      expect(await store.read(), tokens);

      await store.clear();
      expect(await store.read(), isNull);
    });
  });
}
