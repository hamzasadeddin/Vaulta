import 'package:meta/meta.dart';
import 'package:vaulta/core/money/money.dart';

/// One point on an account's balance-history curve.
///
/// Intentionally duplicates the dashboard's `BalancePoint` rather than
/// importing it — features stay decoupled (same reasoning as the
/// `Account` / `AccountSummary` split, §10.4).
@immutable
class BalancePoint {
  const BalancePoint({required this.date, required this.balance});

  final DateTime date;
  final Money balance;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalancePoint && other.date == date && other.balance == balance;

  @override
  int get hashCode => Object.hash(date, balance);
}
