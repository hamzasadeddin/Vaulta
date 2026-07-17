import 'package:meta/meta.dart';
import 'package:vaulta/core/money/money.dart';

/// One point on an account's balance-history curve.
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
