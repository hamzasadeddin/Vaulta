import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/statement.dart';
import 'package:vaulta/features/accounts/presentation/failure_copy.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';

/// Monthly statements for one account, each exportable as a PDF. Export
/// fetches the statement lines, renders the document and hands it to the
/// platform share/print sheet.
class StatementsSection extends ConsumerStatefulWidget {
  const StatementsSection({required this.account, super.key});

  final Account account;

  @override
  ConsumerState<StatementsSection> createState() => _StatementsSectionState();
}

class _StatementsSectionState extends ConsumerState<StatementsSection> {
  String? _exportingId;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final state = ref.watch(accountStatementsProvider(widget.account.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Statements', style: context.textStyles.titleMedium),
        SizedBox(height: spacing.sm),
        switch (state) {
          AsyncData(:final value) when value.isEmpty =>
            const _EmptyStatements(),
          AsyncData(:final value) => AppCard(
              padding: EdgeInsets.symmetric(vertical: spacing.xs),
              child: Column(
                children: [
                  for (final (index, statement) in value.indexed) ...[
                    if (index != 0) const Divider(height: 1),
                    _StatementTile(
                      statement: statement,
                      exporting: _exportingId == statement.id,
                      onExport: () => _export(statement),
                    ),
                  ],
                ],
              ),
            ),
          AsyncError(:final error) => _StatementsError(
              message: accountsFailureCopy(error),
              onRetry: () => ref
                  .read(accountStatementsProvider(widget.account.id).notifier)
                  .retry(),
            ),
          _ => const _StatementsSkeleton(),
        },
      ],
    );
  }

  Future<void> _export(Statement statement) async {
    if (_exportingId != null) return;
    setState(() => _exportingId = statement.id);
    final failure = await ref
        .read(statementExporterProvider)
        .export(account: widget.account, statement: statement);
    if (!mounted) return;
    setState(() => _exportingId = null);
    if (failure != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Couldn\u2019t export the statement. '
              '${accountsFailureCopy(failure)}',
            ),
          ),
        );
    }
  }
}

class _StatementTile extends StatelessWidget {
  const _StatementTile({
    required this.statement,
    required this.exporting,
    required this.onExport,
  });

  final Statement statement;
  final bool exporting;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return InkWell(
      onTap: exporting ? null : onExport,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMMM yyyy').format(statement.periodStart),
                    style: context.textStyles.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${statement.transactionCount} transactions',
                    style: context.textStyles.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: spacing.sm),
            BalanceText(statement.closing, size: MoneyTextSize.sm),
            SizedBox(width: spacing.sm),
            if (exporting)
              const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(LucideIcons.download, size: 18, color: colors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _EmptyStatements extends StatelessWidget {
  const _EmptyStatements();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Text(
        'No statements yet \u2014 the first one arrives after a full '
        'calendar month.',
        style: context.textStyles.bodySmall?.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}

class _StatementsError extends StatelessWidget {
  const _StatementsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
          AppButton(
            label: 'Retry',
            variant: AppButtonVariant.ghost,
            size: AppButtonSize.small,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

class _StatementsSkeleton extends StatelessWidget {
  const _StatementsSkeleton();

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return AppCard(
      child: Column(
        children: [
          for (var i = 0; i < 3; i++) ...[
            if (i != 0) SizedBox(height: spacing.sm),
            const Row(
              children: [
                Expanded(child: SkeletonLine(widthFactor: 0.4)),
                SkeletonBox(width: 72, height: 14),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
