import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_providers.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_state.dart';
import 'package:vaulta/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:vaulta/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:vaulta/features/dashboard/presentation/widgets/balance_card.dart';
import 'package:vaulta/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:vaulta/features/dashboard/presentation/widgets/quick_actions.dart';
import 'package:vaulta/features/dashboard/presentation/widgets/recent_activity.dart';

/// Authenticated landing screen: balance card, quick actions, and recent
/// activity, with pull-to-refresh and skeleton loading.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);
    final auth = ref.watch(authControllerProvider);
    final user = switch (auth) {
      Authenticated(:final user) || Locked(:final user) => user,
      _ => null,
    };
    final greeting = _greeting(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(user == null ? greeting : '$greeting, ${user.firstName}'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(LucideIcons.logOut, size: 20),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: switch (state) {
          AsyncData(:final value) => _Loaded(summary: value),
          AsyncError(:final error) => _LoadFailed(error: error),
          _ => const DashboardSkeleton(),
        },
      ),
    );
  }
}

class _Loaded extends ConsumerWidget {
  const _Loaded({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final selectedId = ref.watch(selectedAccountIdProvider);
    final account = summary.accountById(selectedId) ?? summary.primaryAccount;

    return RefreshIndicator(
      onRefresh: () async {
        final failure =
            await ref.read(dashboardControllerProvider.notifier).refresh();
        if (failure != null && context.mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(_failureCopy(failure))));
        }
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing.md),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (account != null) ...[
                    BalanceCard(
                      accounts: summary.accounts,
                      selected: account,
                      onSelect:
                          ref.read(selectedAccountIdProvider.notifier).select,
                    ),
                    SizedBox(height: spacing.lg),
                  ],
                  const QuickActions(),
                  SizedBox(height: spacing.lg),
                  RecentActivity(transactions: summary.recentTransactions),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadFailed extends ConsumerWidget {
  const _LoadFailed({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.cloudOff,
              size: 40,
              color: context.colors.textTertiary,
            ),
            SizedBox(height: spacing.md),
            Text(
              'Couldn\u2019t load your dashboard',
              style: context.textStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.xs),
            Text(
              _failureCopy(error),
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.lg),
            AppButton(
              label: 'Try again',
              onPressed: () =>
                  ref.read(dashboardControllerProvider.notifier).refresh(),
            ),
          ],
        ),
      ),
    );
  }
}

String _greeting(DateTime now) {
  if (now.hour < 12) return 'Good morning';
  if (now.hour < 18) return 'Good afternoon';
  return 'Good evening';
}

String _failureCopy(Object failure) => switch (failure) {
      NetworkFailure() ||
      TimeoutFailure() =>
        'Can\u2019t reach Vaulta. Check your connection.',
      AuthFailure() => 'Your session has expired. Please sign in again.',
      ServerFailure() =>
        'Vaulta is having trouble right now. Try again shortly.',
      _ => 'Something went wrong. Please try again.',
    };
