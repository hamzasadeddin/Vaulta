import 'package:meta/meta.dart';
import 'package:vaulta/core/money/money.dart';

enum TransactionCategory {
  groceries,
  dining,
  transport,
  shopping,
  entertainment,
  utilities,
  salary,
  transfer,
  other,
}

enum TransactionStatus { pending, completed, failed }

/// A ledger entry as shown in the dashboard's recent-activity feed.
///
/// [amount] is signed: credits are positive, debits negative.
@immutable
class RecentTransaction {
  const RecentTransaction({
    required this.id,
    required this.accountId,
    required this.title,
    required this.category,
    required this.amount,
    required this.occurredAt,
    this.status = TransactionStatus.completed,
  });

  final String id;
  final String accountId;
  final String title;
  final TransactionCategory category;
  final Money amount;
  final DateTime occurredAt;
  final TransactionStatus status;

  bool get isCredit => amount.isPositive;

  bool get isPending => status == TransactionStatus.pending;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentTransaction &&
          other.id == id &&
          other.accountId == accountId &&
          other.title == title &&
          other.category == category &&
          other.amount == amount &&
          other.occurredAt == occurredAt &&
          other.status == status;

  @override
  int get hashCode =>
      Object.hash(id, accountId, title, category, amount, occurredAt, status);
}
