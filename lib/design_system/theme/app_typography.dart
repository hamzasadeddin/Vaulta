import 'package:flutter/material.dart';
import 'package:vaulta/design_system/theme/app_colors.dart';

const _inter = 'Inter';

/// Money-specific styles. Tabular figures are mandatory on every monetary
/// value (spec §5) so digits align in columns and balances don't jitter
/// when they tick.
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.balanceDisplay,
    required this.moneyLg,
    required this.moneyMd,
    required this.moneySm,
  });

  factory AppTypography.of(AppColors colors) {
    return AppTypography(
      balanceDisplay: TextStyle(
        fontFamily: _inter,
        fontSize: 40,
        height: 1.1,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        fontFeatures: _tabular,
        color: colors.textPrimary,
      ),
      moneyLg: TextStyle(
        fontFamily: _inter,
        fontSize: 24,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        fontFeatures: _tabular,
        color: colors.textPrimary,
      ),
      moneyMd: TextStyle(
        fontFamily: _inter,
        fontSize: 17,
        height: 1.3,
        fontWeight: FontWeight.w600,
        fontFeatures: _tabular,
        color: colors.textPrimary,
      ),
      moneySm: TextStyle(
        fontFamily: _inter,
        fontSize: 14,
        height: 1.3,
        fontWeight: FontWeight.w600,
        fontFeatures: _tabular,
        color: colors.textPrimary,
      ),
    );
  }

  static const _tabular = [FontFeature.tabularFigures()];

  final TextStyle balanceDisplay;
  final TextStyle moneyLg;
  final TextStyle moneyMd;
  final TextStyle moneySm;

  @override
  AppTypography copyWith({
    TextStyle? balanceDisplay,
    TextStyle? moneyLg,
    TextStyle? moneyMd,
    TextStyle? moneySm,
  }) {
    return AppTypography(
      balanceDisplay: balanceDisplay ?? this.balanceDisplay,
      moneyLg: moneyLg ?? this.moneyLg,
      moneyMd: moneyMd ?? this.moneyMd,
      moneySm: moneySm ?? this.moneySm,
    );
  }

  @override
  AppTypography lerp(AppTypography? other, double t) {
    if (other == null) return this;
    return AppTypography(
      balanceDisplay: TextStyle.lerp(balanceDisplay, other.balanceDisplay, t)!,
      moneyLg: TextStyle.lerp(moneyLg, other.moneyLg, t)!,
      moneyMd: TextStyle.lerp(moneyMd, other.moneyMd, t)!,
      moneySm: TextStyle.lerp(moneySm, other.moneySm, t)!,
    );
  }
}

/// App-wide [TextTheme] built on bundled Inter.
TextTheme buildTextTheme(AppColors colors) {
  TextStyle style(
    double size,
    FontWeight weight, {
    double? spacing,
    double height = 1.3,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: _inter,
      fontSize: size,
      fontWeight: weight,
      letterSpacing: spacing,
      height: height,
      color: color ?? colors.textPrimary,
    );
  }

  return TextTheme(
    displayLarge: style(44, FontWeight.w800, spacing: -1.2, height: 1.1),
    displayMedium: style(36, FontWeight.w800, spacing: -1, height: 1.1),
    displaySmall: style(30, FontWeight.w800, spacing: -0.8, height: 1.15),
    headlineMedium: style(26, FontWeight.w700, spacing: -0.5, height: 1.2),
    headlineSmall: style(22, FontWeight.w700, spacing: -0.3, height: 1.25),
    titleLarge: style(19, FontWeight.w700, spacing: -0.2),
    titleMedium: style(16, FontWeight.w600),
    titleSmall: style(14, FontWeight.w600),
    bodyLarge: style(16, FontWeight.w400, height: 1.5),
    bodyMedium: style(14, FontWeight.w400, height: 1.45),
    bodySmall: style(12.5, FontWeight.w400, color: colors.textSecondary),
    labelLarge: style(15, FontWeight.w600),
    labelMedium: style(13, FontWeight.w600, color: colors.textSecondary),
    labelSmall: style(11.5, FontWeight.w600, color: colors.textSecondary),
  );
}
