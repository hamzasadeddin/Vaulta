import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_providers.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_state.dart';

/// Biometric gate shown over any restored or backgrounded session.
class UnlockScreen extends ConsumerStatefulWidget {
  const UnlockScreen({super.key});

  @override
  ConsumerState<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends ConsumerState<UnlockScreen> {
  var _prompting = false;

  @override
  void initState() {
    super.initState();
    // Prompt immediately on arrival; the button is the retry path.
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  Future<void> _unlock() async {
    if (_prompting) return;
    setState(() => _prompting = true);
    await ref.read(authControllerProvider.notifier).unlock();
    if (mounted) setState(() => _prompting = false);
    // On success the router leaves this screen via the state change.
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final name = state is Locked ? state.user.firstName : '';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: context.spacing.screenPadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    LucideIcons.fingerprint,
                    size: 56,
                    color: context.colors.accent,
                  ),
                  SizedBox(height: context.spacing.lg),
                  Text(
                    name.isEmpty ? 'Welcome back' : 'Welcome back, $name',
                    textAlign: TextAlign.center,
                    style: context.textStyles.headlineSmall,
                  ),
                  SizedBox(height: context.spacing.xs),
                  Text(
                    'Unlock to continue',
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodyMedium
                        ?.copyWith(color: context.colors.textSecondary),
                  ),
                  SizedBox(height: context.spacing.xl),
                  AppButton(
                    label: 'Unlock',
                    icon: LucideIcons.fingerprint,
                    size: AppButtonSize.large,
                    expand: true,
                    loading: _prompting,
                    onPressed: _unlock,
                  ),
                  SizedBox(height: context.spacing.sm),
                  AppButton(
                    label: 'Sign out',
                    variant: AppButtonVariant.ghost,
                    expand: true,
                    onPressed: () =>
                        ref.read(authControllerProvider.notifier).logout(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
