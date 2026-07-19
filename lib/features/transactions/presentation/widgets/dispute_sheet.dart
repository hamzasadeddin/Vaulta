import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulta/core/money/money_formatter.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/domain/usecases/transactions_usecases.dart';
import 'package:vaulta/features/transactions/presentation/failure_copy.dart';
import 'package:vaulta/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:vaulta/features/transactions/presentation/widgets/transaction_visuals.dart';

/// Opens the dispute entry point for [transaction] as a modal sheet.
Future<void> showDisputeSheet(
  BuildContext context,
  Transaction transaction,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => DisputeSheet(transaction: transaction),
  );
}

/// Pick-a-reason dispute form. Submits through the repository so the flow
/// exercises the full pipeline; success pops the sheet and surfaces the
/// bank's dispute reference in a snackbar.
class DisputeSheet extends ConsumerStatefulWidget {
  const DisputeSheet({required this.transaction, super.key});

  final Transaction transaction;

  @override
  ConsumerState<DisputeSheet> createState() => _DisputeSheetState();
}

class _DisputeSheetState extends ConsumerState<DisputeSheet> {
  DisputeReason _reason = DisputeReason.unauthorized;
  var _submitting = false;

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    final result = await SubmitDispute(
      ref.read(transactionsRepositoryProvider),
    ).call(
      SubmitDisputeParams(
        transactionId: widget.transaction.id,
        reason: _reason,
      ),
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    final messenger = ScaffoldMessenger.of(context);
    result.fold(
      onSuccess: (receipt) {
        Navigator.of(context).pop();
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'Dispute submitted \u2014 reference ${receipt.id}. '
                'We\u2019ll be in touch.',
              ),
            ),
          );
      },
      onFailure: (failure) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'Couldn\u2019t submit the dispute. '
                '${transactionsFailureCopy(failure)}',
              ),
            ),
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

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
            Text(
              'What went wrong?',
              style: context.textStyles.titleMedium,
            ),
            SizedBox(height: spacing.xs),
            Text(
              '${widget.transaction.title} \u00b7 '
              '${widget.transaction.amount.format()}',
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.sm),
            // RadioGroup (the 3.3x API) — per-tile groupValue/onChanged is
            // deprecated on current stable.
            RadioGroup<DisputeReason>(
              groupValue: _reason,
              onChanged: _submitting
                  ? (_) {}
                  : (value) => setState(
                        () => _reason = value ?? DisputeReason.other,
                      ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final reason in DisputeReason.values)
                    RadioListTile<DisputeReason>(
                      value: reason,
                      title: Text(reason.label),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                ],
              ),
            ),
            SizedBox(height: spacing.md),
            AppButton(
              label: 'Submit dispute',
              loading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
