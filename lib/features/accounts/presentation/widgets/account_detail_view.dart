import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/history_range.dart';
import 'package:vaulta/features/accounts/presentation/failure_copy.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/accounts/presentation/widgets/account_tile.dart';
import 'package:vaulta/features/accounts/presentation/widgets/account_visuals.dart';
import 'package:vaulta/features/accounts/presentation/widgets/balance_history_chart.dart';
import 'package:vaulta/features/accounts/presentation/widgets/statements_section.dart';

/// Everything below the app bar on an account's detail surface. Used by
/// both the pushed route (compact/medium, [useHeroes] on) and the
/// expanded-layout pane (heroes off — the list tiles carrying the same
/// tags are visible simultaneously there).
class AccountDetailView extends ConsumerWidget {
  const AccountDetailView({
    required this.accountId,
    this.useHeroes = false,
    super.key,
  });

  final String accountId;
  final bool useHeroes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountByIdProvider(accountId));
    if (account == null) {
      // Deep link before the list resolved, or an unknown id.
      final accounts = ref.watch(accountsControllerProvider);
      return accounts.isLoading
          ? const _DetailSkeleton()
          : const _AccountNotFound();
    }

    final spacing = context.spacing;
    return ListView(
      padding: EdgeInsets.all(spacing.md),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DetailHeader(account: account, useHero: useHeroes),
                SizedBox(height: spacing.lg),
                _HistoryCard(account: account),
                SizedBox(height: spacing.lg),
                _DetailsCard(account: account),
                SizedBox(height: spacing.lg),
                StatementsSection(account: account),
                SizedBox(height: spacing.lg),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Master-detail secondary pane for expanded layouts. Shows a prompt until
/// the user picks an account from the list.
class AccountDetailPane extends ConsumerWidget {
  const AccountDetailPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountId = ref.watch(paneAccountIdProvider);
    if (accountId == null) return const _EmptyPane();
    return SafeArea(child: AccountDetailView(accountId: accountId));
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
          Icon(LucideIcons.wallet, size: 32, color: colors.textTertiary),
          SizedBox(height: context.spacing.sm),
          Text(
            'Select an account to see its details',
            style: context.textStyles.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.account, required this.useHero});

  final Account account;
  final bool useHero;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    final balance = BalanceText(account.balance);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          account.name,
          style: context.textStyles.titleMedium?.copyWith(
            color: colors.textSecondary,
          ),
        ),
        SizedBox(height: spacing.xs),
        if (useHero)
          Hero(
            tag: AccountTile.heroTag(account.id),
            child: Material(type: MaterialType.transparency, child: balance),
          )
        else
          balance,
        SizedBox(height: spacing.sm),
        Row(
          children: [
            StatusBadge(label: account.type.label, kind: StatusKind.neutral),
            SizedBox(width: spacing.sm),
            Text(
              '\u2022\u2022\u2022\u2022 ${account.ibanTail}',
              style: context.textStyles.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Balance history chart with a range selector. Each (account, range)
/// pair is its own provider, so hopping back to a visited range repaints
/// instantly.
class _HistoryCard extends ConsumerStatefulWidget {
  const _HistoryCard({required this.account});

  final Account account;

  @override
  ConsumerState<_HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends ConsumerState<_HistoryCard> {
  HistoryRange _range = HistoryRange.quarter;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final state = ref.watch(accountHistoryProvider(widget.account.id, _range));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Balance history', style: context.textStyles.titleMedium),
          SizedBox(height: spacing.sm),
          SegmentedButton<HistoryRange>(
            segments: [
              for (final range in HistoryRange.values)
                ButtonSegment(value: range, label: Text(_label(range))),
            ],
            selected: {_range},
            showSelectedIcon: false,
            onSelectionChanged: (selection) =>
                setState(() => _range = selection.first),
          ),
          SizedBox(height: spacing.md),
          switch (state) {
            AsyncData(:final value) when value.length < 2 =>
              const _ChartMessage('Not enough history for this range yet.'),
            AsyncData(:final value) => BalanceHistoryChart(points: value),
            AsyncError(:final error) => _ChartError(
                message: accountsFailureCopy(error),
                onRetry: () => ref
                    .read(
                      accountHistoryProvider(widget.account.id, _range)
                          .notifier,
                    )
                    .retry(),
              ),
            _ => const SkeletonBox(height: 220),
          },
        ],
      ),
    );
  }

  String _label(HistoryRange range) => switch (range) {
        HistoryRange.month => '1M',
        HistoryRange.quarter => '3M',
        HistoryRange.year => '1Y',
      };
}

class _ChartMessage extends StatelessWidget {
  const _ChartMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Center(
        child: Text(
          message,
          style: context.textStyles.bodySmall?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ChartError extends StatelessWidget {
  const _ChartError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: context.spacing.sm),
            AppButton(
              label: 'Retry',
              variant: AppButtonVariant.ghost,
              size: AppButtonSize.small,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

/// IBAN (with copy), currency and opening date.
class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Account details', style: context.textStyles.titleMedium),
          SizedBox(height: spacing.sm),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IBAN',
                      style: context.textStyles.labelSmall?.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      account.ibanGrouped,
                      style: context.typography.moneySm.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Copy IBAN',
                onPressed: () => _copyIban(context),
                icon: Icon(
                  LucideIcons.copy,
                  size: 18,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          Divider(height: spacing.lg),
          _DetailRow(label: 'Currency', value: account.currency.code),
          SizedBox(height: spacing.sm),
          _DetailRow(
            label: 'Opened',
            value: DateFormat('d MMM yyyy').format(account.openedAt),
          ),
        ],
      ),
    );
  }

  Future<void> _copyIban(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: account.iban));
    unawaited(HapticFeedback.selectionClick());
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('IBAN copied')));
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textStyles.bodySmall?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        Text(value, style: context.textStyles.bodyMedium),
      ],
    );
  }
}

class _AccountNotFound extends StatelessWidget {
  const _AccountNotFound();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: Text(
          'This account isn\u2019t available.',
          style: context.textStyles.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
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
      padding: EdgeInsets.all(spacing.md),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLine(widthFactor: 0.3),
                SizedBox(height: spacing.sm),
                const SkeletonBox(width: 220, height: 40),
                SizedBox(height: spacing.lg),
                const SkeletonBox(height: 280),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
