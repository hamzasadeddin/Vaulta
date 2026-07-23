import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';

/// The live state of a held FX price.
///
/// Split out as its own widget so the countdown can be tested and golden-ed
/// without standing up the whole review step, and so the colour thresholds
/// live in exactly one place.
class QuoteCountdown extends StatelessWidget {
  const QuoteCountdown({required this.remaining, super.key});

  /// Time left on the lock. `Duration.zero` renders the expired state.
  final Duration remaining;

  /// Below this the pill turns amber. Ten seconds is roughly the point
  /// where a user can still finish reading and tap, so it is a warning
  /// rather than a countdown to a foregone conclusion.
  static const urgentBelow = Duration(seconds: 10);

  bool get _expired => remaining <= Duration.zero;

  bool get _urgent => !_expired && remaining <= urgentBelow;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    final (Color foreground, IconData icon, String label) = switch ((
      _expired,
      _urgent,
    )) {
      (true, _) => (colors.danger, LucideIcons.circleAlert, 'Rate expired'),
      (_, true) => (
          colors.warning,
          LucideIcons.clock,
          'Rate held ${_format(remaining)}',
        ),
      _ => (
          colors.textSecondary,
          LucideIcons.clock,
          'Rate held ${_format(remaining)}',
        ),
    };

    return Semantics(
      liveRegion: true,
      // The visual is a ticking clock; a screen reader gets the sentence
      // it stands for, and only the state changes are worth announcing.
      label: _expired
          ? 'The exchange rate has expired. Get a new price to continue.'
          : 'Exchange rate held for ${_spoken(remaining)}.',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: foreground.withValues(alpha: 0.12),
          borderRadius: context.radii.brFull,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.sm,
            vertical: spacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: foreground),
              SizedBox(width: spacing.xs),
              Text(
                label,
                style: context.textStyles.labelSmall?.copyWith(
                  color: foreground,
                  // Tabular figures for the same reason money uses them:
                  // a countdown that reflows every second is a twitch in
                  // the corner of the eye on the one screen that most
                  // needs to feel steady.
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _format(Duration remaining) {
    final seconds = remaining.inSeconds;
    final minutes = seconds ~/ 60;
    return '$minutes:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  static String _spoken(Duration remaining) {
    final seconds = remaining.inSeconds;
    if (seconds < 60) return '$seconds seconds';
    final minutes = seconds ~/ 60;
    final rest = seconds % 60;
    final minutePart = minutes == 1 ? '1 minute' : '$minutes minutes';
    return rest == 0 ? minutePart : '$minutePart $rest seconds';
  }
}
