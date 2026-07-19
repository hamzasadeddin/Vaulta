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
        return switch (breakpoint) {
          Breakpoint.compact => _buildCompact(),
          Breakpoint.medium => _buildWithRail(extended: false),
          Breakpoint.expanded => _buildWithRail(extended: true),
        };
      },
    );
  }

  Widget _buildCompact() {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: NavigationBar(
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
      ),
    );
  }

  Widget _buildWithRail({required bool extended}) {
    final secondary = secondaryBody;
    final showSecondary = extended && secondary != null;
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
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
