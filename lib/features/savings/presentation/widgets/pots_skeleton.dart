import 'package:flutter/material.dart';
import 'package:vaulta/design_system/design_system.dart';

/// Loading placeholder mirroring the pot tile layout.
class PotsSkeleton extends StatelessWidget {
  const PotsSkeleton({super.key});

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
              children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i != 0) SizedBox(height: spacing.sm),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SkeletonBox(width: 40, height: 40),
                            SizedBox(width: spacing.sm),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SkeletonLine(widthFactor: 0.4),
                                  SizedBox(height: 8),
                                  SkeletonLine(widthFactor: 0.28, height: 10),
                                ],
                              ),
                            ),
                            SizedBox(width: spacing.sm),
                            const SkeletonBox(width: 72, height: 18),
                          ],
                        ),
                        SizedBox(height: spacing.sm),
                        const SkeletonBox(height: 5),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
