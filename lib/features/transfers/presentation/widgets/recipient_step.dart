import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
// Presentation-only cross-feature read (§6.22): the picker lists the
// user's own accounts, which only the accounts controller can supply.
// The transfers domain and data layers know an account solely as an id.
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/transfers/domain/entities/beneficiary.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/presentation/failure_copy.dart';
import 'package:vaulta/features/transfers/presentation/forms/transfer_inputs.dart';
import 'package:vaulta/features/transfers/presentation/providers/transfers_providers.dart';

enum _Recipient { own, saved, iban }

/// Step one: pick the account money leaves from, and where it goes.
class RecipientStep extends ConsumerStatefulWidget {
  const RecipientStep({super.key});

  @override
  ConsumerState<RecipientStep> createState() => _RecipientStepState();
}

class _RecipientStepState extends ConsumerState<RecipientStep> {
  _Recipient _mode = _Recipient.own;

  void _continue(String sourceId) {
    final notifier = ref.read(transferFlowProvider.notifier)
      // The UI pre-selects the first account; commit that default before
      // leaving, or the amount step has no currency to parse against.
      ..selectSource(sourceId);
    if (_mode == _Recipient.iban && !notifier.useTypedIban()) return;
    if (ref.read(transferFlowProvider).destination == null) return;
    notifier.goTo(TransferStep.amount);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final state = ref.watch(transferFlowProvider);
    final notifier = ref.read(transferFlowProvider.notifier);
    final accounts = ref.watch(accountsControllerProvider).value ?? const [];

    // Default the source to the first account so the common case is one
    // tap rather than two.
    final sourceId =
        state.sourceAccountId ?? (accounts.isEmpty ? null : accounts.first.id);

    return ListView(
      padding: EdgeInsets.all(spacing.md),
      children: [
        const _SectionLabel(text: 'From'),
        SizedBox(height: spacing.sm),
        for (final account in accounts) ...[
          _AccountTile(
            account: account,
            selected: account.id == sourceId,
            onTap: () => notifier.selectSource(account.id),
          ),
          SizedBox(height: spacing.xs),
        ],
        SizedBox(height: spacing.md),
        const _SectionLabel(text: 'To'),
        SizedBox(height: spacing.sm),
        _ModeSelector(
          mode: _mode,
          onChanged: (mode) => setState(() => _mode = mode),
        ),
        SizedBox(height: spacing.md),
        switch (_mode) {
          _Recipient.own => _OwnAccounts(
              accounts: accounts,
              excludeId: sourceId,
              selected: state.destination,
              onSelect: notifier.selectDestination,
            ),
          _Recipient.saved => _SavedPayees(
              selected: state.destination,
              onSelect: notifier.selectDestination,
            ),
          _Recipient.iban => const _IbanEntry(),
        },
        SizedBox(height: spacing.lg),
        AppButton(
          label: 'Continue',
          expand: true,
          onPressed: sourceId == null ? null : () => _continue(sourceId),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: context.textStyles.labelSmall?.copyWith(
        color: context.colors.textTertiary,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  const _ModeSelector({required this.mode, required this.onChanged});

  final _Recipient mode;
  final ValueChanged<_Recipient> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = {
      _Recipient.own: 'My accounts',
      _Recipient.saved: 'Saved',
      _Recipient.iban: 'New IBAN',
    };

    return Row(
      children: [
        for (final entry in labels.entries) ...[
          if (entry.key != _Recipient.own) SizedBox(width: context.spacing.xs),
          Expanded(
            child: _ModeChip(
              label: entry.value,
              selected: entry.key == mode,
              onTap: () => onChanged(entry.key),
            ),
          ),
        ],
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii.brMd;

    return Material(
      color: selected ? colors.accentMuted : colors.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: selected ? colors.accent : colors.border,
            ),
          ),
          child: Text(
            label,
            style: context.textStyles.labelMedium?.copyWith(
              color: selected ? colors.accent : colors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({
    required this.account,
    required this.selected,
    required this.onTap,
  });

  final Account account;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          _SelectionDot(selected: selected),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: context.textStyles.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\u2022\u2022\u2022\u2022 ${account.ibanTail}',
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: spacing.sm),
          BalanceText(account.balance, size: MoneyTextSize.sm),
        ],
      ),
    );
  }
}

/// Filled ring when selected — a radio without the Material radio's
/// fixed palette.
class _SelectionDot extends StatelessWidget {
  const _SelectionDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? colors.accent : Colors.transparent,
        border: Border.all(
          color: selected ? colors.accent : colors.border,
          width: 1.5,
        ),
      ),
      child: selected
          ? Icon(LucideIcons.check, size: 12, color: colors.onAccent)
          : null,
    );
  }
}

