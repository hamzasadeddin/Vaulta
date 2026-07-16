import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/core/security/biometric_service.dart';
import 'package:vaulta/features/auth/domain/entities/otp_challenge.dart';
import 'package:vaulta/features/auth/domain/entities/user.dart';
import 'package:vaulta/features/auth/domain/repositories/auth_repository.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_providers.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_state.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockBiometricService extends Mock implements BiometricService {}

const _user = User(
  id: 'usr_1',
  fullName: 'Dana Khoury',
  email: 'dana@example.com',
  kycStatus: KycStatus.verified,
);

const _challenge = OtpChallenge(
  id: 'chl_1',
  maskedDestination: 'd***@example.com',
  expiresIn: Duration(minutes: 2),
);

void main() {
  late _MockAuthRepository repository;
  late _MockBiometricService biometrics;
  late ProviderContainer container;

  setUp(() {
    repository = _MockAuthRepository();
    biometrics = _MockBiometricService();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        biometricServiceProvider.overrideWithValue(biometrics),
      ],
    );
    addTearDown(container.dispose);
  });

  AuthController controller() =>
      container.read(authControllerProvider.notifier);

  AuthState state() => container.read(authControllerProvider);

  /// Lets the microtask-scheduled restore() settle.
  Future<void> settle() => Future<void>.delayed(Duration.zero);

  group('restore', () {
    test('restored session lands Locked, not Authenticated', () async {
      when(repository.restoreSession)
          .thenAnswer((_) async => const Result.success(_user));

      container.read(authControllerProvider);
      await settle();

      expect(state(), isA<Locked>());
    });

    test('no stored session lands Unauthenticated', () async {
      when(repository.restoreSession).thenAnswer(
        (_) async => const Result.failure(AuthFailure()),
      );

      container.read(authControllerProvider);
      await settle();

      expect(state(), isA<Unauthenticated>());
    });
  });

  group('login → otp → authenticated', () {
    // Build the controller and let the restore microtask settle before any
    // test body runs: restore() completing mid-test would otherwise race
    // with the state these tests set.
    setUp(() async {
      when(repository.restoreSession).thenAnswer(
        (_) async => const Result.failure(AuthFailure()),
      );
      container.read(authControllerProvider);
      await settle();
    });

    test('successful login moves to OtpPending', () async {
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Result.success(_challenge));

      final failure = await controller().login(
        email: 'dana@example.com',
        password: 'hunter2hunter2',
      );

      expect(failure, isNull);
      expect(state(), isA<OtpPending>());
    });

    test('failed login stays Unauthenticated and returns the failure',
        () async {
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Result.failure(AuthFailure()));
      expect(state(), isA<Unauthenticated>(), reason: 'precondition');

      final failure = await controller().login(
        email: 'dana@example.com',
        password: 'wrong',
      );

      expect(failure, isA<AuthFailure>());
      expect(state(), isA<Unauthenticated>());
    });

    test('verifyOtp success authenticates', () async {
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Result.success(_challenge));
      when(
        () => repository.verifyOtp(
          challengeId: any(named: 'challengeId'),
          code: any(named: 'code'),
        ),
      ).thenAnswer((_) async => const Result.success(_user));

      await controller().login(email: 'd@e.com', password: 'hunter2hunter2');
      final failure = await controller().verifyOtp('123456');

      expect(failure, isNull);
      expect(state(), isA<Authenticated>());
      verify(
        () => repository.verifyOtp(challengeId: 'chl_1', code: '123456'),
      ).called(1);
    });

    test('verifyOtp without a pending challenge fails fast', () async {
      final failure = await controller().verifyOtp('123456');
      expect(failure, isA<UnexpectedFailure>());
      verifyNever(
        () => repository.verifyOtp(
          challengeId: any(named: 'challengeId'),
          code: any(named: 'code'),
        ),
      );
    });

    test('expired challenge sends the user back to login', () async {
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Result.success(_challenge));
      when(
        () => repository.verifyOtp(
          challengeId: any(named: 'challengeId'),
          code: any(named: 'code'),
        ),
      ).thenAnswer((_) async => const Result.failure(AuthFailure()));

      await controller().login(email: 'd@e.com', password: 'hunter2hunter2');
      await controller().verifyOtp('123456');

      expect(state(), isA<Unauthenticated>());
    });
  });

  group('lock / unlock / logout', () {
    setUp(() async {
      when(repository.restoreSession)
          .thenAnswer((_) async => const Result.success(_user));
      container.read(authControllerProvider);
      await settle();
    });

    test('biometric pass unlocks', () async {
      when(() => biometrics.authenticate(reason: any(named: 'reason')))
          .thenAnswer((_) async => true);

      final unlocked = await controller().unlock();

      expect(unlocked, isTrue);
      expect(state(), isA<Authenticated>());
    });

    test('biometric failure stays Locked', () async {
      when(() => biometrics.authenticate(reason: any(named: 'reason')))
          .thenAnswer((_) async => false);

      final unlocked = await controller().unlock();

      expect(unlocked, isFalse);
      expect(state(), isA<Locked>());
    });

    test('backgrounding locks an authenticated session', () async {
      when(() => biometrics.authenticate(reason: any(named: 'reason')))
          .thenAnswer((_) async => true);
      await controller().unlock();

      controller().lock();

      expect(state(), isA<Locked>());
    });

    test('logout clears the session', () async {
      when(repository.logout)
          .thenAnswer((_) async => const Result.success(null));

      await controller().logout();

      expect(state(), isA<Unauthenticated>());
      verify(repository.logout).called(1);
    });

    test('session expiry from the network layer unauthenticates', () async {
      controller().onSessionExpired();
      expect(state(), isA<Unauthenticated>());
    });
  });
}
