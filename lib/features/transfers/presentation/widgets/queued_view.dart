import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/transfers/presentation/providers/transfers_providers.dart';

/// Shown when the bank could not be reached and the confirm was saved.
///
/// Deliberately *not* a receipt. A receipt says money moved; this says an
/// instruction is held and will be delivered. The visual language differs
/// for the same reason the wording does — an amber clock, not a green
/// tick — because the single worst outcome here is a user who closes the
/// app believing the transfer has already landed.
class QueuedView extends ConsumerWidget {
  const QueuedView({required this.onDone, super.key});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final state = ref.watch(transferFlowProvider);
    final quote = state.quote;

    return ListView(
      padding: EdgeInsets.all(spacing.md),
      children: [
        SizedBox(height: spacing.lg),
        Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.pending.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Icon(
                LucideIcons.clock,
                size: 32,
                color: colors.pending,
              ),
            ),
          ),
        ),
        SizedBox(height: spacing.md),
        Text(
          'Saved to send',
          textAlign: TextAlign.center,
          style: context.textStyles.titleLarge,
        ),
        SizedBox(height: spacing.xs),
        Text(
          quote == null
              ? 'We couldn\u2019t reach the bank. This transfer is saved '
                  'and will send by itself once you\u2019re back online.'
              : 'We couldn\u2019t reach the bank, so ${quote.destinationLabel} '
                  'hasn\u2019t been paid yet. This transfer is saved and '
                  'will send by itself once you\u2019re back online.',
          textAlign: TextAlign.center,
          style: context.textStyles.bodyMedium?.copyWith(
            color: colors.textSecondary,
          ),
        ),
        if (quote != null) ...[
          SizedBox(height: spacing.lg),
          AppCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'To',
                      style: context.textStyles.bodySmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      quote.destinationLabel,
                      style: context.textStyles.bodyMedium,
                    ),
                  ],
                ),
                SizedBox(height: spacing.sm),
                Row(
                  children: [
                    Text(
                      'Total to debit',
                      style: context.textStyles.bodySmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    BalanceText(quote.totalDebit, size: MoneyTextSize.md),
                  ],
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: spacing.md),
        Text(
          // The one sentence that stops a duplicate send. It is true
          // because the confirm replays its original idempotency key.
          'Nothing has left your account yet, and sending it again '
          'won\u2019t pay twice.',
          textAlign: TextAlign.center,
          style: context.textStyles.bodySmall?.copyWith(
            color: colors.textTertiary,
          ),
        ),
        SizedBox(height: spacing.lg),
        AppButton(label: 'Done', expand: true, onPressed: onDone),
      ],
    );
  }
}
