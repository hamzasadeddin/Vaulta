import 'package:formz/formz.dart';
import 'package:vaulta/core/iban/iban.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';

enum AmountValidationError { empty, malformed, notPositive }

/// The typed amount, validated structurally.
///
/// Parsing goes through [Money.tryParse] — text becomes an exact
/// `Decimal` and never a `double`. Whether the amount *fits* the
/// balance is a cross-field rule the controller owns, because it needs
/// the source account; this input only answers "is this a positive
/// amount of money at all".
class AmountInput extends FormzInput<String, AmountValidationError> {
  const AmountInput.pure() : super.pure('');

  const AmountInput.dirty([super.value = '']) : super.dirty();

  /// Currency only affects rounding precision here, so the validator uses
  /// a placeholder; the real currency is applied by [moneyIn].
  static const Currency _probe = Currency.usd;

  /// The parsed amount in [currency], or `null` when invalid.
  Money? moneyIn(Currency currency) {
    final parsed = Money.tryParse(value, currency);
    if (parsed == null || !parsed.isPositive) return null;
    return parsed;
  }

  @override
  AmountValidationError? validator(String value) {
    if (value.trim().isEmpty) return AmountValidationError.empty;
    final parsed = Money.tryParse(value, _probe);
    if (parsed == null) return AmountValidationError.malformed;
    if (!parsed.isPositive) return AmountValidationError.notPositive;
    return null;
  }
}

enum IbanValidationError { empty, invalid }

/// A one-off payee's IBAN. `invalid` covers both a malformed structure
/// and a failed mod-97 check — from the user's side they are the same
/// mistake, and distinguishing them only invites them to guess at check
/// digits.
class IbanInput extends FormzInput<String, IbanValidationError> {
  const IbanInput.pure() : super.pure('');

  const IbanInput.dirty([super.value = '']) : super.dirty();

  Iban? get iban => Iban.tryParse(value);

  @override
  IbanValidationError? validator(String value) {
    if (value.trim().isEmpty) return IbanValidationError.empty;
    return Iban.isValid(value) ? null : IbanValidationError.invalid;
  }
}

enum HolderNameValidationError { empty, tooShort }

class HolderNameInput extends FormzInput<String, HolderNameValidationError> {
  const HolderNameInput.pure() : super.pure('');

  const HolderNameInput.dirty([super.value = '']) : super.dirty();

  static const minLength = 2;

  @override
  HolderNameValidationError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return HolderNameValidationError.empty;
    if (trimmed.length < minLength) {
      return HolderNameValidationError.tooShort;
    }
    return null;
  }
}
