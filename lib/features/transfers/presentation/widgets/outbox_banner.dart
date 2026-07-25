import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/transfers/domain/entities/outbox_entry.dart';
import 'package:vaulta/features/transfers/presentation/providers/outbox_providers.dart';
import 'package:vaulta/features/transfers/presentation/widgets/outbox_sheet.dart';

/// Surfaces the transfer queue on the dashboard, and only when there is
/// one.
///
/// Renders nothing on an empty queue — which is almost every session —
/// rather than an "all clear" row. A permanent slot for a feature that
/// is normally absent trains the eye to skip exactly the thing that
/// matters on the day it appears.
///
/// Priority is severity, not recency: something refused outranks
/// something in flight, which outranks something delivered. The queue
/// never shows two banners at once.
class OutboxBanner extends ConsumerWidget {
  const OutboxBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = switch (ref.watch(outboxControllerProvider)) {
      AsyncData(:final value) => value,
      _ => const <OutboxEntry>[],
    };
    if (entries.isEmpty) return const SizedBox.shrink();

    final attention = _count(entries, OutboxStatus.needsAttention);
    final waiting = entries
        .where(
          (e) =>
              e.status == OutboxStatus.pending ||
              e.status == OutboxStatus.inFlight,
        )
        .length;
    final sent = _count(entries, OutboxStatus.sent);

    final colors = context.colors;
    final (Color tone, IconData icon, String message) = switch ((
      attention,
      waiting,
      sent,
    )) {
      (final a, _, _) when a > 0 => (
          colors.warning,
          LucideIcons.circleAlert,
          a == 1
              ? 'A transfer needs your attention'
              : '$a transfers need your attention',
        ),
      (_, final w, _) when w > 0 => (
          colors.info,
          LucideIcons.clock,
          w == 1
              ? 'A transfer is waiting to send'
              : '$w transfers are waiting to send',
        ),
      (_, _, final s) when s > 0 => (
          colors.success,
          LucideIcons.check,
          s == 1
              ? 'A queued transfer went through'
              : '$s queued transfers went through',
        ),
      _ => (colors.info, LucideIcons.clock, 'Transfer queue'),
    };

    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.md),
      child: AppCard(
        onTap: () => showOutboxSheet(context),
        child: Row(
          children: [
            Icon(icon, size: 18, color: tone),
            SizedBox(width: context.spacing.sm),
            Expanded(
              child: Text(message, style: context.textStyles.bodyMedium),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  int _count(List<OutboxEntry> entries, OutboxStatus status) =>
      entries.where((entry) => entry.status == status).length;
}
