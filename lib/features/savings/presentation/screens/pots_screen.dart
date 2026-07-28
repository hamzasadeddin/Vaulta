import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';
import 'package:vaulta/features/savings/presentation/failure_copy.dart';
import 'package:vaulta/features/savings/presentation/providers/pots_providers.dart';
import 'package:vaulta/features/savings/presentation/savings_paths.dart';
import 'package:vaulta/features/savings/presentation/widgets/create_pot_sheet.dart';
import 'package:vaulta/features/savings/presentation/widgets/pot_tile.dart';
import 'package:vaulta/features/savings/presentation/widgets/pots_skeleton.dart';
import 'package:vaulta/features/savings/presentation/widgets/round_up_card.dart';

/// Savings pots. Like the cards list, opening a pot pushes a detail route
/// at every width — a pot has no master-detail pane.
class PotsScreen extends ConsumerWidget {
  const PotsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(potsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Savings')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showCreatePotSheet(context),
        icon: const Icon(LucideIcons.plus),
        label: const Text('New pot'),
      ),
      body: SafeArea(
        child: switch (state) {
          AsyncData(:final value) => _PotsList(pots: value),
          AsyncError(:final error) => _LoadFailed(error: error),
          _ => const PotsSkeleton(),
        },
      ),
    );
  }
}

class _PotsList extends ConsumerWidget {
  const _PotsList({required this.pots});

  final List<Pot> pots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;

    return RefreshIndicator(
      onRefresh: () => _refresh(context, ref),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing.md),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                children: [
                  const RoundUpCard(),
                  SizedBox(height: spacing.sm),
                  if (pots.isEmpty)
                    const _EmptyPots()
                  else
                    for (final (index, pot) in pots.indexed) ...[
                      if (index != 0) SizedBox(height: spacing.sm),
                      PotTile(
                        pot: pot,
                        onTap: () => context.go(SavingsPaths.detail(pot.id)),
                      ),
                    ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh(BuildContext context, WidgetRef ref) async {
    final failure = await ref.read(potsControllerProvider.notifier).refresh();
    if (failure == null || !context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(potsFailureCopy(failure))));
  }
}

class _EmptyPots extends StatelessWidget {
  const _EmptyPots();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      child: Column(
        children: [
          Icon(LucideIcons.piggyBank, size: 28, color: colors.textTertiary),
          SizedBox(height: context.spacing.sm),
          Text(
            'No pots yet',
            style: context.textStyles.titleSmall,
          ),
          SizedBox(height: context.spacing.xs),
          Text(
            'Set money aside for a goal. Tap New pot to start.',
            textAlign: TextAlign.center,
            style: context.textStyles.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadFailed extends ConsumerWidget {
  const _LoadFailed({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.cloudOff,
              size: 28,
              color: context.colors.textTertiary,
            ),
            SizedBox(height: spacing.sm),
            Text(
              potsFailureCopy(error),
              textAlign: TextAlign.center,
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.md),
            AppButton(
              label: 'Try again',
              variant: AppButtonVariant.secondary,
              onPressed: () =>
                  ref.read(potsControllerProvider.notifier).refresh(),
            ),
          ],
        ),
      ),
    );
  }
}
