import 'package:flutter/material.dart';
import 'package:vaulta/design_system/responsive/breakpoints.dart';

/// One navigation destination, rendered per breakpoint.
class AdaptiveDestination {
  const AdaptiveDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  final IconData icon;
  final IconData? selectedIcon;
  final String label;
}

/// Breakpoint-aware shell (spec §5):
/// - compact:  bottom [NavigationBar]
/// - medium:   [NavigationRail] + body
/// - expanded: extended rail + body + optional [secondaryBody] pane
///
/// The decision is made with [LayoutBuilder], so the shell adapts to split
/// screen and window resizing, not just device class.
///
/// **GlobalKey safety.** [body] typically holds a `StatefulNavigationShell`,
/// which carries its own `GlobalKey`. Such a key must never need to move
/// between parents: [LayoutBuilder] rebuilds *during layout*, so an incoming
/// subtree can be built before the outgoing one is unmounted, and for one
/// frame the key would exist twice.
///
/// So [body] is never moved. Every layout puts it at exactly
/// `Scaffold` → `Row` → third child, and the pieces that differ between
/// breakpoints collapse to zero width rather than leaving the child list.
/// Crossing a breakpoint changes only leaves — a rail appears, a bottom bar
/// goes to the `Scaffold`'s own independent slot — so the element holding
/// the key is never reparented.
///
/// **Do not wrap [body] in a `KeyedSubtree` with a `GlobalKey` here.** That
/// was tried, to make the content survive a structural swap back when the
/// two layouts nested it differently. It backfires: the key belongs to this
/// widget's `State`, so re-entering the shell route mints a fresh one, and
/// the new `KeyedSubtree` yanks the navigation shell out of the old one —
/// which, being held by a `GlobalKey` of its own, stays alive and never
/// updates. That is the "duplicate GlobalKey" crash, caused by the very
/// thing meant to prevent it. Structural invariance above is the fix, and
/// it needs no key at all, which is why this is a [StatelessWidget].
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.secondaryBody,
    this.appBar,
    this.floatingActionButton,
    super.key,
  }) : assert(destinations.length >= 2, 'Rails require >= 2 destinations');

  final List<AdaptiveDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  /// Detail pane shown side-by-side on expanded layouts (master-detail).
  final Widget? secondaryBody;

  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = Breakpoint.fromWidth(constraints.maxWidth);
        final compact = breakpoint.isCompact;
        final extended = breakpoint.isExpanded;
        final secondary = secondaryBody;
        final showSecondary = extended && secondary != null;

        return Scaffold(
          appBar: appBar,
          floatingActionButton: floatingActionButton,
          // The `Scaffold`'s slots are independent of one another, so the
          // bottom bar can come and go without disturbing the body.
          bottomNavigationBar: compact ? _navigationBar() : null,
          body: Row(
            children: [
              // Fixed five slots at every breakpoint. Anything not wanted
              // right now shrinks to nothing instead of being removed, which
              // is what keeps [body] at a constant index.
              if (compact)
                const SizedBox.shrink()
              else
                SafeArea(child: _rail(extended: extended)),
              if (compact) const SizedBox.shrink() else const VerticalDivider(),
              Expanded(flex: 5, child: body),
              if (showSecondary)
                const VerticalDivider()
              else
                const SizedBox.shrink(),
              Expanded(
                flex: showSecondary ? 4 : 0,
                child: showSecondary ? secondary : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  NavigationBar _navigationBar() {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        for (final destination in destinations)
          NavigationDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon ?? destination.icon),
            label: destination.label,
          ),
      ],
    );
  }

  NavigationRail _rail({required bool extended}) {
    return NavigationRail(
      extended: extended,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: extended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.selected,
      destinations: [
        for (final destination in destinations)
          NavigationRailDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon ?? destination.icon),
            label: Text(destination.label),
          ),
      ],
    );
  }
}
