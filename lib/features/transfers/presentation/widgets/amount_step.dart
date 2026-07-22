import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
// Presentation-only cross-feature read (§6.22) — the amount is parsed in
// the source account's currency, so the step needs that account.
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/transfers/presentation/failure_copy.dart';
import 'package:vaulta/features/transfers/presentation/forms/transfer_inputs.dart';
import 'package:vaulta/features/transfers/presentation/providers/transfers_providers.dart';

/// Step two: how much, an optional note, and an optional send date.
///
/// The amount is parsed with `Money.tryParse` in the source account's
/// currency — it is never routed through a `double`, and the keyboard is
/// restricted to digits and a single separator so the parse rarely fails.
class AmountStep extends ConsumerStatefulWidget {
  const AmountStep({super.key});

  @override
  ConsumerState<AmountStep> createState() => _AmountStepState();
}

class _AmountStepState extends ConsumerState<AmountStep> {
  late final _amount = TextEditingController(
    text: ref.read(transferFlowProvider).amount.value,
  );
  late final _note = TextEditingController(
    text: ref.read(transferFlowProvider).note,
  );

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final earliest = DateTime.now().add(const Duration(days: 1));
    final chosen = ref.read(transferFlowProvider).scheduledFor;
    final picked = await showDatePicker(
      context: context,
      firstDate: earliest,
      lastDate: earliest.add(const Duration(days: 364)),
      // A date picked before midnight can fall behind `earliest` once the
      // day rolls over; showDatePicker asserts on that.
      initialDate:
          chosen != null && chosen.isAfter(earliest) ? chosen : earliest,
    );
    if (picked == null || !mounted) return;
    ref.read(transferFlowProvider.notifier).scheduleChanged(picked);
  }

  Future<void> _review() async {
    final failure =
        await ref.read(transferFlowProvider.notifier).requestQuote();
    if (failure == null || !mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(transfersFailureCopy(failure))));
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final state = ref.watch(transferFlowProvider);
    final notifier = ref.read(transferFlowProvider.notifier);
    final sourceId = state.sourceAccountId;
    final account =
        sourceId == null ? null : ref.watch(accountByIdProvider(sourceId));
    final currency = account?.currency;

    final amountError = switch (state.amount.displayError) {
      AmountValidationError.empty => 'Enter an amount',
      AmountValidationError.malformed => 'Enter a valid amount',
      AmountValidationError.notPositive => 'Must be more than zero',
      null => null,
    };

    // Local affordability check. The server re-validates and its 422 is
    // the backstop — this exists so the user is told before a round trip.
    final typed = currency == null
        ? null
        : AmountInput.dirty(state.amount.value).moneyIn(currency);
    final balance = account?.balance;
    final overBalance = typed != null && balance != null && typed > balance;

    return ListView(
      padding: EdgeInsets.all(spacing.md),
      children: [
        if (account != null)
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available',
                        style: context.textStyles.labelSmall?.copyWith(
                          color: context.colors.textTertiary,
                        ),
                      ),
                      SizedBox(height: spacing.xxs),
                      Text(
                        account.name,
                        style: context.textStyles.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                BalanceText(account.balance, size: MoneyTextSize.sm),
              ],
            ),
          ),
        SizedBox(height: spacing.md),
        AppTextField(
          label: currency == null ? 'Amount' : 'Amount (${currency.code})',
          controller: _amount,
          errorText: amountError ??
              (overBalance ? 'More than the available balance' : null),
          enabled: !state.busy,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
          ],
          onChanged: notifier.amountChanged,
        ),
        SizedBox(height: spacing.sm),
        AppTextField(
          label: 'Note (optional)',
          hint: 'Rent, dinner, …',
          controller: _note,
          enabled: !state.busy,
          onChanged: notifier.noteChanged,
        ),
        SizedBox(height: spacing.md),
        _ScheduleRow(
          date: state.scheduledFor,
          enabled: !state.busy,
          onPick: _pickDate,
          onClear: () => notifier.scheduleChanged(null),
        ),
        SizedBox(height: spacing.lg),
        AppButton(
          label: 'Review transfer',
          expand: true,
          loading: state.busy,
          onPressed: state.amount.isValid && !overBalance ? _review : null,
        ),
      ],
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({
    required this.date,
    required this.enabled,
    required this.onPick,
    required this.onClear,
  });

  final DateTime? date;
  final bool enabled;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final scheduled = date;

    return AppCard(
      onTap: enabled ? onPick : null,
      child: Row(
        children: [
          Icon(LucideIcons.calendar, size: 18, color: colors.textSecondary),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Text(
              scheduled == null
                  ? 'Send now'
                  : 'Scheduled for ${_formatDate(scheduled)}',
              style: context.textStyles.bodyMedium,
            ),
          ),
          if (scheduled != null)
            IconButton(
              onPressed: enabled ? onClear : null,
              tooltip: 'Send now instead',
              icon: Icon(LucideIcons.x, size: 16, color: colors.textTertiary),
            ),
        ],
      ),
    );
  }

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
