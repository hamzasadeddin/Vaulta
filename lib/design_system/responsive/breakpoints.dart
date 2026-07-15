import 'package:flutter/widgets.dart';

/// Intent-based breakpoints (spec §5). Layout *changes shape* at these
/// widths — never scale sizes by MediaQuery multipliers.
enum Breakpoint {
  /// `< 600` — phones. Bottom navigation.
  compact,

  /// `600–1024` — small tablets / split screen. Nav rail + list/detail.
  medium,

  /// `> 1024` — large tablets / desktop. Extended rail + multi-pane.
  expanded;

  static const double mediumMin = 600;
  static const double expandedMin = 1024;

  static Breakpoint fromWidth(double width) {
    if (width < mediumMin) return Breakpoint.compact;
    if (width <= expandedMin) return Breakpoint.medium;
    return Breakpoint.expanded;
  }

  static Breakpoint of(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);

  bool get isCompact => this == Breakpoint.compact;

  bool get isMedium => this == Breakpoint.medium;

  bool get isExpanded => this == Breakpoint.expanded;
}

extension BreakpointContextX on BuildContext {
  Breakpoint get breakpoint => Breakpoint.of(this);
}
