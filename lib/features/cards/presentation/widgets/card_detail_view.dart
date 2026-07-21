import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';
// Presentation-level composition: the detail surface shows the linked
// account's display name, which the accounts slice already holds (the
// transactions-receipt rationale — no domain/data coupling between the
// features).
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';
import 'package:vaulta/features/cards/presentation/failure_copy.dart';
import 'package:vaulta/features/cards/presentation/providers/cards_providers.dart';
import 'package:vaulta/features/cards/presentation/widgets/card_visual.dart';
import 'package:vaulta/features/cards/presentation/widgets/card_visuals.dart';
import 'package:vaulta/features/cards/presentation/widgets/limits_sheet.dart';

/// Everything below the app bar on a card's detail surface. Pushed-route
/// only — cards have no expanded-layout pane, so the hero tag renders at
/// most once per tree.
class CardDetailView extends ConsumerWidget {
  const CardDetailView({required this.card, super.key});

  final BankCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;

    return ListView(
      padding: EdgeInsets.all(spacing.md),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: Hero(
                      tag: CardVisual.heroTag(card.id),
                      child: Material(
                        type: MaterialType.transparency,
                        child: CardVisual(card: card),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: spacing.md),
                _FreezeCard(card: card),
                SizedBox(height: spacing.md),
                _PanCard(card: card),
                SizedBox(height: spacing.md),
                _LimitsCard(card: card),
                SizedBox(height: spacing.md),
                _AboutCard(card: card),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FreezeCard extends ConsumerWidget {
  const _FreezeCard({required this.card});

  final BankCard card;

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final failure =
        await ref.read(cardsControllerProvider.notifier).toggleFrozen(card.id);
    if (failure == null || !context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(cardsFailureCopy(failure))));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;

    return AppCard(
      child: Row(
        children: [
          Icon(LucideIcons.snowflake, size: 20, color: colors.info),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Freeze card', style: context.textStyles.bodyMedium),
                SizedBox(height: spacing.xxs),
                Text(
                  card.isFrozen
                      ? 'All payments are blocked'
                      : 'Instantly block all payments',
                  style: context.textStyles.labelSmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Optimistic: the switch reflects the flip immediately; the
          // controller reconciles or rolls back behind it.
          Switch(
            value: card.isFrozen,
            onChanged: (_) => _toggle(context, ref),
          ),
        ],
      ),
    );
  }
}

class _PanCard extends ConsumerWidget {
  const _PanCard({required this.card});

  final BankCard card;

  Future<void> _reveal(BuildContext context, WidgetRef ref) async {
    final failure =
        await ref.read(revealedPanProvider(card.id).notifier).reveal();
    if (failure == null || !context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(cardsFailureCopy(failure))));
  }

  Future<void> _copy(BuildContext context, String pan) async {
    // Demo-grade copy. A production build would pair this with
    // platform-side clipboard expiry / sensitive-content flags.
    await Clipboard.setData(ClipboardData(text: pan));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Card number copied.')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final state = ref.watch(revealedPanProvider(card.id));
    final pan = state.value;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card details',
            style: context.textStyles.labelSmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: spacing.sm),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: pan == null
                ? _MaskedPan(
                    card: card,
                    loading: state.isLoading,
                    onReveal: () => _reveal(context, ref),
                  )
                : _RevealedPan(
                    pan: pan,
                    onCopy: () => _copy(context, pan.pan),
                    onHide: () =>
                        ref.read(revealedPanProvider(card.id).notifier).hide(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MaskedPan extends StatelessWidget {
  const _MaskedPan({
    required this.card,
    required this.loading,
    required this.onReveal,
  });

  final BankCard card;
  final bool loading;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '\u2022\u2022\u2022\u2022 \u2022\u2022\u2022\u2022 '
            '\u2022\u2022\u2022\u2022 ${card.panLast4}',
            style: context.typography.moneyMd,
          ),
        ),
        AppButton(
          label: 'Reveal',
          variant: AppButtonVariant.secondary,
          size: AppButtonSize.small,
          icon: LucideIcons.eye,
          loading: loading,
          onPressed: onReveal,
        ),
      ],
    );
  }
}

