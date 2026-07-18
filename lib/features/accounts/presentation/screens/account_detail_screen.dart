import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/accounts/presentation/widgets/account_detail_view.dart';

/// Pushed detail route for compact/medium layouts. Expanded layouts show
/// the same content in the shell's side pane instead ([AccountDetailPane]).
class AccountDetailScreen extends ConsumerWidget {
  const AccountDetailScreen({required this.accountId, super.key});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountByIdProvider(accountId));

    return Scaffold(
      appBar: AppBar(title: Text(account?.name ?? 'Account')),
      body: SafeArea(
        child: AccountDetailView(accountId: accountId, useHeroes: true),
      ),
    );
  }
}
