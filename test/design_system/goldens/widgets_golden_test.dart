import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';

void main() {
  const constraints = BoxConstraints(maxWidth: 320);

  unawaited(
    goldenTest(
      'AppButton renders all variants and sizes',
      fileName: 'app_button',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraints,
        children: [
          GoldenTestScenario(
            name: 'primary / medium',
            child: AppButton(label: 'Send money', onPressed: () {}),
          ),
          GoldenTestScenario(
            name: 'secondary + icon',
            child: AppButton(
              label: 'Add beneficiary',
              variant: AppButtonVariant.secondary,
              icon: Icons.add,
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'ghost',
            child: AppButton(
              label: 'Cancel',
              variant: AppButtonVariant.ghost,
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'danger',
            child: AppButton(
              label: 'Freeze card',
              variant: AppButtonVariant.danger,
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'disabled',
            child: const AppButton(label: 'Disabled'),
          ),
          GoldenTestScenario(
            name: 'small',
            child: AppButton(
              label: 'Small',
              size: AppButtonSize.small,
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'large / expanded',
            child: AppButton(
              label: 'Continue',
              size: AppButtonSize.large,
              expand: true,
              onPressed: () {},
            ),
          ),
        ],
      ),
    ),
  );

  unawaited(
    goldenTest(
      'Money text renders with tabular figures and semantic color',
      fileName: 'money_text',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraints,
        children: [
          GoldenTestScenario(
            name: 'balance display',
            child: BalanceText(Money.parse('48231.09', Currency.usd)),
          ),
          GoldenTestScenario(
            name: 'masked',
            child: BalanceText(
              Money.parse('48231.09', Currency.usd),
              masked: true,
            ),
          ),
          GoldenTestScenario(
            name: 'JOD (3 minor digits)',
            child: BalanceText(
              Money.parse('12.345', Currency.jod),
              size: MoneyTextSize.lg,
            ),
          ),
          GoldenTestScenario(
            name: 'credit',
            child: SignedMoneyText(Money.parse('120', Currency.usd)),
          ),
          GoldenTestScenario(
            name: 'debit',
            child: SignedMoneyText(Money.parse('-85.20', Currency.usd)),
          ),
        ],
      ),
    ),
  );

  unawaited(
    goldenTest(
      'AppCard, StatusBadge and Skeleton render correctly',
      fileName: 'surfaces',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraints,
        children: [
          GoldenTestScenario(
            name: 'card with balance',
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total balance'),
                  const SizedBox(height: 8),
                  BalanceText(
                    Money.parse('9425.10', Currency.usd),
                    size: MoneyTextSize.lg,
                  ),
                ],
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'badges',
            child: const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusBadge(label: 'Pending', kind: StatusKind.pending),
                StatusBadge(label: 'Completed', kind: StatusKind.success),
                StatusBadge(label: 'Failed', kind: StatusKind.failed),
              ],
            ),
          ),
          GoldenTestScenario(
            name: 'skeleton (static frame)',
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 160, height: 32, animate: false),
                SizedBox(height: 8),
                SkeletonLine(widthFactor: 0.7, animate: false),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  unawaited(
    goldenTest(
      'AppTextField renders all states',
      fileName: 'app_text_field',
      builder: () => GoldenTestGroup(
        scenarioConstraints: constraints,
        children: [
          GoldenTestScenario(
            name: 'default with label',
            child: const AppTextField(
              label: 'Email',
              hint: 'name@example.com',
            ),
          ),
          GoldenTestScenario(
            name: 'error',
            child: const AppTextField(
              label: 'IBAN',
              errorText: 'IBAN checksum failed',
            ),
          ),
          GoldenTestScenario(
            name: 'helper',
            child: const AppTextField(
              label: 'Account name',
              helperText: 'Shown to people who pay you',
            ),
          ),
          GoldenTestScenario(
            name: 'disabled',
            child: const AppTextField(label: 'Disabled', enabled: false),
          ),
        ],
      ),
    ),
  );
}
