import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
// Presentation-level composition: the receipt shows the account's display
// name, which the accounts slice already holds (same rationale as the
// filter bar — no domain/data coupling between the features).
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/presentation/failure_copy.dart';
import 'package:vaulta/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:vaulta/features/transactions/presentation/widgets/dispute_sheet.dart';
import 'package:vaulta/features/transactions/presentation/widgets/transaction_visuals.dart';

/// Everything below the app bar on a transaction's receipt surface. Used
/// by both the pushed route (compact/medium) and the expanded-layout pane.
class TransactionDetailView extends ConsumerWidget {
  const TransactionDetailView({required this.transactionId, super.key});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionDetailControllerProvider(transactionId));

    return switch (state) {
      AsyncData(:final value) => _Receipt(transaction: value),
      AsyncError(:final error) => _DetailError(
          message: transactionsFailureCopy(error),
          onRetry: () => ref
              .read(
                transactionDetailControllerProvider(transactionId).notifier,
              )
              .retry(),
        ),
      _ => const _DetailSkeleton(),
    };
  }
}

/// Master-detail secondary pane for expanded layouts. Shows a prompt until
/// the user picks an entry from the feed.
class TransactionDetailPane extends ConsumerWidget {
  const TransactionDetailPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionId = ref.watch(paneTransactionIdProvider);
    if (transactionId == null) return const _EmptyPane();
    return SafeArea(
      child: TransactionDetailView(transactionId: transactionId),
    );
  }
}

class _Receipt extends ConsumerWidget {
  const _Receipt({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final color = transaction.category.color(colors);
    final account = ref.watch(accountByIdProvider(transaction.accountId));

    return ListView(
      padding: EdgeInsets.all(spacing.md),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: spacing.md),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      transaction.category.icon,
                      size: 28,
                      color: color,
                    ),
                  ),
                ),
                SizedBox(height: spacing.md),
                Center(
                  child: Text(
                    transaction.title,
                    style: context.textStyles.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: spacing.sm),
                Center(
                  child: SignedMoneyText(
                    transaction.amount,
                    size: MoneyTextSize.lg,
                  ),
                ),
                SizedBox(height: spacing.sm),
                Center(
                  child: StatusBadge(
                    label: transaction.status.label,
                    kind: transaction.status.badgeKind,
                  ),
                ),
                SizedBox(height: spacing.lg),
                AppCard(
                  child: Column(
                    children: [
                      _ReceiptRow(
                        label: 'Account',
                        value: account?.name ?? transaction.accountId,
                      ),
                      _ReceiptRow(
                        label: 'Category',
                        value: transaction.category.label,
                      ),
                      _ReceiptRow(
                        label: 'Date',
                        value: DateFormat('EEE, MMM d, y \u00b7 h:mm a')
                            .format(transaction.occurredAt),
                      ),
                      _ReceiptRow(
                        label: 'Reference',
                        value: transaction.reference,
                      ),
                      if (transaction.balanceAfter != null)
                        _ReceiptRow(
                          label: 'Balance after',
                          valueWidget: BalanceText(
                            transaction.balanceAfter!,
                            size: MoneyTextSize.sm,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: spacing.lg),
                AppButton(
                  label: 'Report an issue',
                  icon: LucideIcons.flag,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => showDisputeSheet(context, transaction),
                ),
                SizedBox(height: spacing.lg),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({required this.label, this.value, this.valueWidget})
      : assert(
          value != null || valueWidget != null,
          'Provide value or valueWidget',
        );

  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: valueWidget ??
                  Text(
                    value!,
                    style: context.textStyles.bodyMedium,
                    textAlign: TextAlign.right,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPane extends StatelessWidget {
  const _EmptyPane();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.receipt, size: 32, color: colors.textTertiary),
          SizedBox(height: context.spacing.sm),
          Text(
            'Select a transaction to see its receipt',
            style: context.textStyles.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(spacing.md),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                SizedBox(height: spacing.md),
                const SkeletonBox(
                  width: 64,
                  height: 64,
                  radius: BorderRadius.all(Radius.circular(32)),
                ),
                SizedBox(height: spacing.md),
                const SkeletonLine(widthFactor: 0.4),
                SizedBox(height: spacing.sm),
                const SkeletonBox(width: 140, height: 28),
                SizedBox(height: spacing.lg),
                const SkeletonBox(height: 180),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.cloudOff,
            size: 32,
            color: context.colors.textTertiary,
          ),
          SizedBox(height: spacing.sm),
          Text(
            message,
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.md),
          AppButton(
            label: 'Try again',
            variant: AppButtonVariant.secondary,
            size: AppButtonSize.small,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
