import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/savings/presentation/failure_copy.dart';
import 'package:vaulta/features/savings/presentation/providers/pots_providers.dart';

/// Opens the new-pot form as a modal sheet.
Future<void> showCreatePotSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const CreatePotSheet(),
  );
}

/// Opens a new pot. The funding account fixes the pot's currency (§12.2),
/// so the goal is parsed in that currency via [Money.tryParse] — text
/// never becomes a `double` on the way to the wire. The goal is optional:
/// an open-ended pot has no target.
class CreatePotSheet extends ConsumerStatefulWidget {
  const CreatePotSheet({super.key});

  @override
  ConsumerState<CreatePotSheet> createState() => _CreatePotSheetState();
}

class _CreatePotSheetState extends ConsumerState<CreatePotSheet> {
  final _name = TextEditingController();
  final _goal = TextEditingController();

  String? _accountId;
  String? _nameError;
  String? _goalError;
  var _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _goal.dispose();
    super.dispose();
  }

  Future<void> _submit(List<Account> accounts) async {
    if (_submitting) return;
    final accountId =
        _accountId ?? (accounts.isEmpty ? null : accounts.first.id);
    if (accountId == null) return;
    final account = accounts.firstWhere((a) => a.id == accountId);

    final name = _name.text.trim();
    final goalText = _goal.text.trim();
    final goal =
        goalText.isEmpty ? null : Money.tryParse(goalText, account.currency);

    setState(() {
      _nameError = name.isEmpty ? 'Name your pot' : null;
      _goalError = goalText.isEmpty
          ? null
          : (goal == null || !goal.isPositive
              ? 'Enter a target above zero'
              : null);
    });
    if (_nameError != null || _goalError != null) return;

    setState(() => _submitting = true);
    final failure = await ref.read(potsControllerProvider.notifier).createPot(
          accountId: accountId,
          name: name,
          goal: goal,
        );
    if (!mounted) return;
    if (failure == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _submitting = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(potsFailureCopy(failure))));
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final accounts =
        ref.watch(accountsControllerProvider).value ?? const <Account>[];
    final selectedId =
        _accountId ?? (accounts.isEmpty ? null : accounts.first.id);

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
            Text('New pot', style: context.textStyles.titleLarge),
            SizedBox(height: spacing.lg),
            AppTextField(
              label: 'Name',
              hint: 'Rainy day, new laptop\u2026',
              controller: _name,
              errorText: _nameError,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: spacing.md),
            AppTextField(
              label: 'Goal (optional)',
              hint: 'Leave blank for open-ended',
              controller: _goal,
              errorText: _goalError,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
              ],
            ),
            if (accounts.isNotEmpty) ...[
              SizedBox(height: spacing.md),
              Text(
                'Fund from',
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              SizedBox(height: spacing.xs),
              Wrap(
                spacing: spacing.xs,
                children: [
                  for (final account in accounts)
                    ChoiceChip(
                      label: Text(
                        '${account.name} \u00b7 ${account.currency.code}',
                      ),
                      selected: account.id == selectedId,
                      onSelected: (_) =>
                          setState(() => _accountId = account.id),
                    ),
                ],
              ),
            ],
            SizedBox(height: spacing.lg),
            AppButton(
              label: 'Create pot',
              expand: true,
              loading: _submitting,
              onPressed: accounts.isEmpty ? null : () => _submit(accounts),
            ),
          ],
        ),
      ),
    );
  }
}