class _RevealedPan extends StatelessWidget {
  const _RevealedPan({
    required this.pan,
    required this.onCopy,
    required this.onHide,
  });

  final CardPan pan;
  final VoidCallback onCopy;
  final VoidCallback onHide;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final expiry = '${pan.expiryMonth.toString().padLeft(2, '0')}/'
        '${(pan.expiryYear % 100).toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(pan.grouped, style: context.typography.moneyMd),
            ),
            IconButton(
              onPressed: onCopy,
              tooltip: 'Copy card number',
              icon: Icon(LucideIcons.copy, size: 18, color: colors.accent),
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        Row(
          children: [
            _SecretField(label: 'CVV', value: pan.cvv),
            SizedBox(width: spacing.lg),
            _SecretField(label: 'Expires', value: expiry),
            const Spacer(),
            AppButton(
              label: 'Hide',
              variant: AppButtonVariant.ghost,
              size: AppButtonSize.small,
              onPressed: onHide,
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        Text(
          'Hides automatically in a few seconds.',
          style: context.textStyles.labelSmall?.copyWith(
            color: colors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _SecretField extends StatelessWidget {
  const _SecretField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textStyles.labelSmall?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        Text(value, style: context.typography.moneySm),
      ],
    );
  }
}

class _LimitsCard extends ConsumerWidget {
  const _LimitsCard({required this.card});

  final BankCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final limits = card.limits;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending limits',
            style: context.textStyles.labelSmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: spacing.sm),
          _LimitRow(
            label: 'Today',
            spent: limits.spentToday,
            limit: limits.daily,
          ),
          SizedBox(height: spacing.md),
          _LimitRow(
            label: 'This month',
            spent: limits.spentThisMonth,
            limit: limits.monthly,
          ),
          SizedBox(height: spacing.md),
          AppButton(
            label: 'Adjust limits',
            variant: AppButtonVariant.secondary,
            size: AppButtonSize.small,
            icon: LucideIcons.slidersHorizontal,
            onPressed: () => showLimitsSheet(context, card),
          ),
        ],
      ),
    );
  }
}

class _LimitRow extends StatelessWidget {
  const _LimitRow({
    required this.label,
    required this.spent,
    required this.limit,
  });

  final String label;
  final Money spent;
  final Money limit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    // BigInt → double at the pixel boundary only (the chart invariant):
    // the ratio drives bar geometry; the exact amounts render as Money.
    final limitMinor = limit.minorUnits;
    final progress = limitMinor == BigInt.zero
        ? 0.0
        : (spent.minorUnits.toDouble() / limitMinor.toDouble()).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label, style: context.textStyles.bodySmall),
            ),
            BalanceText(spent, size: MoneyTextSize.sm),
            Text(
              ' of ',
              style: context.textStyles.labelSmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            BalanceText(limit, size: MoneyTextSize.sm),
          ],
        ),
        SizedBox(height: spacing.xs),
        ClipRRect(
          borderRadius: context.radii.brFull,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: colors.surfaceRaised,
            color: progress >= 1 ? colors.warning : colors.accent,
          ),
        ),
      ],
    );
  }
}

class _AboutCard extends ConsumerWidget {
  const _AboutCard({required this.card});

  final BankCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final account = ref.watch(accountByIdProvider(card.accountId));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this card',
            style: context.textStyles.labelSmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: spacing.sm),
          _AboutRow(label: 'Linked account', value: account?.name ?? '\u2014'),
          _AboutRow(label: 'Type', value: card.type.label),
          _AboutRow(label: 'Network', value: card.network.label),
          _AboutRow(label: 'Status', value: card.status.label),
          _AboutRow(label: 'Expires', value: card.expiryLabel),
        ],
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
          Text(value, style: context.textStyles.bodySmall),
        ],
      ),
    );
  }
}
