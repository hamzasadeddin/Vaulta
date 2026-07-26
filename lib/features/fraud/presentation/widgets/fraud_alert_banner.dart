import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/fraud/domain/entities/fraud_alert.dart';
import 'package:vaulta/features/fraud/presentation/providers/fraud_providers.dart';
import 'package:vaulta/features/fraud/presentation/widgets/fraud_alert_sheet.dart';

/// Surfaces suspected-fraud alerts on the dashboard, and only when there
/// are any.
///
/// Sits above the outbox banner: a card that may be compromised outranks
/// a transfer that hasn't sent. Like the outbox banner it renders nothing
/// on an empty list — a permanent "no fraud" row would train the eye to
/// skip the one row that ever matters. Tone is severity: an unanswered
/// alert is danger; a freeze the user hasn't acknowledged is reassurance.
class FraudAlertBanner extends ConsumerWidget {
  const FraudAlertBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = switch (ref.watch(fraudAlertControllerProvider)) {
      AsyncData(:final value) => value,
      _ => const <FraudAlert>[],
    };
    if (alerts.isEmpty) return const SizedBox.shrink();

    final active = alerts.where((a) => a.isActive).length;
    final frozen = alerts.where((a) => a.wasFrozen).length;

    final colors = context.colors;
    final (Color tone, IconData icon, String message) = switch ((
      active,
      frozen,
    )) {
      (final a, _) when a > 0 => (
          colors.danger,
          LucideIcons.circleAlert,
          a == 1
              ? 'Check a suspicious payment on your card'
              : 'Check $a suspicious payments on your cards',
        ),
      (_, final f) when f > 0 => (
          colors.info,
          LucideIcons.snowflake,
          f == 1
              ? 'Card frozen after a fraud alert'
              : '$f cards frozen after fraud alerts',
        ),
      _ => (colors.danger, LucideIcons.circleAlert, 'Suspicious activity'),
    };

    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.md),
      child: AppCard(
        onTap: () => showFraudAlertSheet(context),
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
}
