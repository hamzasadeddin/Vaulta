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
/// which carries its own `GlobalKey`. Crossing a breakpoint swaps in a
/// structurally different `Scaffold` subtree, moving [body] to a different
/// position (direct `Scaffold.body` when compact, `Row` child in rail mode).
/// Because [LayoutBuilder] can build the incoming subtree before the outgoing
/// one is unmounted, that key could briefly exist twice in a single frame —
/// the "duplicate GlobalKey" crash. Wrapping [body] in a `KeyedSubtree` with a
/// *stable* key of our own gives the primary content one element identity that
/// Flutter reparents wholesale across the swap, instead of tearing it down and
/// rebuilding it (which is what duplicates the inner key). The key must outlive
/// rebuilds, so this is a [StatefulWidget].
class AdaptiveScaffold extends StatefulWidget {
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
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  // Stable across breakpoint swaps so the primary content (and any GlobalKey
  // it holds) is reparented, never rebuilt, when the layout changes shape.
  final GlobalKey _bodyKey = GlobalKey(debugLabel: 'adaptive-scaffold-body');

  @override
  Widget build(BuildContext context) {
    final keyedBody = KeyedSubtree(key: _bodyKey, child: widget.body);
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = Breakpoint.fromWidth(constraints.maxWidth);
        return switch (breakpoint) {
          Breakpoint.compact => _buildCompact(keyedBody),
          Breakpoint.medium => _buildWithRail(keyedBody, extended: false),
          Breakpoint.expanded => _buildWithRail(keyedBody, extended: true),
        };
      },
    );
  }

  Widget _buildCompact(Widget body) {
    return Scaffold(
      appBar: widget.appBar,
      body: body,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.selectedIndex,
        onDestinationSelected: widget.onDestinationSelected,
        destinations: [
          for (final destination in widget.destinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon ?? destination.icon),
              label: destination.label,
            ),
        ],
      ),
    );
  }

  Widget _buildWithRail(Widget body, {required bool extended}) {
    final secondary = widget.secondaryBody;
    final showSecondary = extended && secondary != null;
    return Scaffold(
      appBar: widget.appBar,
      floatingActionButton: widget.floatingActionButton,
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: extended,
              selectedIndex: widget.selectedIndex,
              onDestinationSelected: widget.onDestinationSelected,
              labelType: extended
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.selected,
              destinations: [
                for (final destination in widget.destinations)
                  NavigationRailDestination(
                    icon: Icon(destination.icon),
                    selectedIcon:
                        Icon(destination.selectedIcon ?? destination.icon),
                    label: Text(destination.label),
                  ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(flex: 5, child: body),
          // The secondary slots stay in the child list at fixed indices
          // whether or not a detail pane is shown — they simply collapse to
          // zero width when hidden. Keeping the Row's child count constant
          // means [body] never changes position, so the GlobalKey-carrying
          // navigation shell it holds is never reparented across a branch
          // switch or a pane toggle (the "duplicate GlobalKey" crash).
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
  }
}
