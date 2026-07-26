import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/fraud/domain/entities/fraud_alert.dart';
import 'package:vaulta/features/fraud/presentation/failure_copy.dart';
import 'package:vaulta/features/fraud/presentation/providers/fraud_providers.dart';

Future<void> showFraudAlertSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const FraudAlertSheet(),
  );
}

/// The alerts, each with the two decisions it's waiting on: freeze the
/// card, or say it was you. Mirrors `OutboxSheet` — a per-item card, two
/// actions, no default. Dismissed alerts have already dropped from the
/// list; what remains is either awaiting a decision or a freeze
/// confirmation held until acknowledged.
class FraudAlertSheet extends ConsumerWidget {
  const FraudAlertSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final alerts = switch (ref.watch(fraudAlertControllerProvider)) {
      AsyncData(:final value) => value,
      _ => const <FraudAlert>[],
    };

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(spacing.md, 0, spacing.md, spacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Suspicious activity', style: context.textStyles.titleMedium),
            SizedBox(height: spacing.sm),
            if (alerts.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.lg),
                child: Text(
                  'Nothing needs your attention.',
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
                  itemCount: alerts.length,
                  separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
                  itemBuilder: (_, index) => _AlertTile(alert: alerts[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AlertTile extends ConsumerWidget {
  const _AlertTile({required this.alert});

  final FraudAlert alert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final headerIcon =
        alert.wasFrozen ? LucideIcons.snowflake : LucideIcons.circleAlert;
    final headerColor = alert.wasFrozen ? colors.info : colors.danger;

    Future<void> dismiss() =>
        ref.read(fraudAlertControllerProvider.notifier).dismiss(alert.id);

    Future<void> freeze() async {
      final failure =
          await ref.read(fraudAlertControllerProvider.notifier).freezeCard(
                alert,
              );
      if (!context.mounted) return;
      if (failure != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(fraudFreezeFailureCopy(failure))),
          );
      }
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(headerIcon, size: 18, color: headerColor),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Text(
                  '${alert.cardLabel} \u00b7 ${alert.merchant}',
                  style: context.textStyles.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: spacing.sm),
              BalanceText(alert.amount, size: MoneyTextSize.sm),
            ],
          ),
          SizedBox(height: spacing.xs),
          Text(
            alert.wasFrozen
                ? 'Card frozen \u2014 no more payments will go through until '
                    'you unfreeze it.'
                : fraudReasonCopy(alert),
            style: context.textStyles.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: spacing.sm),
          if (alert.isActive)
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Freeze card',
                    icon: LucideIcons.snowflake,
                    variant: AppButtonVariant.danger,
                    size: AppButtonSize.small,
                    expand: true,
                    onPressed: freeze,
                  ),
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: AppButton(
                    label: 'This was me',
                    variant: AppButtonVariant.ghost,
                    size: AppButtonSize.small,
                    expand: true,
                    onPressed: dismiss,
                  ),
                ),
              ],
            )
          else
            AppButton(
              label: 'Dismiss',
              variant: AppButtonVariant.ghost,
              size: AppButtonSize.small,
              expand: true,
              onPressed: dismiss,
            ),
        ],
      ),
    );
  }
}
