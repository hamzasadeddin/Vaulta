import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

/// Widgetbook catalog. Run with:
/// `flutter run -t lib/widgetbook/main.dart -d chrome`
///
/// Composed manually (no widgetbook_generator) — the catalog is small
/// enough that codegen would cost more than it saves.
void main() => runApp(const WidgetbookApp());

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Dark', data: AppTheme.dark()),
            WidgetbookTheme(name: 'Light', data: AppTheme.light()),
          ],
        ),
        TextScaleAddon(min: 1),
      ],
      directories: [
        WidgetbookFolder(
          name: 'Foundations',
          children: [
            WidgetbookComponent(
              name: 'Colors',
              useCases: [
                WidgetbookUseCase(name: 'Palette', builder: _paletteUseCase),
              ],
            ),
            WidgetbookComponent(
              name: 'Typography',
              useCases: [
                WidgetbookUseCase(name: 'Specimen', builder: _typeUseCase),
              ],
            ),
          ],
        ),
        WidgetbookFolder(
          name: 'Widgets',
          children: [
            WidgetbookComponent(
              name: 'AppButton',
              useCases: [
                WidgetbookUseCase(name: 'Variants', builder: _buttonsUseCase),
              ],
            ),
            WidgetbookComponent(
              name: 'Money',
              useCases: [
                WidgetbookUseCase(name: 'BalanceText', builder: _moneyUseCase),
              ],
            ),
            WidgetbookComponent(
              name: 'AppCard & StatusBadge',
              useCases: [
                WidgetbookUseCase(name: 'Showcase', builder: _cardsUseCase),
              ],
            ),
            WidgetbookComponent(
              name: 'AppTextField',
              useCases: [
                WidgetbookUseCase(name: 'States', builder: _inputsUseCase),
              ],
            ),
            WidgetbookComponent(
              name: 'Skeleton',
              useCases: [
                WidgetbookUseCase(name: 'Loading', builder: _skeletonUseCase),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

Widget _catalogPage(BuildContext context, List<Widget> children) {
  return Scaffold(
    body: ListView(
      padding: EdgeInsets.all(context.spacing.lg),
      children: [
        for (final child in children)
          Padding(
            padding: EdgeInsets.only(bottom: context.spacing.md),
            child: child,
          ),
      ],
    ),
  );
}

Widget _paletteUseCase(BuildContext context) {
  final colors = context.colors;
  final swatches = <(String, Color)>[
    ('canvas', colors.canvas),
    ('surface', colors.surface),
    ('surfaceRaised', colors.surfaceRaised),
    ('border', colors.border),
    ('accent', colors.accent),
    ('accentMuted', colors.accentMuted),
    ('credit', colors.credit),
    ('debit', colors.debit),
    ('pending', colors.pending),
    ('info', colors.info),
    ('textPrimary', colors.textPrimary),
    ('textSecondary', colors.textSecondary),
    ('textTertiary', colors.textTertiary),
  ];
  return _catalogPage(context, [
    for (final (name, color) in swatches)
      Row(
        children: [
          Container(
            width: 48,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: context.radii.brXs,
              border: Border.all(color: colors.border),
            ),
          ),
          SizedBox(width: context.spacing.md),
          Text(name, style: context.textStyles.bodyMedium),
        ],
      ),
  ]);
}

Widget _typeUseCase(BuildContext context) {
  final text = context.textStyles;
  return _catalogPage(context, [
    Text('Display — Vaulta', style: text.displayMedium),
    Text('Headline — Your money, clearly', style: text.headlineMedium),
    Text('Title — Recent activity', style: text.titleLarge),
    Text(
      'Body — Transfers arrive instantly between Vaulta accounts. '
      'External transfers settle within one business day.',
      style: text.bodyLarge,
    ),
    Text('Label — ACCOUNT DETAILS', style: text.labelMedium),
    BalanceText(Money.parse('12480.50', Currency.usd)),
  ]);
}

Widget _buttonsUseCase(BuildContext context) {
  return _catalogPage(context, [
    AppButton(label: 'Send money', onPressed: () {}),
    AppButton(
      label: 'Add beneficiary',
      variant: AppButtonVariant.secondary,
      icon: LucideIcons.plus,
      onPressed: () {},
    ),
    AppButton(
      label: 'Cancel',
      variant: AppButtonVariant.ghost,
      onPressed: () {},
    ),
    AppButton(
      label: 'Freeze card',
      variant: AppButtonVariant.danger,
      icon: LucideIcons.snowflake,
      onPressed: () {},
    ),
    const AppButton(label: 'Disabled'),
    AppButton(label: 'Confirm transfer', loading: true, onPressed: () {}),
    AppButton(
      label: 'Continue',
      size: AppButtonSize.large,
      expand: true,
      onPressed: () {},
    ),
    AppButton(
      label: 'Small',
      size: AppButtonSize.small,
      onPressed: () {},
    ),
  ]);
}

Widget _moneyUseCase(BuildContext context) {
  final jod = Money.parse('12.345', Currency.jod);
  return _catalogPage(context, [
    BalanceText(Money.parse('48231.09', Currency.usd)),
    BalanceText(
      Money.parse('48231.09', Currency.usd),
      masked: true,
    ),
    BalanceText(jod, size: MoneyTextSize.lg),
    SignedMoneyText(Money.parse('120', Currency.usd)),
    SignedMoneyText(Money.parse('-85.20', Currency.usd)),
    SignedMoneyText(
      Money(Decimal.parse('-3.141'), Currency.jod),
      size: MoneyTextSize.sm,
    ),
  ]);
}

Widget _cardsUseCase(BuildContext context) {
  return _catalogPage(context, [
    AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total balance', style: context.textStyles.labelMedium),
          SizedBox(height: context.spacing.sm),
          BalanceText(Money.parse('9425.10', Currency.usd)),
        ],
      ),
    ),
    AppCard(
      onTap: () {},
      child: Row(
        children: [
          Expanded(
            child: Text('Tappable card', style: context.textStyles.titleMedium),
          ),
          Icon(
            LucideIcons.chevronRight,
            size: 18,
            color: context.colors.textTertiary,
          ),
        ],
      ),
    ),
    const Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        StatusBadge(label: 'Pending', kind: StatusKind.pending),
        StatusBadge(label: 'Completed', kind: StatusKind.success),
        StatusBadge(label: 'Failed', kind: StatusKind.failed),
        StatusBadge(label: 'Info', kind: StatusKind.info),
        StatusBadge(label: 'Neutral', kind: StatusKind.neutral),
      ],
    ),
  ]);
}

