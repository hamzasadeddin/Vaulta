import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction_filter.dart';

/// Domain contract for the transactions feature.
///
/// Deliberately remote-only (unlike the P5 accounts cache): a keyset-
/// paginated, arbitrarily filtered result set has no honest cache-first
/// story — a partial cached window silently masquerades as the full feed.
/// Offline transactions are the Phase 9 outbox candidate, not a cache.
abstract interface class TransactionsRepository {
  /// One page of the feed. Pass the previous page's `nextCursor` to
  /// continue; `null` starts from the newest entry.
  Future<Result<TransactionsPage, Failure>> getTransactions({
    required TransactionFilter filter,
    String? cursor,
    int limit,
  });

  /// Single entry, for receipts reached by deep link.
  Future<Result<Transaction, Failure>> getTransaction(String transactionId);

  /// Files a dispute against an entry. Returns the bank's acknowledgement.
  Future<Result<DisputeReceipt, Failure>> submitDispute({
    required String transactionId,
    required DisputeReason reason,
  });
}
