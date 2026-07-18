import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/presentation/accounts_paths.dart';
import 'package:vaulta/features/accounts/presentation/failure_copy.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/accounts/presentation/widgets/account_tile.dart';
import 'package:vaulta/features/accounts/presentation/widgets/accounts_skeleton.dart';

/// Multi-currency account list. Opening an account adapts to the layout:
/// compact/medium pushes the detail route; expanded selects into the
/// side-by-side pane rendered by the shell.
///
/// Deliberately no cross-currency total — summing USD + EUR + JOD without
/// an FX rate would be a lie, so the list refuses to tell it.
class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      body: SafeArea(
        child: switch (state) {
          AsyncData(:final value) => _AccountsList(accounts: value),
          AsyncError(:final error) => _LoadFailed(error: error),
          _ => const AccountsSkeleton(),
        },
      ),
    );
  }
}

class _AccountsList extends ConsumerWidget {
  const _AccountsList({required this.accounts});

  final List<Account> accounts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final expanded = context.breakpoint.isExpanded;
    final selectedId = expanded ? ref.watch(paneAccountIdProvider) : null;

    return RefreshIndicator(
      onRefresh: () => _refresh(context, ref),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing.md),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: accounts.isEmpty
                  ? const _EmptyAccounts()
                  : Column(
                      children: [
                        for (final (index, account) in accounts.indexed) ...[
                          if (index != 0) SizedBox(height: spacing.sm),
                          _Staggered(
                            index: index,
                            child: AccountTile(
                              account: account,
                              selected: account.id == selectedId,
                              onTap: () => _open(context, ref, account),
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, WidgetRef ref, Account account) {
    if (context.breakpoint.isExpanded) {
      ref.read(paneAccountIdProvider.notifier).select(account.id);
    } else {
      context.go(AccountsPaths.detail(account.id));
    }
  }

  Future<void> _refresh(BuildContext context, WidgetRef ref) async {
    final failure =
        await ref.read(accountsControllerProvider.notifier).refresh();
    if (failure == null || !context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(accountsFailureCopy(failure))));
  }
}

class _EmptyAccounts extends StatelessWidget {
  const _EmptyAccounts();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Icon(
            LucideIcons.wallet,
            size: 28,
            color: context.colors.textTertiary,
          ),
          SizedBox(height: context.spacing.sm),
          Text(
            'No accounts yet',
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.textSecondary,
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
              size: 32,
              color: context.colors.textTertiary,
            ),
            SizedBox(height: spacing.sm),
            Text(
              'Couldn\u2019t load your accounts',
              style: context.textStyles.titleMedium,
            ),
            SizedBox(height: spacing.xs),
            Text(
              accountsFailureCopy(error),
              textAlign: TextAlign.center,
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.md),
            AppButton(
              label: 'Try again',
              onPressed: () =>
                  ref.read(accountsControllerProvider.notifier).refresh(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Same restrained entry animation as the dashboard feed: ≤300ms total,
/// finite (so `pumpAndSettle` terminates), fade + 12px rise.
class _Staggered extends StatelessWidget {
  const _Staggered({required this.index, required this.child});

  final int index;
  final Widget child;

  static const _rise = 12.0;

  @override
  Widget build(BuildContext context) {
    final delayMs = math.min(index * 30, 120);
    final totalMs = 180 + delayMs;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: totalMs),
      curve: Interval(delayMs / totalMs, 1, curve: Curves.easeOutCubic),
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, _rise * (1 - t)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
