import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/features/transfers/domain/entities/outbox_entry.dart';

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

/// Why a queued transfer stopped, and what the user can do about it.
///
/// Every line leads with the money, because that is the only question
/// the user actually has. Handoff 8 §10 is explicit that neither silent
/// retry nor silent discard is acceptable here: the queue may not send
/// at a price the user never saw, and it may not drop an instruction
/// while they believe the money moved. So each arm names the state and
/// offers a decision.
String outboxAttentionCopy(OutboxAttention attention) {
  return switch (attention) {
    OutboxAttention.rateExpired =>
      'The exchange rate expired while you were offline. Nothing left '
          'your account \u2014 get a new price to send it now.',
    // Reached only after the idempotency key came back unmatched, which
    // is the server saying this confirm never settled. Saying "we lost
    // it" would be worse than useless; saying nothing moved is true.
    OutboxAttention.draftGone =>
      'This transfer is no longer held by the bank and nothing left '
          'your account. Get a new price to send it again.',
    OutboxAttention.rejected =>
      'The bank turned this transfer down \u2014 check the amount and '
          'your available balance, then get a new price.',
    OutboxAttention.exhausted =>
      'We couldn\u2019t reach the bank to send this. Nothing has left '
          'your account. Try again, or discard it.',
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
