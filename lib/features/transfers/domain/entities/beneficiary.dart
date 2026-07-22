import 'package:meta/meta.dart';
import 'package:vaulta/core/iban/iban.dart';
import 'package:vaulta/core/money/currency.dart';

/// A saved payee the user can send money to.
///
/// [currency] is the account's settlement currency, not a preference: a
/// transfer whose source differs from it is a cross-currency transfer and
/// is quoted with an FX rate.
@immutable
class Beneficiary {
  const Beneficiary({
    required this.id,
    required this.name,
    required this.iban,
    required this.bankName,
    required this.currency,
  });

  final String id;
  final String name;
  final Iban iban;
  final String bankName;
  final Currency currency;

  /// Avatar initials — `Layla Haddad` → `LH`, single names → one letter.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'))
      ..removeWhere((part) => part.isEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.firstLetter();
    return '${parts.first.firstLetter()}${parts.last.firstLetter()}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Beneficiary &&
          other.id == id &&
          other.name == name &&
          other.iban == iban &&
          other.bankName == bankName &&
          other.currency == currency;

  @override
  int get hashCode => Object.hash(id, name, iban, bankName, currency);
}

extension on String {
  /// First character, uppercased — safe on empty strings.
  String firstLetter() => isEmpty ? '' : this[0].toUpperCase();
}
