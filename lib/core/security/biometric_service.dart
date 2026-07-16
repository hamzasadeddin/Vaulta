import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

/// Thin, mockable gate over `local_auth`.
class BiometricService {
  BiometricService([LocalAuthentication? auth])
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  /// Prompts for biometrics / device credential.
  ///
  /// Returns `true` on platforms with no lock capability at all (web,
  /// bare emulators) so the demo flow isn't a dead end there — a real
  /// deployment would force enrollment instead. Documented demo behavior.
  Future<bool> authenticate({required String reason}) async {
    try {
      final supported = await _auth.isDeviceSupported();
      final hasBiometrics = await _auth.canCheckBiometrics;
      if (!supported && !hasBiometrics) return true;
      // Minimal call: `AuthenticationOptions` (stickyAuth et al.) is not
      // present in the resolved local_auth version. Revisit if pinning a
      // version that exposes it — stickyAuth is desirable here.
      return await _auth.authenticate(localizedReason: reason);
    } on MissingPluginException {
      // No local_auth implementation on this platform (web). Note this is
      // NOT a PlatformException subclass, so it needs its own catch.
      return true;
    } on PlatformException {
      // Enrolled but the attempt failed or was cancelled: stay locked.
      return false;
    }
  }
}

final biometricServiceProvider = Provider<BiometricService>(
  (ref) => BiometricService(),
);
