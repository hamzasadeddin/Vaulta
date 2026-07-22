import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/presentation/providers/transfers_providers.dart';

/// Step four: proof. Shown only after the server confirmed the transfer,
/// so every figure here is settled truth rather than an optimistic guess.
class ReceiptView extends ConsumerWidget {
  const ReceiptView({required this.onDone, super.key});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final transfer = ref.watch(transferFlowProvider).transfer;
    if (transfer == null) return const SizedBox.shrink();

    return ListView(
      padding: EdgeInsets.all(spacing.md),
      children: [
        SizedBox(height: spacing.md),
        Center(child: _StatusMark(status: transfer.status)),
        SizedBox(height: spacing.md),
        Center(
          child: Text(
            _headline(transfer),
            style: context.textStyles.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: spacing.xs),
        Center(child: BalanceText(transfer.destinationAmount)),
        SizedBox(height: spacing.lg),
        AppCard(
          child: Column(
            children: [
              _Row(label: 'To', value: transfer.destinationLabel),
              const _Divider(),
              _Row(label: 'Account', value: transfer.destinationDetail),
              const _Divider(),
              _CopyableRow(
                label: 'Reference',
                value: transfer.reference,
              ),
              const _Divider(),
              _MoneyRow(label: 'Total debited', money: transfer.totalDebit),
              if (transfer.balanceAfter case final balance?) ...[
                const _Divider(),
                _MoneyRow(label: 'New balance', money: balance),
              ],
              if (transfer.scheduledFor case final date?) ...[
                const _Divider(),
                _Row(label: 'Sends on', value: _formatDate(date)),
              ],
            ],
          ),
        ),
        SizedBox(height: spacing.lg),
        AppButton(label: 'Done', expand: true, onPressed: onDone),
      ],
    );
  }

  String _headline(Transfer transfer) => switch (transfer.status) {
        TransferStatus.completed => 'Transfer sent',
        TransferStatus.scheduled => 'Transfer scheduled',
        TransferStatus.pending => 'Transfer submitted',
        TransferStatus.failed => 'Transfer failed',
      };

  static String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

/// A drawn mark rather than a Lottie: the success state is one glyph in a
/// tinted disc, and it costs nothing to render.
class _StatusMark extends StatelessWidget {
  const _StatusMark({required this.status});

  final TransferStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (Color tint, IconData icon) = switch (status) {
      TransferStatus.completed => (colors.credit, LucideIcons.check),
      TransferStatus.scheduled => (colors.info, LucideIcons.calendar),
      TransferStatus.pending => (colors.pending, LucideIcons.clock),
      TransferStatus.failed => (colors.danger, LucideIcons.x),
    };

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Theme-role tint, never an inlined hex.
        color: tint.withValues(alpha: 0.14),
      ),
      child: Icon(icon, size: 28, color: tint),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textStyles.bodySmall?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(width: context.spacing.md),
        Expanded(
          child: Text(
            value,
            style: context.textStyles.bodyMedium,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _CopyableRow extends StatelessWidget {
  const _CopyableRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: context.textStyles.bodySmall?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: context.textStyles.bodyMedium,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          tooltip: 'Copy reference',
          visualDensity: VisualDensity.compact,
          icon: Icon(
            LucideIcons.copy,
            size: 16,
            color: context.colors.textTertiary,
          ),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: value));
            if (!context.mounted) return;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Reference copied.')),
              );
          },
        ),
      ],
    );
  }
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow({required this.label, required this.money});

  final String label;
  final Money money;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: context.textStyles.bodySmall?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        const Spacer(),
        BalanceText(money, size: MoneyTextSize.sm),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spacing.sm),
      child: Divider(height: 1, color: context.colors.border),
    );
  }
}
