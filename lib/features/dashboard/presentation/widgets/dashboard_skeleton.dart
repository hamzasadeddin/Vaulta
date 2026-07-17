import 'package:flutter/material.dart';
import 'package:vaulta/design_system/design_system.dart';

/// Loading placeholder that mirrors the loaded dashboard's silhouette so
/// content doesn't jump when data arrives.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

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
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SkeletonLine(widthFactor: 0.3),
                      SizedBox(height: spacing.sm),
                      const SkeletonBox(width: 200, height: 40),
                      SizedBox(height: spacing.md),
                      const SkeletonBox(height: 56),
                    ],
                  ),
                ),
                SizedBox(height: spacing.lg),
                Row(
                  children: [
                    for (var i = 0; i < 4; i++)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing.xs,
                          ),
                          child: const SkeletonBox(height: 52),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: spacing.lg),
                const SkeletonLine(widthFactor: 0.4),
                SizedBox(height: spacing.sm),
                AppCard(
                  child: Column(
                    children: [
                      for (var i = 0; i < 4; i++)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: spacing.sm,
                          ),
                          child: Row(
                            children: [
                              const SkeletonBox(width: 40, height: 40),
                              SizedBox(width: spacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SkeletonLine(widthFactor: 0.5),
                                    SizedBox(height: spacing.xs),
                                    const SkeletonLine(
                                      widthFactor: 0.3,
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                              const SkeletonBox(width: 64, height: 14),
                            ],
                          ),
                        ),
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
