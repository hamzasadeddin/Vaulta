import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/network/network_providers.dart';
import 'package:vaulta/core/security/biometric_service.dart';
import 'package:vaulta/core/usecase/use_case.dart';
import 'package:vaulta/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vaulta/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:vaulta/features/auth/domain/repositories/auth_repository.dart';
import 'package:vaulta/features/auth/domain/usecases/auth_usecases.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_state.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remote: AuthRemoteDataSource(ref.watch(dioProvider)),
    tokenStore: ref.watch(authTokenStoreProvider),
  );
}

/// Session state machine. `keepAlive` — the session outlives any screen.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    // Kick session restore exactly once, after build returns.
    unawaited(Future<void>.microtask(restore));
    return const AuthUnknown();
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  /// Cold start: try to restore a stored session. A restored session
  /// always lands **Locked** — reopening a banking app requires unlock.
  Future<void> restore() async {
    final result = await RestoreSession(_repository).call(const NoParams());
    state = result.fold(
      onSuccess: Locked.new,
      onFailure: (_) => const Unauthenticated(),
    );
  }

  /// Step 1: credentials → OTP challenge.
  /// Returns the failure for inline display, or `null` on success.
  Future<Failure?> login({
    required String email,
    required String password,
  }) async {
    final result = await LoginWithPassword(_repository).call(
      LoginParams(email: email, password: password),
    );
    return result.fold(
      onSuccess: (challenge) {
        state = OtpPending(challenge: challenge, email: email);
        return null;
      },
      onFailure: (failure) => failure,
    );
  }

  /// Step 2: OTP code → authenticated session.
  Future<Failure?> verifyOtp(String code) async {
    final current = state;
    if (current is! OtpPending) {
      return const UnexpectedFailure(message: 'No pending challenge');
    }
    final result = await VerifyOtp(_repository).call(
      VerifyOtpParams(challengeId: current.challenge.id, code: code),
    );
    return result.fold(
      onSuccess: (user) {
        state = Authenticated(user);
        return null;
      },
      onFailure: (failure) {
        // Expired/consumed challenge → restart from login.
        if (failure is AuthFailure) state = const Unauthenticated();
        return failure;
      },
    );
  }

  /// Biometric gate from [Locked] back to [Authenticated].
  Future<bool> unlock() async {
    final current = state;
    if (current is! Locked) return false;
    final passed = await ref.read(biometricServiceProvider).authenticate(
          reason: 'Unlock Vaulta',
        );
    if (passed) state = Authenticated(current.user);
    return passed;
  }

  /// Called on app backgrounding (see `VaultaApp`) and never navigates
  /// itself — the router reacts to the state change.
  void lock() {
    final current = state;
    if (current is Authenticated) state = Locked(current.user);
  }

  Future<void> logout() async {
    await Logout(_repository).call(const NoParams());
    state = const Unauthenticated();
  }

  /// Invoked by the network layer when a refresh cycle failed
  /// (`sessionExpiredHandlerProvider`). Store is already cleared.
  void onSessionExpired() {
    if (state.hasSession || state is AuthUnknown) {
      state = const Unauthenticated();
    }
  }

  /// Abandon the OTP step.
  void cancelOtp() {
    if (state is OtpPending) state = const Unauthenticated();
  }
}