Widget _inputsUseCase(BuildContext context) {
  return _catalogPage(context, [
    const AppTextField(
      label: 'Email',
      hint: 'name@example.com',
      prefixIcon: LucideIcons.mail,
    ),
    const AppTextField(
      label: 'Password',
      hint: 'Enter your password',
      obscure: true,
      prefixIcon: LucideIcons.lock,
    ),
    const AppTextField(
      label: 'IBAN',
      hint: 'JO00 XXXX 0000 0000 0000 0000 0000',
      errorText: 'IBAN checksum failed',
    ),
    const AppTextField(
      label: 'Account name',
      helperText: 'Shown to people who pay you',
    ),
    const AppTextField(label: 'Disabled', enabled: false),
  ]);
}

Widget _skeletonUseCase(BuildContext context) {
  return _catalogPage(context, [
    const SkeletonBox(width: 180, height: 40),
    const SkeletonLine(widthFactor: 0.8),
    const SkeletonLine(widthFactor: 0.6),
    Row(
      children: [
        const SkeletonBox(width: 44, height: 44),
        SizedBox(width: context.spacing.md),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(widthFactor: 0.5),
              SizedBox(height: 8),
              SkeletonLine(widthFactor: 0.3, height: 10),
            ],
          ),
        ),
      ],
    ),
  ]);
}
