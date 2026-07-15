import 'package:flutter/material.dart';
import 'package:vaulta/design_system/theme/theme_context.dart';

/// Surface container: subtle border, no drop shadow (dark UIs read
/// elevation from tone, not shadow). Tappable when [onTap] is given.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding,
    this.raised = false,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  /// Uses the raised surface tone (sheets, prominent cards).
  final bool raised;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii.brLg;
    final content = Padding(
      padding: padding ?? EdgeInsets.all(context.spacing.md),
      child: child,
    );

    return Material(
      color: raised ? colors.surfaceRaised : colors.surface,
      borderRadius: radius,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: colors.border),
        ),
        child: onTap == null
            ? content
            : InkWell(onTap: onTap, borderRadius: radius, child: content),
      ),
    );
  }
}

enum StatusKind { pending, success, failed, info, neutral }

/// Pill badge with a status dot — transaction states, KYC status, flavors.
class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.label, required this.kind, super.key});

  final String label;
  final StatusKind kind;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = switch (kind) {
      StatusKind.pending => colors.pending,
      StatusKind.success => colors.success,
      StatusKind.failed => colors.danger,
      StatusKind.info => colors.info,
      StatusKind.neutral => colors.textSecondary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: context.radii.brFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: const SizedBox.square(dimension: 6),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: context.textStyles.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
