import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulta/core/config/app_config.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';

/// Root widget. Routing arrives with the auth feature (Phase 3);
/// until then the home is a minimal design-system proof.
class VaultaApp extends ConsumerWidget {
  const VaultaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    return MaterialApp(
      title: 'Vaulta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      // Dark-first brand; a user-facing toggle ships with Profile.
      themeMode: ThemeMode.dark,
      home: _PlaceholderHome(flavor: config.flavor),
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome({required this.flavor});

  final Flavor flavor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: context.spacing.screenPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Vaulta',
                  textAlign: TextAlign.center,
                  style: context.textStyles.displaySmall,
                ),
                SizedBox(height: context.spacing.sm),
                Center(
                  child: StatusBadge(
                    label: flavor.name.toUpperCase(),
                    kind: StatusKind.info,
                  ),
                ),
                SizedBox(height: context.spacing.xl),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total balance',
                        style: context.textStyles.labelMedium,
                      ),
                      SizedBox(height: context.spacing.sm),
                      BalanceText(Money.parse('12480.50', Currency.usd)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
