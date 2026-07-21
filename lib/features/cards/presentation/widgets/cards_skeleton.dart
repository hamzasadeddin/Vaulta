import 'package:flutter/material.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/cards/presentation/widgets/card_visual.dart';

/// Loading placeholder mirroring the cards screen: a card-shaped block,
/// dots, and the action row.
class CardsSkeleton extends StatelessWidget {
  const CardsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(spacing.md),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: CardVisual.aspectRatio,
                  child: SkeletonBox(
                    height: double.infinity,
                    radius: context.radii.brLg,
                  ),
                ),
                SizedBox(height: spacing.md),
                const Center(child: SkeletonBox(width: 48, height: 8)),
                SizedBox(height: spacing.lg),
                Row(
                  children: [
                    for (var i = 0; i < 3; i++) ...[
                      if (i != 0) SizedBox(width: spacing.sm),
                      const Expanded(child: SkeletonBox(height: 48)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
