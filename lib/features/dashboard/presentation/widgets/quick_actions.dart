import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';

/// Four shortcuts under the balance card. Their destinations arrive in
/// later phases; until then each explains itself with a snackbar.
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  static const List<({IconData icon, String label, String feature})> _actions =
      [
    (icon: LucideIcons.arrowUpRight, label: 'Send', feature: 'Transfers'),
    (icon: LucideIcons.plus, label: 'Add money', feature: 'Top-ups'),
    (icon: LucideIcons.creditCard, label: 'Cards', feature: 'Cards'),
    (icon: LucideIcons.fileText, label: 'Statements', feature: 'Statements'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final action in _actions)
          Expanded(
            child: _QuickAction(
              icon: action.icon,
              label: action.label,
              onTap: () => _comingSoon(context, action.feature),
            ),
          ),
      ],
    );
  }

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature — coming soon.')));
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Column(
      children: [
        Material(
          color: colors.accentMuted,
          borderRadius: context.radii.brMd,
          child: InkWell(
            onTap: onTap,
            borderRadius: context.radii.brMd,
            child: SizedBox(
              width: 52,
              height: 52,
              child: Icon(icon, size: 20, color: colors.accent),
            ),
          ),
        ),
        SizedBox(height: spacing.xs),
        Text(
          label,
          style: context.textStyles.labelSmall?.copyWith(
            color: colors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
