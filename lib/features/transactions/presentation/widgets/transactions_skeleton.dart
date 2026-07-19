import 'package:flutter/material.dart';
import 'package:vaulta/design_system/design_system.dart';

/// Loading placeholder mirroring the feed's layout: a search bar, a chip
/// row and a card of transaction rows.
class TransactionsSkeleton extends StatelessWidget {
  const TransactionsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(spacing.md),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SkeletonBox(height: 48),
                SizedBox(height: spacing.sm),
                Row(
                  children: [
                    for (var i = 0; i < 4; i++) ...[
                      if (i != 0) SizedBox(width: spacing.xs),
                      const SkeletonBox(width: 72, height: 32),
                    ],
                  ],
                ),
                SizedBox(height: spacing.md),
                AppCard(
                  child: Column(
                    children: [
                      for (var i = 0; i < 7; i++) ...[
                        if (i != 0) SizedBox(height: spacing.md),
                        const _RowSkeleton(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RowSkeleton extends StatelessWidget {
  const _RowSkeleton();

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Row(
      children: [
        const SkeletonBox(
          width: 40,
          height: 40,
          radius: BorderRadius.all(Radius.circular(20)),
        ),
        SizedBox(width: spacing.md),
        const Expanded(child: SkeletonLine(widthFactor: 0.6)),
        SizedBox(width: spacing.md),
        const SkeletonBox(width: 64),
      ],
    );
  }
}
