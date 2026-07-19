import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
// Presentation-level composition only: the chip row needs account names,
// which the accounts slice already holds in memory. Domain and data layers
// of the two features stay fully uncoupled (§6.16 applies to entities and
// repositories, not to a screen reading another feature's provider).
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:vaulta/features/transactions/presentation/widgets/transaction_visuals.dart';

/// Search field plus one horizontally scrolling row of single-select
/// chips per dimension (account / category / status). Everything writes
/// into [TransactionsFilterController]; the feed reloads reactively.
class TransactionFilterBar extends ConsumerStatefulWidget {
  const TransactionFilterBar({super.key});

  /// Debounce window for the search field; widget tests pump past this.
  static const debounce = Duration(milliseconds: 300);

  @override
  ConsumerState<TransactionFilterBar> createState() =>
      _TransactionFilterBarState();
}

class _TransactionFilterBarState extends ConsumerState<TransactionFilterBar> {
  late final TextEditingController _search = TextEditingController(
    text: ref.read(transactionsFilterControllerProvider).query,
  );
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(TransactionFilterBar.debounce, () {
      if (!mounted) return;
      ref.read(transactionsFilterControllerProvider.notifier).setQuery(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final filter = ref.watch(transactionsFilterControllerProvider);
    final notifier = ref.read(transactionsFilterControllerProvider.notifier);
    final accounts = ref.watch(accountsControllerProvider).value ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _search,
          hint: 'Search transactions',
          prefixIcon: LucideIcons.search,
          onChanged: _onQueryChanged,
          textInputAction: TextInputAction.search,
          autocorrect: false,
        ),
        SizedBox(height: spacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if (filter.isActive) ...[
                ActionChip(
                  avatar: const Icon(LucideIcons.x, size: 14),
                  label: const Text('Clear'),
                  onPressed: () {
                    _debounce?.cancel();
                    _search.clear();
                    notifier.clear();
                  },
                ),
                SizedBox(width: spacing.xs),
              ],
              for (final account in accounts) ...[
                FilterChip(
                  label: Text(account.name),
                  selected: filter.accountId == account.id,
                  onSelected: (selected) =>
                      notifier.setAccount(selected ? account.id : null),
                ),
                SizedBox(width: spacing.xs),
              ],
              for (final category in TransactionCategory.values) ...[
                FilterChip(
                  label: Text(category.label),
                  selected: filter.category == category,
                  onSelected: (selected) =>
                      notifier.setCategory(selected ? category : null),
                ),
                SizedBox(width: spacing.xs),
              ],
              for (final status in TransactionStatus.values) ...[
                FilterChip(
                  label: Text(status.label),
                  selected: filter.status == status,
                  onSelected: (selected) =>
                      notifier.setStatus(selected ? status : null),
                ),
                if (status != TransactionStatus.values.last)
                  SizedBox(width: spacing.xs),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
