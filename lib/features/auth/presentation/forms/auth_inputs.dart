import 'package:formz/formz.dart';

enum EmailValidationError { empty, invalid }

class EmailInput extends FormzInput<String, EmailValidationError> {
  const EmailInput.pure() : super.pure('');

  const EmailInput.dirty([super.value = '']) : super.dirty();

  static final _pattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  @override
  EmailValidationError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return EmailValidationError.empty;
    if (!_pattern.hasMatch(trimmed)) return EmailValidationError.invalid;
    return null;
  }
}

enum PasswordValidationError { empty, tooShort }

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.pure() : super.pure('');

  const PasswordInput.dirty([super.value = '']) : super.dirty();

  static const minLength = 8;

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    if (value.length < minLength) return PasswordValidationError.tooShort;
    return null;
  }
}

enum OtpValidationError { incomplete }

class OtpCodeInput extends FormzInput<String, OtpValidationError> {
  const OtpCodeInput.pure() : super.pure('');

  const OtpCodeInput.dirty([super.value = '']) : super.dirty();

  static const length = 6;

  static final _digits = RegExp(r'^\d{6}$');

  @override
  OtpValidationError? validator(String value) {
    return _digits.hasMatch(value) ? null : OtpValidationError.incomplete;
  }
}
