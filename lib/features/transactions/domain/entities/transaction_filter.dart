import 'package:meta/meta.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';

/// Server-side filter for the transactions feed. Every dimension is
/// optional and single-select; the repository translates it to query
/// parameters, so filtering composes with keyset pagination instead of
/// being applied to a partially loaded list.
@immutable
class TransactionFilter {
  const TransactionFilter({
    this.accountId,
    this.category,
    this.status,
    this.query = '',
  });

  final String? accountId;
  final TransactionCategory? category;
  final TransactionStatus? status;

  /// Free-text search over transaction titles. Blank means no search.
  final String query;

  String get normalizedQuery => query.trim();

  bool get isActive =>
      accountId != null ||
      category != null ||
      status != null ||
      normalizedQuery.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionFilter &&
          other.accountId == accountId &&
          other.category == category &&
          other.status == status &&
          other.query == query;

  @override
  int get hashCode => Object.hash(accountId, category, status, query);
}
