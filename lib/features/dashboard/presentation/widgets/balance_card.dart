import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/dashboard/domain/entities/account_summary.dart';
import 'package:vaulta/features/dashboard/presentation/widgets/balance_sparkline.dart';

/// The hero card: selected account's balance (animated, maskable), trend
/// over the history window, sparkline, and chips to switch accounts.
class BalanceCard extends StatefulWidget {
  const BalanceCard({
    required this.accounts,
    required this.selected,
    required this.onSelect,
    super.key,
  });

  final List<AccountSummary> accounts;
  final AccountSummary selected;
  final ValueChanged<String> onSelect;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  var _masked = false;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final account = widget.selected;
    final change = account.historyChangePercent;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  account.name,
                  style: context.textStyles.labelMedium?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
              IconButton(
                tooltip: _masked ? 'Show balance' : 'Hide balance',
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  _masked ? LucideIcons.eyeOff : LucideIcons.eye,
                  size: 18,
                  color: context.colors.textSecondary,
                ),
                onPressed: () => setState(() => _masked = !_masked),
              ),
            ],
          ),
          SizedBox(height: spacing.xxs),
          AnimatedBalanceText(account.balance, masked: _masked),
          if (change != null) ...[
            SizedBox(height: spacing.xs),
            _TrendLabel(change: change, days: account.history.length),
          ],
          if (account.history.length >= 2) ...[
            SizedBox(height: spacing.md),
            BalanceSparkline(points: account.history),
          ],
          if (widget.accounts.length > 1) ...[
            SizedBox(height: spacing.md),
            _AccountChips(
              accounts: widget.accounts,
              selectedId: account.id,
              onSelect: widget.onSelect,
            ),
          ],
        ],
      ),
    );
  }
}

class _TrendLabel extends StatelessWidget {
  const _TrendLabel({required this.change, required this.days});

  final Decimal change;
  final int days;

  @override
  Widget build(BuildContext context) {
    final negative = change < Decimal.zero;
    final color = negative ? context.colors.debit : context.colors.credit;
    final sign = negative ? '' : '+';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          negative ? LucideIcons.trendingDown : LucideIcons.trendingUp,
          size: 14,
          color: color,
        ),
        SizedBox(width: context.spacing.xxs),
        Text(
          '$sign${change.toStringAsFixed(1)}%',
          style: context.textStyles.labelSmall?.copyWith(color: color),
        ),
        Text(
          ' · past $days days',
          style: context.textStyles.labelSmall?.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _AccountChips extends StatelessWidget {
  const _AccountChips({
    required this.accounts,
    required this.selectedId,
    required this.onSelect,
  });

  final List<AccountSummary> accounts;
  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: context.spacing.xs,
        children: [
          for (final account in accounts)
            _AccountChip(
              account: account,
              selected: account.id == selectedId,
              onTap: () => onSelect(account.id),
            ),
        ],
      ),
    );
  }
}

class _AccountChip extends StatelessWidget {
  const _AccountChip({
    required this.account,
    required this.selected,
    required this.onTap,
  });

  final AccountSummary account;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Material(
      color: selected ? colors.accentMuted : colors.surfaceRaised,
      shape: RoundedRectangleBorder(
        borderRadius: context.radii.brFull,
        side: BorderSide(color: selected ? colors.accent : colors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: context.radii.brFull,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.sm,
            vertical: spacing.xs,
          ),
          child: Text(
            '${account.currency.code} · ${account.name}',
            style: context.textStyles.labelSmall?.copyWith(
              color: selected ? colors.textPrimary : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
