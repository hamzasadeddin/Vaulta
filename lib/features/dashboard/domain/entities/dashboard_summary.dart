import 'package:meta/meta.dart';
import 'package:vaulta/features/dashboard/domain/entities/account_summary.dart';
import 'package:vaulta/features/dashboard/domain/entities/recent_transaction.dart';

/// Everything the dashboard renders, fetched in one round trip.
@immutable
class DashboardSummary {
  const DashboardSummary({
    required this.accounts,
    required this.recentTransactions,
  });

  final List<AccountSummary> accounts;

  /// Newest first, across all accounts.
  final List<RecentTransaction> recentTransactions;

  AccountSummary? get primaryAccount =>
      accounts.isEmpty ? null : accounts.first;

  AccountSummary? accountById(String? id) {
    if (id == null) return null;
    for (final account in accounts) {
      if (account.id == id) return account;
    }
    return null;
  }
}
