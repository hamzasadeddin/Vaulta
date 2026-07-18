import 'package:vaulta/core/error/failure.dart';

/// One place for user-facing failure copy in the accounts feature.
/// English-only until the l10n pass in Phase 10.
String accountsFailureCopy(Object failure) {
  return switch (failure) {
    NetworkFailure() => 'Can\u2019t reach Vaulta. Check your connection.',
    TimeoutFailure() => 'The connection timed out. Try again.',
    AuthFailure() => 'Your session has expired.',
    ServerFailure() => 'Something went wrong on our side.',
    CacheFailure() => 'Could not read saved data on this device.',
    _ => 'Something unexpected went wrong.',
  };
}
