import 'package:flutter/material.dart';
import 'package:vaulta/core/money/money_formatter.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';

/// A thin goal-progress track for a pot. Renders nothing for an
/// open-ended pot (no goal to measure against). The fill is driven by
/// [Pot.progress], a display ratio computed from exact minor units, and
/// turns [AppColors.success] once the goal is reached.
class PotProgress extends StatelessWidget {
  const PotProgress({required this.pot, this.compact = false, super.key});

  final Pot pot;

  /// A tile uses the compact form (bar only); the detail screen shows the
  /// figures beneath it.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final progress = pot.progress;
    final goal = pot.goal;
    if (progress == null || goal == null) return const SizedBox.shrink();

    final colors = context.colors;
    final reached = pot.goalReached;
    final track = reached ? colors.success : colors.accent;

    final bar = ClipRRect(
      borderRadius: context.radii.brFull,
      child: LinearProgressIndicator(
        value: progress,
        minHeight: compact ? 5 : 8,
        backgroundColor: colors.border,
        valueColor: AlwaysStoppedAnimation<Color>(track),
      ),
    );

    if (compact) return bar;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bar,
        SizedBox(height: context.spacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              reached
                  ? 'Goal reached'
                  : '${(progress * 100).round()}% of ${goal.format()}',
              style: context.textStyles.bodySmall?.copyWith(
                color: reached ? colors.success : colors.textSecondary,
              ),
            ),
            if (pot.remaining case final left? when !reached)
              Text(
                '${left.format()} to go',
                style: context.textStyles.bodySmall?.copyWith(
                  color: colors.textTertiary,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
