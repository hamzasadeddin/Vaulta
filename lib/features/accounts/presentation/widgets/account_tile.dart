import 'package:flutter/material.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/presentation/widgets/account_visuals.dart';

/// One account row. The balance carries a per-account [Hero] tag so route
/// navigation to the detail screen flies it; the expanded-layout pane
/// renders without heroes, so tags never duplicate within one route.
class AccountTile extends StatelessWidget {
  const AccountTile({
    required this.account,
    required this.onTap,
    this.selected = false,
    super.key,
  });

  final Account account;
  final VoidCallback onTap;

  /// Highlighted when this account is open in the expanded detail pane.
  final bool selected;

  static String heroTag(String accountId) => 'account-balance-$accountId';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: context.radii.brLg,
        border: Border.all(
          color: selected ? colors.accent : Colors.transparent,
        ),
      ),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.accentMuted,
                borderRadius: context.radii.brMd,
              ),
              child: Icon(account.type.icon, size: 20, color: colors.accent),
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: context.textStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${account.type.label} \u00b7 '
                    '\u2022\u2022\u2022\u2022 ${account.ibanTail}',
                    style: context.textStyles.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: spacing.sm),
            Hero(
              tag: heroTag(account.id),
              child: Material(
                type: MaterialType.transparency,
                child: BalanceText(account.balance, size: MoneyTextSize.md),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
