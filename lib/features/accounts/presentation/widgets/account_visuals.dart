import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';

/// Presentation-only mapping from [AccountType] to copy and iconography.
/// Copy is English-only until the l10n pass in Phase 10.
extension AccountTypeVisuals on AccountType {
  String get label => switch (this) {
        AccountType.checking => 'Checking',
        AccountType.savings => 'Savings',
      };

  IconData get icon => switch (this) {
        AccountType.checking => LucideIcons.wallet,
        AccountType.savings => LucideIcons.piggyBank,
      };
}