class _OwnAccounts extends StatelessWidget {
  const _OwnAccounts({
    required this.accounts,
    required this.excludeId,
    required this.selected,
    required this.onSelect,
  });

  final List<Account> accounts;
  final String? excludeId;
  final TransferDestination? selected;
  final ValueChanged<TransferDestination> onSelect;

  @override
  Widget build(BuildContext context) {
    // Bound to a local so the `is` check promotes (a public field
    // wouldn't).
    final current = selected;
    final targets = [
      for (final account in accounts)
        if (account.id != excludeId) account,
    ];
    if (targets.isEmpty) {
      return const _Hint(
        text: 'You need a second account to transfer between your own.',
      );
    }

    return Column(
      children: [
        for (final account in targets) ...[
          _AccountTile(
            account: account,
            selected: current is OwnAccountDestination &&
                current.accountId == account.id,
            onTap: () => onSelect(OwnAccountDestination(account.id)),
          ),
          SizedBox(height: context.spacing.xs),
        ],
      ],
    );
  }
}

class _SavedPayees extends ConsumerWidget {
  const _SavedPayees({required this.selected, required this.onSelect});

  final TransferDestination? selected;
  final ValueChanged<TransferDestination> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(beneficiariesControllerProvider);
    final current = selected;

    return switch (state) {
      AsyncData(:final value) => value.isEmpty
          ? const _Hint(text: 'No saved payees yet.')
          : Column(
              children: [
                for (final payee in value) ...[
                  _PayeeTile(
                    payee: payee,
                    selected: current is BeneficiaryDestination &&
                        current.beneficiaryId == payee.id,
                    onTap: () => onSelect(BeneficiaryDestination(payee.id)),
                  ),
                  SizedBox(height: context.spacing.xs),
                ],
              ],
            ),
      AsyncError(:final error) => _Hint(text: transfersFailureCopy(error)),
      _ => const _PayeesSkeleton(),
    };
  }
}

class _PayeeTile extends StatelessWidget {
  const _PayeeTile({
    required this.payee,
    required this.selected,
    required this.onTap,
  });

  final Beneficiary payee;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          _SelectionDot(selected: selected),
          SizedBox(width: spacing.sm),
          CircleAvatar(
            radius: 16,
            backgroundColor: colors.accentMuted,
            child: Text(
              payee.initials,
              style: context.textStyles.labelMedium?.copyWith(
                color: colors.accent,
              ),
            ),
          ),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payee.name,
                  style: context.textStyles.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${payee.bankName} \u00b7 \u2022\u2022\u2022\u2022 '
                  '${payee.iban.tail}',
                  style: context.textStyles.bodySmall?.copyWith(
                    color: colors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IbanEntry extends ConsumerWidget {
  const _IbanEntry();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transferFlowProvider);
    final notifier = ref.read(transferFlowProvider.notifier);

    final ibanError = switch (state.iban.displayError) {
      IbanValidationError.empty => 'Enter an IBAN',
      IbanValidationError.invalid => 'That IBAN isn\u2019t valid',
      null => null,
    };
    final nameError = switch (state.holderName.displayError) {
      HolderNameValidationError.empty => 'Enter the payee\u2019s name',
      HolderNameValidationError.tooShort => 'Too short',
      null => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: 'Payee name',
          errorText: nameError,
          onChanged: notifier.holderNameChanged,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: context.spacing.sm),
        AppTextField(
          label: 'IBAN',
          hint: 'JO82 VBNK 0001 …',
          errorText: ibanError,
          onChanged: notifier.ibanChanged,
          autocorrect: false,
        ),
      ],
    );
  }
}

class _PayeesSkeleton extends StatelessWidget {
  const _PayeesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 3; i++) ...[
          const SkeletonBox(height: 64),
          SizedBox(height: context.spacing.xs),
        ],
      ],
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spacing.sm),
      child: Text(
        text,
        style: context.textStyles.bodySmall?.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}
