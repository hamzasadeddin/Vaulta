import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/transfers/domain/entities/outbox_entry.dart';
import 'package:vaulta/features/transfers/presentation/failure_copy.dart';
import 'package:vaulta/features/transfers/presentation/providers/outbox_providers.dart';
import 'package:vaulta/features/transfers/presentation/transfers_paths.dart';

Future<void> showOutboxSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const OutboxSheet(),
  );
}

/// The queue, with the decision each entry is waiting on.
///
/// Every refused entry offers exactly two actions and no default, which
/// is handoff 8 §10's requirement in UI form: the app may neither
/// re-price and send at a rate the user never saw, nor quietly drop an
/// instruction they believe is on its way. Both outcomes are a tap.
class OutboxSheet extends ConsumerWidget {
  const OutboxSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final entries = switch (ref.watch(outboxControllerProvider)) {
      AsyncData(:final value) => value,
      _ => const <OutboxEntry>[],
    };

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          spacing.md,
          0,
          spacing.md,
          spacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Transfer queue',
              style: context.textStyles.titleMedium,
            ),
            SizedBox(height: spacing.sm),
            if (entries.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.lg),
                child: Text(
                  'Nothing is waiting to send.',
                  textAlign: TextAlign.center,
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
                  itemBuilder: (_, index) => _EntryTile(entry: entries[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EntryTile extends ConsumerWidget {
  const _EntryTile({required this.entry});

  final OutboxEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final snapshot = entry.snapshot;
    final attention = entry.attention;

    Future<void> discard() async {
      await ref.read(outboxControllerProvider.notifier).discard(entry.id);
    }

    Future<void> retry() async {
      await ref.read(outboxControllerProvider.notifier).retry(entry);
    }

    Future<void> acknowledge() async {
      await ref.read(outboxControllerProvider.notifier).acknowledgeSent();
    }

    // Drops the dead entry and re-enters the flow with a fresh price.
    // The entry goes first and unconditionally: its draft is already
    // gone server-side, so keeping it would leave a row pointing at a
    // transfer that can never be confirmed. Nothing has moved, so there
    // is nothing to reconcile if the user then walks away.
    Future<void> reprice() async {
      final request = entry.request;
      await discard();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      context.go(TransfersPaths.flow, extra: request);
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  snapshot.destinationLabel,
                  style: context.textStyles.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: spacing.sm),
              BalanceText(snapshot.totalDebit, size: MoneyTextSize.sm),
            ],
          ),
          SizedBox(height: spacing.xs),
          Text(
            attention != null
                ? outboxAttentionCopy(attention)
                : switch (entry.status) {
                    OutboxStatus.sent =>
                      'Sent \u00b7 ${entry.reference ?? 'confirmed'}',
                    OutboxStatus.inFlight => 'Sending\u2026',
                    OutboxStatus.pending => 'Waiting to send',
                    OutboxStatus.needsAttention => 'Needs attention',
                  },
            style: context.textStyles.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          if (attention != null) ...[
            SizedBox(height: spacing.sm),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: entry.needsReprice ? 'Get a new price' : 'Try again',
                    size: AppButtonSize.small,
                    expand: true,
                    onPressed: entry.needsReprice ? reprice : retry,
                  ),
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: AppButton(
                    label: 'Discard',
                    size: AppButtonSize.small,
                    variant: AppButtonVariant.ghost,
                    expand: true,
                    onPressed: discard,
                  ),
                ),
              ],
            ),
          ],
          if (entry.status == OutboxStatus.sent) ...[
            SizedBox(height: spacing.sm),
            AppButton(
              label: 'Done',
              size: AppButtonSize.small,
              variant: AppButtonVariant.ghost,
              expand: true,
              onPressed: acknowledge,
            ),
          ],
        ],
      ),
    );
  }
}
