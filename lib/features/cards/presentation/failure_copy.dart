import 'package:vaulta/core/error/failure.dart';

/// One place for user-facing failure copy in the cards feature.
/// English-only until the l10n pass in Phase 10.
String cardsFailureCopy(Object failure) {
  return switch (failure) {
    NetworkFailure() => 'Can\u2019t reach Vaulta. Check your connection.',
    TimeoutFailure() => 'The connection timed out. Try again.',
    AuthFailure() => 'Your session has expired.',
    ValidationFailure() => 'Those values weren\u2019t accepted. Try again.',
    ServerFailure() => 'Something went wrong on our side.',
    _ => 'Something unexpected went wrong.',
  };
}
