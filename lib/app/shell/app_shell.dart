import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/accounts/presentation/widgets/account_detail_view.dart';
import 'package:vaulta/features/transactions/presentation/widgets/transaction_detail_view.dart';

// Branch indices into the StatefulShellRoute. Accounts and transactions get a
// master-detail secondary pane on expanded layouts; home and cards do not.
const _accountsBranch = 1;
const _transactionsBranch = 2;

/// Adaptive chrome around the signed-in branches. `AdaptiveScaffold` picks
/// bottom nav / rail / extended rail from the breakpoint; this widget only
/// supplies destinations and, for the accounts and transactions branches, the
/// master-detail secondary pane (rendered by the scaffold on expanded layouts
/// only).
///
/// The `StatefulNavigationShell` carries a `GlobalKey`, so it must never be
/// handed to anything that would move it between parents. `AdaptiveScaffold`
/// guarantees that by keeping the body at one fixed position in its layout
/// at every breakpoint — with no wrapper key of its own, which previously
/// caused the duplicate-key crash it was meant to prevent. This widget
/// therefore hands the shell over directly and stays stateless.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      destinations: const [
        AdaptiveDestination(icon: LucideIcons.house, label: 'Home'),
        AdaptiveDestination(icon: LucideIcons.wallet, label: 'Accounts'),
        AdaptiveDestination(
          icon: LucideIcons.arrowLeftRight,
          label: 'Activity',
        ),
        // Branch 3 (Phase 7). No secondaryBody: the card detail is a pushed
        // route at every width (it carries a Hero, and a dual-rendered pane
        // would collide the tag — the accounts rule).
        AdaptiveDestination(icon: LucideIcons.creditCard, label: 'Cards'),
      ],
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) => navigationShell.goBranch(
        index,
        // Re-tapping the active tab pops that branch back to its root —
        // standard bottom-nav behaviour.
        initialLocation: index == navigationShell.currentIndex,
      ),
      body: navigationShell,
      secondaryBody: switch (navigationShell.currentIndex) {
        _accountsBranch => const AccountDetailPane(),
        _transactionsBranch => const TransactionDetailPane(),
        _ => null,
      },
    );
  }
}
