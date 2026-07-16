import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/auth/domain/entities/user.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_providers.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_state.dart';

/// Authenticated landing. Replaced by the real Dashboard in Phase 4.
class PlaceholderHome extends ConsumerWidget {
  const PlaceholderHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final user = state is Authenticated ? state.user : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaulta'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(LucideIcons.logOut, size: 20),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(context.spacing.md),
        children: [
          Text(
            user == null ? 'Welcome' : 'Welcome, ${user.firstName}',
            style: context.textStyles.headlineSmall,
          ),
          SizedBox(height: context.spacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total balance',
                        style: context.textStyles.labelMedium,
                      ),
                    ),
                    if (user != null)
                      StatusBadge(
                        label: user.kycStatus.name.toUpperCase(),
                        kind: switch (user.kycStatus) {
                          KycStatus.verified => StatusKind.success,
                          KycStatus.pending => StatusKind.pending,
                          KycStatus.rejected => StatusKind.failed,
                        },
                      ),
                  ],
                ),
                SizedBox(height: context.spacing.sm),
                BalanceText(Money.parse('12480.50', Currency.usd)),
                SizedBox(height: context.spacing.xs),
                Text(
                  'Dashboard arrives in Phase 4',
                  style: context.textStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
