import 'package:vaulta/core/error/failure.dart';

/// One place for user-facing failure copy in the transfers feature.
/// English-only until the l10n pass in Phase 10.
///
/// A rejected transfer needs to say *why* — "that didn't work" is not an
/// acceptable answer when money was involved. The specifics come from the
/// **field keys** on a [ValidationFailure], never from the server's
/// message string: `Failure.message` is developer-facing (see
/// `core/error/failure.dart`), and rendering backend prose would put
/// untranslated, unreviewed text in front of the user. Phase 9 extends
/// the same rule to `ServerFailure`, switching on the structured
/// `errorCode` rather than the message it arrived with.
String transfersFailureCopy(Object failure) {
  return switch (failure) {
    ValidationFailure(:final fieldErrors) => _validationCopy(fieldErrors),
    // Matched before the general ServerFailure arm below. An expired
    // quote is the one 409 the user can act on, and it needs to say the
    // money is still theirs before it says anything else.
    ServerFailure(errorCode: 'QUOTE_EXPIRED') =>
      'That rate expired before the transfer went through. Nothing has '
          'left your account \u2014 get a new price to continue.',
    NetworkFailure() => 'Can\u2019t reach Vaulta. Your money hasn\u2019t '
        'moved \u2014 check your connection and try again.',
    TimeoutFailure() => 'The connection timed out. Check your activity '
        'before retrying \u2014 the transfer may still have gone through.',
    AuthFailure() => 'Your session has expired.',
    ServerFailure() => 'Something went wrong on our side. No money has '
        'left your account.',
    _ => 'Something unexpected went wrong.',
  };
}

String _validationCopy(Map<String, List<String>> fieldErrors) {
  if (fieldErrors.containsKey('amountMinor')) {
    return 'That amount doesn\u2019t work \u2014 check you have enough '
        'available to cover it, including any fee.';
  }
  if (fieldErrors.containsKey('iban')) {
    return 'That IBAN isn\u2019t valid. Check it and try again.';
  }
  if (fieldErrors.containsKey('destination')) {
    return 'We couldn\u2019t find that recipient.';
  }
  if (fieldErrors.containsKey('scheduledFor')) {
    return 'Pick a date in the future to schedule this transfer.';
  }
  return 'Those details weren\u2019t accepted. Check them and try again.';
}
