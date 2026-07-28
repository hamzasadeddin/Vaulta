import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/money/money_formatter.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';
import 'package:vaulta/features/savings/presentation/providers/pots_providers.dart';
import 'package:vaulta/features/savings/presentation/savings_paths.dart';
import 'package:vaulta/features/savings/presentation/widgets/pot_progress.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/presentation/transfers_paths.dart';

/// A single pot: balance, goal progress, and the two money movements a pot
/// offers — add and withdraw. Both hand off to the transfer flow, so the
/// pot screen never prices or confirms money itself (§12.2).
class PotDetailScreen extends ConsumerWidget {
  const PotDetailScreen({required this.potId, super.key});

  final String potId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(potsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => _leave(context),
        ),
        title: const Text('Pot'),
      ),
      body: SafeArea(
        child: switch (state) {
          AsyncData(:final value) => switch (_resolve(value)) {
              final pot? => _PotDetail(pot: pot),
              _ => const _PotMissing(),
            },
          AsyncError() => const _PotMissing(),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }

  Pot? _resolve(List<Pot> pots) {
    for (final pot in pots) {
      if (pot.id == potId) return pot;
    }
    return null;
  }

  void _leave(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(SavingsPaths.root);
    }
  }
}

class _PotDetail extends StatelessWidget {
  const _PotDetail({required this.pot});

  final Pot pot;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return ListView(
      padding: EdgeInsets.all(spacing.md),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  raised: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pot.name, style: context.textStyles.titleMedium),
                      SizedBox(height: spacing.xs),
                      BalanceText(pot.balance),
                      if (pot.hasGoal) ...[
                        SizedBox(height: spacing.md),
                        PotProgress(pot: pot),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: spacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Add money',
                        icon: LucideIcons.plus,
                        expand: true,
                        onPressed: () => showPotAmountSheet(
                          context,
                          pot: pot,
                          mode: PotAmountMode.deposit,
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: AppButton(
                        label: 'Withdraw',
                        icon: LucideIcons.download,
                        variant: AppButtonVariant.secondary,
                        expand: true,
                        onPressed: pot.balance.isPositive
                            ? () => showPotAmountSheet(
                                  context,
                                  pot: pot,
                                  mode: PotAmountMode.withdraw,
                                )
                            : null,
                      ),
                    ),
                  ],
                ),
                if (pot.roundUpsEnabled) ...[
                  SizedBox(height: spacing.md),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.zap,
                        size: 16,
                        color: context.colors.accent,
                      ),
                      SizedBox(width: spacing.xs),
                      Expanded(
                        child: Text(
                          'Spare change from your spending rounds up into '
                          'this pot.',
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PotMissing extends StatelessWidget {
  const _PotMissing();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: Text(
          'That pot is no longer available.',
          style: context.textStyles.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// Which way the money moves through the sheet.
enum PotAmountMode { deposit, withdraw }

/// Collects an amount for a deposit or withdrawal, then hands the built
/// [TransferRequest] to the transfer flow — the same resume entry the
/// outbox re-price uses. The pot screen deliberately doesn't confirm the
/// movement itself.
Future<void> showPotAmountSheet(
  BuildContext context, {
  required Pot pot,
  required PotAmountMode mode,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _PotAmountSheet(pot: pot, mode: mode),
  );
}

class _PotAmountSheet extends StatefulWidget {
  const _PotAmountSheet({required this.pot, required this.mode});

  final Pot pot;
  final PotAmountMode mode;

  @override
  State<_PotAmountSheet> createState() => _PotAmountSheetState();
}

class _PotAmountSheetState extends State<_PotAmountSheet> {
  final _amount = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  bool get _isDeposit => widget.mode == PotAmountMode.deposit;

  void _submit() {
    final pot = widget.pot;
    final amount = Money.tryParse(_amount.text, pot.currency);
    if (amount == null || !amount.isPositive) {
      setState(() => _error = 'Enter an amount above zero');
      return;
    }
    if (!_isDeposit && amount > pot.balance) {
      setState(() => _error = 'That\u2019s more than the pot holds');
      return;
    }

    // Deposit: account -> pot. Withdrawal: pot -> account (the mirror,
    // §12.2). A withdrawal sources from the pot id; the transfer rails
    // resolve it the same as any container.
    final request = _isDeposit
        ? TransferRequest(
            sourceAccountId: pot.accountId,
            destination: PotDestination(pot.id),
            amount: amount,
          )
        : TransferRequest(
            sourceAccountId: pot.id,
            destination: OwnAccountDestination(pot.accountId),
            amount: amount,
          );

    Navigator.of(context).pop();
    context.go(TransfersPaths.flow, extra: request);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final pot = widget.pot;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: spacing.md,
          right: spacing.md,
          top: spacing.lg,
          bottom: spacing.md + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isDeposit ? 'Add to ${pot.name}' : 'Withdraw from ${pot.name}',
              style: context.textStyles.titleLarge,
            ),
            if (!_isDeposit) ...[
              SizedBox(height: spacing.xs),
              Text(
                'Available: ${pot.balance.format()}',
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
            SizedBox(height: spacing.lg),
            AppTextField(
              label: 'Amount (${pot.currency.code})',
              controller: _amount,
              errorText: _error,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
              ],
              onSubmitted: (_) => _submit(),
            ),
            SizedBox(height: spacing.lg),
            AppButton(
              label: _isDeposit ? 'Continue' : 'Continue to withdraw',
              expand: true,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
