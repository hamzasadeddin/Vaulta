import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';

/// Presentation-only mapping from [TransactionCategory] to copy and
/// iconography (the `AccountTypeVisuals` pattern — icons never live in the
/// domain). Copy is English-only until the l10n pass in Phase 10.
extension TransactionCategoryVisuals on TransactionCategory {
  String get label => switch (this) {
        TransactionCategory.groceries => 'Groceries',
        TransactionCategory.dining => 'Dining',
        TransactionCategory.transport => 'Transport',
        TransactionCategory.shopping => 'Shopping',
        TransactionCategory.entertainment => 'Entertainment',
        TransactionCategory.utilities => 'Utilities',
        TransactionCategory.salary => 'Salary',
        TransactionCategory.transfer => 'Transfer',
        TransactionCategory.other => 'Other',
      };

  IconData get icon => switch (this) {
        TransactionCategory.groceries => LucideIcons.shoppingCart,
        TransactionCategory.dining => LucideIcons.utensils,
        TransactionCategory.transport => LucideIcons.car,
        TransactionCategory.shopping => LucideIcons.shoppingBag,
        TransactionCategory.entertainment => LucideIcons.film,
        TransactionCategory.utilities => LucideIcons.zap,
        TransactionCategory.salary => LucideIcons.banknote,
        TransactionCategory.transfer => LucideIcons.arrowLeftRight,
        TransactionCategory.other => LucideIcons.receipt,
      };

  Color color(AppColors colors) => switch (this) {
        TransactionCategory.salary => colors.credit,
        TransactionCategory.transfer => colors.info,
        TransactionCategory.utilities => colors.warning,
        _ => colors.accent,
      };
}

extension TransactionStatusVisuals on TransactionStatus {
  String get label => switch (this) {
        TransactionStatus.pending => 'Pending',
        TransactionStatus.completed => 'Completed',
        TransactionStatus.failed => 'Failed',
      };

  StatusKind get badgeKind => switch (this) {
        TransactionStatus.pending => StatusKind.pending,
        TransactionStatus.completed => StatusKind.success,
        TransactionStatus.failed => StatusKind.failed,
      };
}

extension DisputeReasonVisuals on DisputeReason {
  String get label => switch (this) {
        DisputeReason.unauthorized => 'I don\u2019t recognize this charge',
        DisputeReason.wrongAmount => 'The amount is wrong',
        DisputeReason.duplicate => 'I was charged twice',
        DisputeReason.other => 'Something else',
      };
}
