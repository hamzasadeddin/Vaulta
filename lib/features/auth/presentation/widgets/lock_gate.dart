import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_providers.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_state.dart';
import 'package:vaulta/features/auth/presentation/screens/unlock_screen.dart';

/// Covers the app with the biometric gate whenever the session is [Locked].
///
/// Deliberately an overlay above the router rather than a route the router
/// redirects to. Locking used to swap the whole location, which tore down
/// the `StatefulShellRoute` and rebuilt it on unlock — and because a route
/// takes a few hundred milliseconds to animate out, the outgoing shell was
/// still mounted when the incoming one arrived. Both carry the same
/// `GlobalKey` (it lives in the stable route configuration), so that pair of
/// redirects put one key in the tree twice: the "duplicate GlobalKey" crash.
///
/// Sitting above the `Navigator` means locking changes no location at all.
/// The shell is never torn down, so there is nothing to duplicate, and it
/// also matches how a bank behaves — you come back to the screen you left,
/// not to the dashboard.
class LockGate extends ConsumerWidget {
  const LockGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locked = ref.watch(authControllerProvider) is Locked;

    return Stack(
      // Tight constraints, not the default loose ones — `child` here is the
      // app's `Navigator`, and it has to fill the screen rather than shrink
      // to its content.
      fit: StackFit.expand,
      children: [
        // The gate is opaque, so it already hides the content behind it —
        // but "behind" is only true visually. A screen reader would still
        // read the balances out, and a tab key would still reach them, so
        // the subtree is closed off explicitly while locked.
        ExcludeFocus(
          excluding: locked,
          child: ExcludeSemantics(excluding: locked, child: child),
        ),
        if (locked) const Positioned.fill(child: UnlockScreen()),
      ],
    );
  }
}
