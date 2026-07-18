import 'package:flutter/material.dart';
import 'package:vaulta/design_system/design_system.dart';

/// Loading placeholder mirroring the account tile layout.
class AccountsSkeleton extends StatelessWidget {
  const AccountsSkeleton({super.key});

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
                    child: Row(
                      children: [
                        const SkeletonBox(width: 40, height: 40),
                        SizedBox(width: spacing.sm),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonLine(widthFactor: 0.45),
                              SizedBox(height: 8),
                              SkeletonLine(widthFactor: 0.3, height: 10),
                            ],
                          ),
                        ),
                        SizedBox(width: spacing.sm),
                        const SkeletonBox(width: 84, height: 18),
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
