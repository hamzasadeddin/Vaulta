import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/widgets/balance_text.dart';

/// A [BalanceText] that animates between values.
///
/// Interpolation is exact [Decimal] arithmetic — money never touches
/// binary floating point, even mid-tween. Currency changes snap instead
/// of interpolating: amounts in different currencies share no axis.
class AnimatedBalanceText extends StatelessWidget {
  const AnimatedBalanceText(
    this.money, {
    this.size = MoneyTextSize.display,
    this.masked = false,
    this.colorBySign = false,
    this.locale,
    this.duration = const Duration(milliseconds: 450),
    this.curve = Curves.easeOutCubic,
    super.key,
  });

  final Money money;
  final MoneyTextSize size;

  /// Hides the amount but keeps the currency symbol. Masked balances
  /// render statically — nothing to animate behind the dots.
  final bool masked;

  final bool colorBySign;
  final String? locale;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    if (masked) {
      return BalanceText(
        money,
        size: size,
        masked: true,
        colorBySign: colorBySign,
        locale: locale,
      );
    }
    return TweenAnimationBuilder<Decimal>(
      // New key per currency: a switch restarts rather than interpolates.
      key: ValueKey(money.currency),
      tween: _DecimalTween(end: money.amount),
      duration: duration,
      curve: curve,
      builder: (context, value, _) => BalanceText(
        Money(value, money.currency),
        size: size,
        colorBySign: colorBySign,
        locale: locale,
      ),
    );
  }
}

/// Interpolates [Decimal]s exactly: the animation clock's `t` is truncated
/// to a short decimal literal before it multiplies the delta, so no binary
/// floating point ever reaches the amount.
class _DecimalTween extends Tween<Decimal> {
  _DecimalTween({super.end});

  @override
  Decimal lerp(double t) {
    final from = begin ?? end!;
    final to = end!;
    if (t <= 0) return from;
    if (t >= 1) return to;
    final factor = Decimal.parse(t.toStringAsFixed(6));
    return from + (to - from) * factor;
  }
}
