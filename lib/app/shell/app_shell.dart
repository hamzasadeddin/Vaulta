import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/accounts/presentation/widgets/account_detail_view.dart';
import 'package:vaulta/features/transactions/presentation/widgets/transaction_detail_view.dart';

/// Adaptive chrome around the signed-in branches. `AdaptiveScaffold` picks
/// bottom nav / rail / extended rail from the breakpoint; this widget only
/// supplies destinations and, for the accounts and transactions branches,
/// the master-detail secondary pane (rendered by the scaffold on expanded
/// layouts only).
///
/// `AdaptiveScaffold` returns a *different* `Scaffold` subtree per breakpoint,
/// so crossing a breakpoint tears down one subtree and builds another in the
/// same frame. Because `StatefulNavigationShell` carries a `GlobalKey`,
/// Flutter would try to reparent it and briefly see it mounted in both the
/// outgoing and incoming subtrees — the "duplicate GlobalKey" crash. Wrapping
/// the shell in a `KeyedSubtree` with a stable key of our own makes Flutter
/// match and reuse the *whole* wrapper element across the swap, moving the
/// shell wholesale instead of reparenting its inner key. The key must outlive
/// rebuilds, so this is a `StatefulWidget` (a key field on a `StatelessWidget`
/// is recreated every build and wouldn't help).
class AppShell extends StatefulWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _accountsBranch = 1;
  static const _transactionsBranch = 2;

  final GlobalKey<State<StatefulWidget>> _bodyKey =
      GlobalKey(debugLabel: 'app-shell-body');

  @override
  Widget build(BuildContext context) {
    final navigationShell = widget.navigationShell;
    return AdaptiveScaffold(
      destinations: const [
        AdaptiveDestination(icon: LucideIcons.house, label: 'Home'),
        AdaptiveDestination(icon: LucideIcons.wallet, label: 'Accounts'),
        AdaptiveDestination(
          icon: LucideIcons.arrowLeftRight,
          label: 'Activity',
        ),
      ],
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) => navigationShell.goBranch(
        index,
        // Re-tapping the active tab pops that branch back to its root —
        // standard bottom-nav behaviour.
        initialLocation: index == navigationShell.currentIndex,
      ),
      body: KeyedSubtree(key: _bodyKey, child: navigationShell),
      secondaryBody: switch (navigationShell.currentIndex) {
        _accountsBranch => const AccountDetailPane(),
        _transactionsBranch => const TransactionDetailPane(),
        _ => null,
      },
    );
  }
}
