import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';
import 'package:vaulta/features/savings/presentation/providers/pots_providers.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/presentation/transfers_paths.dart';

/// Surfaces the pending round-up sweep and funds it in one tap.
///
/// Invisible unless there is spare change to move *and* a pot to move it
/// into — round-ups are opt-in per pot. The sweep is an ordinary deposit
/// transfer (`PotDestination`), so it inherits idempotency and the outbox
/// like any other money movement.
///
/// The summary is computed here from the two controllers this widget
/// watches, rather than in a derived provider: a provider watching
/// [potsControllerProvider] would recompute during the shell's layout pass
/// and schedule a build mid-build. A widget rebuild is safe.
class RoundUpCard extends ConsumerWidget {
  const RoundUpCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pots = ref.watch(potsControllerProvider).value ?? const <Pot>[];
    final feed = ref.watch(transactionsFeedControllerProvider).value;
    final summary = computeRoundUpSummary(
      pots: pots,
      transactions: feed?.items ?? const <Transaction>[],
    );

    final pot = summary.pot;
    if (!summary.hasPending || pot == null) return const SizedBox.shrink();

    final colors = context.colors;
    final spacing = context.spacing;

    return AppCard(
      raised: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.zap, size: 18, color: colors.accent),
              SizedBox(width: spacing.xs),
              Text('Spare change', style: context.textStyles.titleSmall),
              const Spacer(),
              BalanceText(summary.total, size: MoneyTextSize.md),
            ],
          ),
          SizedBox(height: spacing.xs),
          Text(
            'Rounded up from ${summary.count} '
            '${summary.count == 1 ? 'purchase' : 'purchases'} in your recent '
            'activity.',
            style: context.textStyles.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: spacing.sm),
          AppButton(
            label: 'Add to ${pot.name}',
            icon: LucideIcons.plus,
            size: AppButtonSize.small,
            onPressed: () => _sweep(context, pot, summary),
          ),
        ],
      ),
    );
  }

  void _sweep(BuildContext context, Pot pot, RoundUpSummary summary) {
    final request = TransferRequest(
      sourceAccountId: pot.accountId,
      destination: PotDestination(pot.id),
      amount: summary.total,
      note: 'Round-ups',
    );
    context.go(TransfersPaths.flow, extra: request);
  }
}
