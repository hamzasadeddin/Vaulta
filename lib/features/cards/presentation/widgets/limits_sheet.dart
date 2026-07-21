import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';
import 'package:vaulta/features/cards/presentation/failure_copy.dart';
import 'package:vaulta/features/cards/presentation/providers/cards_providers.dart';

/// Opens the spending-limits editor for [card] as a modal sheet.
Future<void> showLimitsSheet(BuildContext context, BankCard card) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => LimitsSheet(card: card),
  );
}

/// Edits the daily and monthly spending limits. Amounts parse through
/// [Money.tryParse] — text never becomes a `double` on the way to the
/// wire. Local validation mirrors the server's rules (positive,
/// daily ≤ monthly) so the 422 path is a backstop, not the UX.
class LimitsSheet extends ConsumerStatefulWidget {
  const LimitsSheet({required this.card, super.key});

  final BankCard card;

  @override
  ConsumerState<LimitsSheet> createState() => _LimitsSheetState();
}

class _LimitsSheetState extends ConsumerState<LimitsSheet> {
  late final _daily = TextEditingController(
    text: widget.card.limits.daily.amount.toString(),
  );
  late final _monthly = TextEditingController(
    text: widget.card.limits.monthly.amount.toString(),
  );

  String? _dailyError;
  String? _monthlyError;
  var _submitting = false;

  @override
  void dispose() {
    _daily.dispose();
    _monthly.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final currency = widget.card.limits.daily.currency;
    final daily = Money.tryParse(_daily.text, currency);
    final monthly = Money.tryParse(_monthly.text, currency);

    setState(() {
      _dailyError = daily == null
          ? 'Enter an amount'
          : (daily.isPositive ? null : 'Must be more than zero');
      _monthlyError = monthly == null
          ? 'Enter an amount'
          : (monthly.isPositive ? null : 'Must be more than zero');
      if (_dailyError == null && _monthlyError == null && daily! > monthly!) {
        _dailyError = 'Daily can\u2019t exceed the monthly limit';
      }
    });
    if (_dailyError != null || _monthlyError != null) return;

    setState(() => _submitting = true);
    final failure = await ref
        .read(cardsControllerProvider.notifier)
        .updateLimits(cardId: widget.card.id, daily: daily!, monthly: monthly!);
    if (!mounted) return;
    setState(() => _submitting = false);

    final messenger = ScaffoldMessenger.of(context);
    if (failure == null) {
      Navigator.of(context).pop();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Limits updated.')));
    } else {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(cardsFailureCopy(failure))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final symbol = widget.card.limits.daily.currency.symbol;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: spacing.md,
          right: spacing.md,
          top: spacing.md,
          bottom: spacing.md + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Spending limits', style: context.textStyles.titleMedium),
            SizedBox(height: spacing.xs),
            Text(
              '${widget.card.label} \u00b7 amounts in $symbol',
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.md),
            AppTextField(
              label: 'Daily limit',
              controller: _daily,
              errorText: _dailyError,
              enabled: !_submitting,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
              ],
            ),
            SizedBox(height: spacing.sm),
            AppTextField(
              label: 'Monthly limit',
              controller: _monthly,
              errorText: _monthlyError,
              enabled: !_submitting,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
              ],
            ),
            SizedBox(height: spacing.md),
            AppButton(
              label: 'Save limits',
              loading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
