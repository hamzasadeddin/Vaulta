import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/transfers/presentation/failure_copy.dart';
import 'package:vaulta/features/transfers/presentation/providers/transfers_providers.dart';
import 'package:vaulta/features/transfers/presentation/widgets/quote_countdown.dart';

/// Step three: the server's priced quote, then a single irreversible tap.
///
/// The confirm is pessimistic — the button stays in its loading state
/// until the server answers, and only then does the receipt appear. It is
/// also its own double-tap guard: the controller ignores a second confirm
/// while one is in flight, and the quote's idempotency key means even a
/// transport-level retry lands on the same transfer.
///
/// Cross-currency quotes arrive with a price lock. When it runs out the
/// confirm is replaced rather than merely disabled — a dead price is not
/// a button the user should be able to look at and wonder about, and the
/// only honest next action is to ask for a new one.
class ReviewStep extends ConsumerWidget {
  const ReviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final state = ref.watch(transferFlowProvider);
    final quote = state.quote;
    if (quote == null) return const SizedBox.shrink();

    void report(Object? failure) {
      if (failure == null || !context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(transfersFailureCopy(failure))),
        );
    }

    Future<void> confirm() async =>
        report(await ref.read(transferFlowProvider.notifier).confirm());

    Future<void> requote() async =>
        report(await ref.read(transferFlowProvider.notifier).refreshQuote());

    return ListView(
      padding: EdgeInsets.all(spacing.md),
      children: [
        Center(
          child: Column(
            children: [
              Text(
                quote.isCrossCurrency ? 'They receive' : 'Sending',
                style: context.textStyles.labelSmall?.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
              SizedBox(height: spacing.xs),
              BalanceText(quote.destinationAmount),
              if (state.quoteRemaining case final remaining?) ...[
                SizedBox(height: spacing.sm),
                QuoteCountdown(remaining: remaining),
              ],
            ],
          ),
        ),
        SizedBox(height: spacing.lg),
        AppCard(
          child: Column(
            children: [
              _Row(label: 'To', value: quote.destinationLabel),
              const _Divider(),
              _Row(label: 'Account', value: quote.destinationDetail),
              const _Divider(),
              _MoneyRow(label: 'Amount', money: quote.amount),
              const _Divider(),
              _MoneyRow(label: 'Fee', money: quote.fee),
              if (quote.isCrossCurrency) ...[
                const _Divider(),
                _Row(
                  label: 'Rate',
                  value: '1 ${quote.amount.currency.code} = '
                      '${quote.rate ?? '—'} '
                      '${quote.destinationAmount.currency.code}',
                ),
              ],
              const _Divider(),
              _MoneyRow(
                label: 'Total debited',
                money: quote.totalDebit,
                emphasized: true,
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.md),
        if (state.quoteExpired)
          const _Notice(
            text: 'This rate is no longer available. Nothing has left your '
                'account \u2014 get a new price to see the current amount.',
          )
        else if (quote.isScheduled)
          const _Notice(
            text: 'This transfer is scheduled. Nothing leaves your account '
                'until then.',
          )
        else
          const _Notice(
            text: 'Check the details \u2014 a sent transfer can\u2019t be '
                'undone.',
          ),
        SizedBox(height: spacing.lg),
        // No icon on the re-quote button: every Lucide glyph that reads as
        // "refresh" would be new to this codebase, and a missing glyph is
        // a release risk for a label that is already unambiguous.
        if (state.quoteExpired)
          AppButton(
            label: 'Get a new price',
            expand: true,
            loading: state.busy,
            onPressed: requote,
          )
        else
          AppButton(
            label: quote.isScheduled ? 'Schedule transfer' : 'Confirm and send',
            expand: true,
            loading: state.busy,
            onPressed: confirm,
          ),
      ],
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

class _MoneyRow extends StatelessWidget {
  const _MoneyRow({
    required this.label,
    required this.money,
    this.emphasized = false,
  });

  final String label;
  final Money money;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: context.textStyles.bodySmall?.copyWith(
            color: emphasized
                ? context.colors.textPrimary
                : context.colors.textSecondary,
          ),
        ),
        const Spacer(),
        BalanceText(
          money,
          size: emphasized ? MoneyTextSize.md : MoneyTextSize.sm,
        ),
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

class _Notice extends StatelessWidget {
  const _Notice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: context.textStyles.bodySmall?.copyWith(
        color: context.colors.textTertiary,
      ),
    );
  }
}
