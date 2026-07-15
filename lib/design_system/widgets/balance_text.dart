import 'package:flutter/material.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/money/money_formatter.dart';
import 'package:vaulta/design_system/theme/theme_context.dart';

enum MoneyTextSize { display, lg, md, sm }

/// Renders a [Money] with tabular figures — the one non-negotiable of this
/// design system. Supports a privacy mask (`JD ••••`) for balance hiding.
class BalanceText extends StatelessWidget {
  const BalanceText(
    this.money, {
    this.size = MoneyTextSize.display,
    this.masked = false,
    this.colorBySign = false,
    this.locale,
    super.key,
  });

  final Money money;
  final MoneyTextSize size;

  /// Hides the amount but keeps the currency symbol, preserving layout.
  final bool masked;

  /// Credit → mint, debit → red. Off by default: a headline balance is
  /// informational, not a transaction row.
  final bool colorBySign;

  final String? locale;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final base = switch (size) {
      MoneyTextSize.display => typography.balanceDisplay,
      MoneyTextSize.lg => typography.moneyLg,
      MoneyTextSize.md => typography.moneyMd,
      MoneyTextSize.sm => typography.moneySm,
    };
    final color = colorBySign
        ? (money.isNegative ? context.colors.debit : context.colors.credit)
        : null;
    final text =
        masked ? '${money.currency.symbol} ••••' : money.format(locale: locale);

    return Text(
      text,
      style: color == null ? base : base.copyWith(color: color),
      maxLines: 1,
      semanticsLabel: masked ? 'Balance hidden' : text,
    );
  }
}

/// Transaction-row amount: explicit sign, semantic color.
/// `+$120.00` in mint, `−$85.20` in red.
class SignedMoneyText extends StatelessWidget {
  const SignedMoneyText(
    this.money, {
    this.size = MoneyTextSize.md,
    this.locale,
    super.key,
  });

  final Money money;
  final MoneyTextSize size;
  final String? locale;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final base = switch (size) {
      MoneyTextSize.display => typography.balanceDisplay,
      MoneyTextSize.lg => typography.moneyLg,
      MoneyTextSize.md => typography.moneyMd,
      MoneyTextSize.sm => typography.moneySm,
    };
    final color =
        money.isNegative ? context.colors.debit : context.colors.credit;

    return Text(
      money.formatSigned(locale: locale),
      style: base.copyWith(color: color),
      maxLines: 1,
    );
  }
}
