import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulta/app/router/app_router.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_providers.dart';
import 'package:vaulta/features/auth/presentation/widgets/lock_gate.dart';

/// Root widget. Owns the router and the auto-lock lifecycle hook.
class VaultaApp extends ConsumerStatefulWidget {
  const VaultaApp({super.key});

  @override
  ConsumerState<VaultaApp> createState() => _VaultaAppState();
}

class _VaultaAppState extends ConsumerState<VaultaApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Auto-lock the moment the app leaves the foreground (spec §1 auth).
    // onHide covers both backgrounding and window minimize; the router
    // reacts to the Locked state and shows the unlock gate.
    _lifecycle = AppLifecycleListener(
      onHide: () => ref.read(authControllerProvider.notifier).lock(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vaulta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      // Dark-first brand; a user-facing toggle ships with Profile.
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(appRouterProvider),
      // Above the `Navigator`, so locking covers whatever is on screen
      // instead of navigating away from it. See `LockGate`.
      builder: (context, child) =>
          LockGate(child: child ?? const SizedBox.shrink()),
    );
  }
}
