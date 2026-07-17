import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/dashboard/domain/entities/balance_point.dart';

/// An account as the dashboard sees it: identity, current balance, and a
/// short balance history for the sparkline. The full account aggregate
/// (IBAN, statements, …) belongs to the accounts feature (Phase 5).
@immutable
class AccountSummary {
  const AccountSummary({
    required this.id,
    required this.name,
    required this.balance,
    this.history = const [],
  });

  final String id;
  final String name;
  final Money balance;

  /// Oldest → newest.
  final List<BalancePoint> history;

  Currency get currency => balance.currency;

  /// Percentage change across the history window, exact to two decimals.
  ///
  /// Computed in integer minor units — no floating point. `null` when the
  /// window is too short or the baseline is zero.
  Decimal? get historyChangePercent {
    if (history.length < 2) return null;
    final first = history.first.balance.minorUnits;
    final last = history.last.balance.minorUnits;
    if (first == BigInt.zero) return null;
    final basisPoints = ((last - first) * BigInt.from(10000)) ~/ first;
    return Decimal.fromBigInt(basisPoints).shift(-2);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountSummary &&
          other.id == id &&
          other.name == name &&
          other.balance == balance &&
          _sameHistory(other.history);

  bool _sameHistory(List<BalancePoint> other) {
    if (other.length != history.length) return false;
    for (var i = 0; i < history.length; i++) {
      if (other[i] != history[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(id, name, balance, history.length);
}
