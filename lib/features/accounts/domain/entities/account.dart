import 'dart:math' as math;

import 'package:meta/meta.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';

enum AccountType { checking, savings }

/// The full account aggregate owned by the accounts feature.
///
/// Deliberately separate from the dashboard's `AccountSummary` read model
/// (§10.4 option a): the two duplicate id/name/balance and share zero
/// coupling, which keeps `GET /dashboard/summary` a genuine single
/// round-trip read model.
@immutable
class Account {
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.iban,
    required this.balance,
    required this.openedAt,
  });

  final String id;
  final String name;
  final AccountType type;

  /// Compact form, no separators (`JO82VBNK…`).
  final String iban;

  final Money balance;
  final DateTime openedAt;

  Currency get currency => balance.currency;

  /// Last four characters — list rows show `•••• 4573`.
  String get ibanTail =>
      iban.length <= 4 ? iban : iban.substring(iban.length - 4);

  /// Grouped in fours for display and statements (`JO82 VBNK 0001 …`).
  String get ibanGrouped {
    final buffer = StringBuffer();
    for (var i = 0; i < iban.length; i += 4) {
      if (i != 0) buffer.write(' ');
      buffer.write(iban.substring(i, math.min(i + 4, iban.length)));
    }
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account &&
          other.id == id &&
          other.name == name &&
          other.type == type &&
          other.iban == iban &&
          other.balance == balance &&
          other.openedAt == openedAt;

  @override
  int get hashCode => Object.hash(id, name, type, iban, balance, openedAt);
}
