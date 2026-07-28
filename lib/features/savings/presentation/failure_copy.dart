import 'package:vaulta/core/error/failure.dart';

/// User-facing failure copy for the savings feature. English-only until
/// the l10n pass in Phase 10, like every feature. Specifics for a rejected
/// create come from the field keys on a [ValidationFailure], never the
/// server's developer-facing message string.
String potsFailureCopy(Object failure) {
  return switch (failure) {
    ValidationFailure(:final fieldErrors) => _validationCopy(fieldErrors),
    NetworkFailure() => 'Can\u2019t reach Vaulta. Check your connection and '
        'pull to refresh.',
    TimeoutFailure() => 'The connection timed out. Try again in a moment.',
    AuthFailure() => 'Your session has expired.',
    ServerFailure() => 'Something went wrong on our side. Try again shortly.',
    CacheFailure() => 'We couldn\u2019t load your pots.',
    _ => 'Something unexpected went wrong.',
  };
}

String _validationCopy(Map<String, List<String>> fieldErrors) {
  if (fieldErrors.containsKey('name')) {
    return 'Give your pot a name to continue.';
  }
  if (fieldErrors.containsKey('goalMinor')) {
    return 'Enter a target above zero, or leave it open-ended.';
  }
  if (fieldErrors.containsKey('accountId')) {
    return 'Pick an account to fund this pot from.';
  }
  return 'Those details weren\u2019t accepted. Check them and try again.';
}
