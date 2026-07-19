import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/presentation/failure_copy.dart';
import 'package:vaulta/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:vaulta/features/transactions/presentation/transactions_paths.dart';
import 'package:vaulta/features/transactions/presentation/widgets/transaction_filter_bar.dart';
import 'package:vaulta/features/transactions/presentation/widgets/transaction_tile.dart';
import 'package:vaulta/features/transactions/presentation/widgets/transactions_skeleton.dart';

/// Infinite, filterable feed across all accounts. Opening an entry adapts
/// to the layout: compact/medium pushes the receipt route; expanded
/// selects into the side-by-side pane rendered by the shell.
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({this.initialAccountId, super.key});

  /// Pre-focuses the feed on one account (the `?account=` deep link used
  /// by "View transactions" on an account's detail surface).
  final String? initialAccountId;

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_maybeLoadMore);
    final accountId = widget.initialAccountId;
    if (accountId != null) {
      // Providers cannot be written during build; a microtask lands the
      // focus right after the first frame and the feed reloads reactively.
      unawaited(
        Future<void>.microtask(() {
          if (!mounted) return;
          ref
              .read(transactionsFilterControllerProvider.notifier)
              .focusAccount(accountId);
        }),
      );
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _maybeLoadMore() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.extentAfter > 400) return;
    unawaited(
      ref.read(transactionsFeedControllerProvider.notifier).loadMore(),
    );
  }

  Future<void> _refresh() async {
    final failure =
        await ref.read(transactionsFeedControllerProvider.notifier).refresh();
    if (failure == null || !mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(transactionsFailureCopy(failure))));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionsFeedControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: SafeArea(
        child: switch (state) {
          AsyncData(:final value) => _Feed(
              feed: value,
              scroll: _scroll,
              onRefresh: _refresh,
            ),
          AsyncError(:final error) => _LoadFailed(error: error),
          _ => const TransactionsSkeleton(),
        },
      ),
    );
  }
}

class _Feed extends StatelessWidget {
  const _Feed({
    required this.feed,
    required this.scroll,
    required this.onRefresh,
  });

