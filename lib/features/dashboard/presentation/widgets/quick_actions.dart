import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
// Presentation-only navigation into the cards feature (the feature owns
// its paths so no app-layer import cycle is created).
import 'package:vaulta/features/cards/presentation/cards_paths.dart';
import 'package:vaulta/features/transfers/presentation/transfers_paths.dart';

/// Four shortcuts under the balance card. Send (Phase 8) and Cards
/// (Phase 7) are live; the rest arrive in later phases and explain
/// themselves with a snackbar until then.
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = <({IconData icon, String label, VoidCallback onTap})>[
      (
        icon: LucideIcons.arrowUpRight,
        label: 'Send',
        // Pushed, not `go`: the flow sits outside the shell and pops back
        // here when it finishes.
        onTap: () => context.push(TransfersPaths.flow),
      ),
      (
        icon: LucideIcons.plus,
        label: 'Add money',
        onTap: () => _comingSoon(context, 'Top-ups'),
      ),
      (
        icon: LucideIcons.creditCard,
        label: 'Cards',
        onTap: () => context.go(CardsPaths.root),
      ),
      (
        icon: LucideIcons.fileText,
        label: 'Statements',
        onTap: () => _comingSoon(context, 'Statements'),
      ),
    ];

    return Row(
      children: [
        for (final action in actions)
          Expanded(
            child: _QuickAction(
              icon: action.icon,
              label: action.label,
              onTap: action.onTap,
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
