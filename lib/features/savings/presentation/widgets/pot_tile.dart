import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';
import 'package:vaulta/features/savings/presentation/widgets/pot_progress.dart';

/// One pot in the list: name, balance, and — when it has a goal — a
/// compact progress track. Tapping opens the detail.
class PotTile extends StatelessWidget {
  const PotTile({required this.pot, required this.onTap, super.key});

  final Pot pot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.accentMuted,
                  borderRadius: context.radii.brMd,
                ),
                child: Icon(
                  LucideIcons.piggyBank,
                  size: 20,
                  color: colors.accent,
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pot.name,
                      style: context.textStyles.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      pot.roundUpsEnabled
                          ? 'Round-ups on'
                          : pot.hasGoal
                              ? 'Saving toward a goal'
                              : 'Open-ended',
                      style: context.textStyles.bodySmall?.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing.sm),
              BalanceText(pot.balance, size: MoneyTextSize.md),
            ],
          ),
          if (pot.hasGoal) ...[
            SizedBox(height: spacing.sm),
            PotProgress(pot: pot, compact: true),
          ],
        ],
      ),
    );
  }
}
