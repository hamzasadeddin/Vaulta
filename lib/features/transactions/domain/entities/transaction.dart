import 'package:meta/meta.dart';
import 'package:vaulta/core/money/money.dart';

/// Feature-owned category taxonomy. Deliberately duplicates the dashboard's
/// enum rather than importing its read model (same call as the P5
/// `Account`/`AccountSummary` split): the two features stay uncoupled and
/// this one can grow richer categorization without touching the dashboard.
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

/// Why a transaction is being disputed. Wire values are the enum names.
enum DisputeReason { unauthorized, wrongAmount, duplicate, other }

/// The full ledger-entry aggregate owned by the transactions feature.
///
/// [amount] is signed: credits positive, debits negative. [balanceAfter]
/// is the account balance once this entry settled — `null` while the
/// entry is pending or failed, because an unsettled entry has not moved
/// the ledger.
@immutable
class Transaction {
  const Transaction({
    required this.id,
    required this.accountId,
    required this.title,
    required this.category,
    required this.amount,
    required this.occurredAt,
    required this.reference,
    this.status = TransactionStatus.completed,
    this.balanceAfter,
  });

  final String id;
  final String accountId;
  final String title;
  final TransactionCategory category;
  final Money amount;
  final DateTime occurredAt;

  /// Bank-side reference shown on the receipt (`VLT-2026-482913`).
  final String reference;

  final TransactionStatus status;
  final Money? balanceAfter;

  bool get isCredit => amount.isPositive;

  bool get isPending => status == TransactionStatus.pending;

  bool get isFailed => status == TransactionStatus.failed;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          other.id == id &&
          other.accountId == accountId &&
          other.title == title &&
          other.category == category &&
          other.amount == amount &&
          other.occurredAt == occurredAt &&
          other.reference == reference &&
          other.status == status &&
          other.balanceAfter == balanceAfter;

  @override
  int get hashCode => Object.hash(
        id,
        accountId,
        title,
        category,
        amount,
        occurredAt,
        reference,
        status,
        balanceAfter,
      );
}

/// One keyset page of the transactions feed. [nextCursor] is an opaque
/// server token; `null` means the feed is exhausted.
@immutable
class TransactionsPage {
  const TransactionsPage({required this.items, required this.nextCursor});

  final List<Transaction> items;
  final String? nextCursor;

  bool get hasMore => nextCursor != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TransactionsPage ||
        other.nextCursor != nextCursor ||
        other.items.length != items.length) {
      return false;
    }
    for (var i = 0; i < items.length; i++) {
      if (other.items[i] != items[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(nextCursor, Object.hashAll(items));
}

/// Acknowledgement of a submitted dispute.
@immutable
class DisputeReceipt {
  const DisputeReceipt({required this.id, required this.transactionId});

  final String id;
  final String transactionId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DisputeReceipt &&
          other.id == id &&
          other.transactionId == transactionId;

  @override
  int get hashCode => Object.hash(id, transactionId);
}