  final TransactionsFeed feed;
  final ScrollController scroll;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final rows = _buildRows(feed.items);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        controller: scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              spacing.md,
              spacing.md,
              spacing.md,
              0,
            ),
            sliver: const SliverToBoxAdapter(
              child: _Centered(child: TransactionFilterBar()),
            ),
          ),
          if (feed.items.isEmpty)
            SliverPadding(
              padding: EdgeInsets.all(spacing.md),
              sliver: const SliverToBoxAdapter(
                child: _Centered(child: _EmptyFeed()),
              ),
            )
          else ...[
            SliverPadding(
              padding: EdgeInsets.all(spacing.md),
              // Lazily built — only visible rows materialize, so a long
              // paged session stays cheap.
              sliver: SliverList.builder(
                itemCount: rows.length,
                itemBuilder: (context, index) => _Centered(
                  child: _FeedRowView(row: rows[index], index: index),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                spacing.md,
                0,
                spacing.md,
                spacing.md,
              ),
              sliver: SliverToBoxAdapter(
                child: _Centered(child: _FeedFooter(feed: feed)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<_FeedRow> _buildRows(List<Transaction> items) {
    final rows = <_FeedRow>[];
    DateTime? lastDay;
    for (final txn in items) {
      final day = DateTime(
        txn.occurredAt.year,
        txn.occurredAt.month,
        txn.occurredAt.day,
      );
      if (day != lastDay) {
        rows.add(_FeedRow.header(_dayLabel(day)));
        lastDay = day;
      }
      rows.add(_FeedRow.transaction(txn));
    }
    return rows;
  }

  String _dayLabel(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (day == today) return 'Today';
    if (day == today.subtract(const Duration(days: 1))) return 'Yesterday';
    if (day.year == today.year) return DateFormat('EEE, MMM d').format(day);
    return DateFormat('MMM d, y').format(day);
  }
}

/// Centers feature content at the standard 640px column.
class _Centered extends StatelessWidget {
  const _Centered({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: child,
      ),
    );
  }
}

class _FeedRowView extends ConsumerWidget {
  const _FeedRowView({required this.row, required this.index});

  final _FeedRow row;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final expanded = context.breakpoint.isExpanded;
    final selectedId = expanded ? ref.watch(paneTransactionIdProvider) : null;

    return switch (row) {
      _HeaderRow(:final label) => Padding(
          padding: EdgeInsets.only(
            top: index == 0 ? 0 : spacing.md,
            bottom: spacing.xs,
          ),
          child: Text(
            label,
            style: context.textStyles.labelSmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
      _TransactionRow(:final transaction) => _Staggered(
          index: index,
          child: TransactionTile(
            transaction: transaction,
            selected: transaction.id == selectedId,
            onTap: () => _open(context, ref, transaction.id),
          ),
        ),
    };
  }

  void _open(BuildContext context, WidgetRef ref, String transactionId) {
    if (context.breakpoint.isExpanded) {
      ref.read(paneTransactionIdProvider.notifier).select(transactionId);
    } else {
      context.go(TransactionsPaths.detail(transactionId));
    }
  }
}

/// End-of-list surface: spinner while a page loads, retry when appending
/// failed, and a quiet caption once the feed is exhausted.
class _FeedFooter extends ConsumerWidget {
  const _FeedFooter({required this.feed});

  final TransactionsFeed feed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final failure = feed.loadMoreFailure;
    if (feed.isLoadingMore) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (failure != null) {
      return Column(
        children: [
          Text(
            transactionsFailureCopy(failure),
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.spacing.xs),
          AppButton(
            label: 'Load more',
            variant: AppButtonVariant.ghost,
            size: AppButtonSize.small,
            onPressed: () => ref
                .read(transactionsFeedControllerProvider.notifier)
                .loadMore(),
          ),
        ],
      );
    }
    if (!feed.hasMore && feed.items.isNotEmpty) {
      return Center(
        child: Text(
          'That\u2019s everything.',
          style: context.textStyles.labelSmall?.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _EmptyFeed extends ConsumerWidget {
  const _EmptyFeed();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final filterActive =
        ref.watch(transactionsFilterControllerProvider).isActive;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xl),
      child: Column(
        children: [
          Icon(
            LucideIcons.receipt,
            size: 32,
            color: context.colors.textTertiary,
          ),
          SizedBox(height: spacing.sm),
          Text(
            filterActive
                ? 'No transactions match your filters'
                : 'No transactions yet',
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (filterActive) ...[
            SizedBox(height: spacing.md),
            AppButton(
              label: 'Clear filters',
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.small,
              onPressed: () => ref
                  .read(transactionsFilterControllerProvider.notifier)
                  .clear(),
            ),
          ],
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
              transactionsFailureCopy(error),
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.md),
            AppButton(
              label: 'Try again',
              variant: AppButtonVariant.secondary,
              onPressed: () => ref
                  .read(transactionsFeedControllerProvider.notifier)
                  .refresh(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Staggered list entry (dashboard/accounts pattern): capped delay so the
/// total stays ≤300ms and `pumpAndSettle` terminates.
class _Staggered extends StatelessWidget {
  const _Staggered({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final delayMs = math.min(index * 30, 120);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 180 + delayMs),
      curve: Interval(
        delayMs / (180 + delayMs),
        1,
        curve: Curves.easeOutCubic,
      ),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - value)),
          child: child,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: context.spacing.xs),
        child: child,
      ),
    );
  }
}

sealed class _FeedRow {
  const _FeedRow();

  const factory _FeedRow.header(String label) = _HeaderRow;

  const factory _FeedRow.transaction(Transaction transaction) = _TransactionRow;
}

final class _HeaderRow extends _FeedRow {
  const _HeaderRow(this.label);

  final String label;
}

final class _TransactionRow extends _FeedRow {
  const _TransactionRow(this.transaction);

  final Transaction transaction;
}
