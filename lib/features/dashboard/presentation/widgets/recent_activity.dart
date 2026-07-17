import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/dashboard/domain/entities/recent_transaction.dart';

/// Header + latest transactions across all accounts, newest first.
class RecentActivity extends StatelessWidget {
  const RecentActivity({required this.transactions, super.key});

  final List<RecentTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Recent activity',
                style: context.textStyles.titleMedium,
              ),
            ),
            AppButton(
              label: 'See all',
              variant: AppButtonVariant.ghost,
              size: AppButtonSize.small,
              onPressed: () => _comingSoon(context),
            ),
          ],
        ),
        SizedBox(height: spacing.sm),
        if (transactions.isEmpty)
          const _EmptyActivity()
        else
          AppCard(
            padding: EdgeInsets.symmetric(vertical: spacing.xs),
            child: Column(
              children: [
                for (final (index, txn) in transactions.indexed) ...[
                  if (index != 0) const Divider(height: 1),
                  _Staggered(
                    index: index,
                    child: _TransactionTile(transaction: txn),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Transaction history — coming soon.')),
      );
  }
}

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Icon(
            LucideIcons.receipt,
            size: 28,
            color: context.colors.textTertiary,
          ),
          SizedBox(height: context.spacing.sm),
          Text(
            'No transactions yet',
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final RecentTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final color = _categoryColor(colors, transaction.category);

    return Padding(
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
            child: Icon(
              _categoryIcon(transaction.category),
              size: 18,
              color: color,
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: context.textStyles.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  _timeLabel(transaction.occurredAt),
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
              if (transaction.isPending) ...[
                SizedBox(height: spacing.xxs),
                Text(
                  'Pending',
                  style: context.textStyles.labelSmall?.copyWith(
                    color: colors.pending,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

IconData _categoryIcon(TransactionCategory category) => switch (category) {
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

Color _categoryColor(AppColors colors, TransactionCategory category) =>
    switch (category) {
      TransactionCategory.salary => colors.credit,
      TransactionCategory.transfer => colors.info,
      TransactionCategory.utilities => colors.warning,
      _ => colors.accent,
    };

String _timeLabel(DateTime timestamp) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(timestamp.year, timestamp.month, timestamp.day);
  final time = DateFormat.jm().format(timestamp);
  if (day == today) return 'Today · $time';
  if (day == today.subtract(const Duration(days: 1))) {
    return 'Yesterday · $time';
  }
  return DateFormat.MMMd().format(timestamp);
}

/// Fade-and-rise entry, ≤300 ms total including the per-row delay.
class _Staggered extends StatelessWidget {
  const _Staggered({required this.index, required this.child});

  final int index;
  final Widget child;

  static const _rise = 12.0;

  @override
  Widget build(BuildContext context) {
    final delayMs = math.min(index * 30, 120);
    final totalMs = 180 + delayMs;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: totalMs),
      curve: Interval(delayMs / totalMs, 1, curve: Curves.easeOutCubic),
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, _rise * (1 - t)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
