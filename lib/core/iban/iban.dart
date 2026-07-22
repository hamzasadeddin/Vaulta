import 'package:meta/meta.dart';

/// An IBAN (ISO 13616), validated by the mod-97 check.
///
/// Lives in `core` beside `Money` rather than inside the transfers
/// feature: an account identifier is a banking primitive that accounts,
/// transfers and statements all have a claim on, and one feature
/// importing another feature's domain would break the layering rule.
///
/// Construction is closed — [tryParse] is the only way in, so an `Iban`
/// instance is a proof that the check digits pass. Invalid input stays a
/// `String` and never reaches the domain.
@immutable
class Iban {
  const Iban._(this.value);

  /// Returns `null` unless [input] is a structurally valid, mod-97
  /// correct IBAN. Separators and case are normalized away first.
  static Iban? tryParse(String input) {
    final normalized = normalize(input);
    return isValid(normalized) ? Iban._(normalized) : null;
  }

  /// Shortest (Norway) and longest (Malta et al) registered lengths.
  static const minLength = 15;
  static const maxLength = 34;

  static final _separators = RegExp('[^A-Z0-9]');
  static final _structure = RegExp(r'^[A-Z]{2}\d{2}[A-Z0-9]+$');

  static const _zero = 0x30;
  static const _nine = 0x39;
  static const _letterA = 0x41;

  /// Uppercase, separators removed — the storage and wire form.
  static String normalize(String input) =>
      input.toUpperCase().replaceAll(_separators, '');

  static bool isValid(String input) {
    final candidate = normalize(input);
    if (candidate.length < minLength || candidate.length > maxLength) {
      return false;
    }
    if (!_structure.hasMatch(candidate)) return false;
    return _mod97(candidate) == 1;
  }

  /// Compact form, no separators (`JO82VBNK…`).
  final String value;

  String get countryCode => value.substring(0, 2);

  /// Last four characters — rows show `•••• 4573`.
  String get tail => value.substring(value.length - 4);

  /// Grouped in fours for display (`JO82 VBNK 0001 …`).
  String get grouped {
    final buffer = StringBuffer();
    for (var i = 0; i < value.length; i += 4) {
      if (i != 0) buffer.write(' ');
      final end = i + 4;
      buffer.write(value.substring(i, end > value.length ? value.length : end));
    }
    return buffer.toString();
  }

  /// Move the first four characters to the back, map letters to
  /// `A = 10 … Z = 35`, then take the whole thing mod 97. A valid IBAN
  /// leaves a remainder of exactly 1.
  ///
  /// The remainder is folded digit by digit rather than built into one
  /// enormous integer: the intermediate value stays below 10,000, so this
  /// needs no [BigInt] and behaves identically on the web's 53-bit ints.
  static int _mod97(String value) {
    final rearranged = '${value.substring(4)}${value.substring(0, 4)}';
    var remainder = 0;
    for (final unit in rearranged.codeUnits) {
      if (unit >= _zero && unit <= _nine) {
        remainder = (remainder * 10 + (unit - _zero)) % 97;
      } else {
        remainder = (remainder * 100 + (unit - _letterA + 10)) % 97;
      }
    }
    return remainder;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Iban && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
