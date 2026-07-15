import 'package:flutter/material.dart';
import 'package:vaulta/design_system/tokens/color_tokens.dart';

/// Semantic color roles. Widgets read these via `context.colors` —
/// never inline `Color(0xFF...)` in a widget (spec §5).
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.canvas,
    required this.surface,
    required this.surfaceRaised,
    required this.border,
    required this.overlay,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.onAccent,
    required this.accentMuted,
    required this.credit,
    required this.debit,
    required this.pending,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.skeletonBase,
    required this.skeletonHighlight,
  });

  static const dark = AppColors(
    canvas: ColorTokens.navy950,
    surface: ColorTokens.navy900,
    surfaceRaised: ColorTokens.navy800,
    border: ColorTokens.navy700,
    overlay: Color(0xB30B0E14),
    textPrimary: ColorTokens.ink100,
    textSecondary: ColorTokens.ink300,
    textTertiary: ColorTokens.ink500,
    accent: ColorTokens.violet500,
    onAccent: Colors.white,
    accentMuted: ColorTokens.violet900,
    credit: ColorTokens.mint500,
    debit: ColorTokens.red500,
    pending: ColorTokens.amber500,
    success: ColorTokens.mint500,
    warning: ColorTokens.amber500,
    danger: ColorTokens.red500,
    info: ColorTokens.blue500,
    skeletonBase: ColorTokens.navy800,
    skeletonHighlight: ColorTokens.navy700,
  );

  static const light = AppColors(
    canvas: ColorTokens.paper50,
    surface: ColorTokens.paper0,
    surfaceRaised: ColorTokens.paper0,
    border: ColorTokens.paperBorder,
    overlay: Color(0x8010141C),
    textPrimary: ColorTokens.inkDark900,
    textSecondary: ColorTokens.inkDark600,
    textTertiary: ColorTokens.inkDark400,
    accent: ColorTokens.violet500,
    onAccent: Colors.white,
    accentMuted: Color(0xFFE9E6FC),
    credit: Color(0xFF00A886),
    debit: Color(0xFFE1355A),
    pending: Color(0xFFC77F00),
    success: Color(0xFF00A886),
    warning: Color(0xFFC77F00),
    danger: Color(0xFFE1355A),
    info: Color(0xFF1F7FE0),
    skeletonBase: Color(0xFFE9ECF3),
    skeletonHighlight: Color(0xFFF4F6FA),
  );

  final Color canvas;
  final Color surface;
  final Color surfaceRaised;
  final Color border;
  final Color overlay;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color onAccent;
  final Color accentMuted;
  final Color credit;
  final Color debit;
  final Color pending;
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;
  final Color skeletonBase;
  final Color skeletonHighlight;

  @override
  AppColors copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceRaised,
    Color? border,
    Color? overlay,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? onAccent,
    Color? accentMuted,
    Color? credit,
    Color? debit,
    Color? pending,
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? skeletonBase,
    Color? skeletonHighlight,
  }) {
    return AppColors(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      border: border ?? this.border,
      overlay: overlay ?? this.overlay,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentMuted: accentMuted ?? this.accentMuted,
      credit: credit ?? this.credit,
      debit: debit ?? this.debit,
      pending: pending ?? this.pending,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      skeletonBase: skeletonBase ?? this.skeletonBase,
      skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      canvas: l(canvas, other.canvas),
      surface: l(surface, other.surface),
      surfaceRaised: l(surfaceRaised, other.surfaceRaised),
      border: l(border, other.border),
      overlay: l(overlay, other.overlay),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textTertiary: l(textTertiary, other.textTertiary),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      accentMuted: l(accentMuted, other.accentMuted),
      credit: l(credit, other.credit),
      debit: l(debit, other.debit),
      pending: l(pending, other.pending),
      success: l(success, other.success),
      warning: l(warning, other.warning),
      danger: l(danger, other.danger),
      info: l(info, other.info),
      skeletonBase: l(skeletonBase, other.skeletonBase),
      skeletonHighlight: l(skeletonHighlight, other.skeletonHighlight),
    );
  }
}
