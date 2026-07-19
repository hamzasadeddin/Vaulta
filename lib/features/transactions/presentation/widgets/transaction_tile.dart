import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/presentation/widgets/transaction_visuals.dart';

/// One feed row (the `AccountTile` pattern: card surface, animated accent
/// border while open in the expanded detail pane). Failed entries render
/// struck-through and muted — they never moved the ledger.
class TransactionTile extends StatelessWidget {
  const TransactionTile({
    required this.transaction,
    required this.onTap,
    this.selected = false,
    super.key,
  });

  final Transaction transaction;
  final VoidCallback onTap;

  /// Highlighted when this entry is open in the expanded detail pane.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final color = transaction.category.color(colors);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: context.radii.brLg,
        border: Border.all(
          color: selected ? colors.accent : Colors.transparent,
        ),
      ),
      child: AppCard(
        onTap: onTap,
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(transaction.category.icon, size: 18, color: color),
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: transaction.isFailed ? colors.textTertiary : null,
                      decoration: transaction.isFailed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: spacing.xxs),
                  Text(
                    '${transaction.category.label} \u00b7 '
                    '${DateFormat.jm().format(transaction.occurredAt)}',
                    style: context.textStyles.labelSmall?.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: spacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SignedMoneyText(transaction.amount, size: MoneyTextSize.sm),
                if (transaction.status != TransactionStatus.completed) ...[
                  SizedBox(height: spacing.xxs),
                  Text(
                    transaction.status.label,
                    style: context.textStyles.labelSmall?.copyWith(
                      color: transaction.isPending
                          ? colors.pending
                          : colors.danger,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
