import 'package:flutter/material.dart';
import 'package:vaulta/design_system/theme/app_colors.dart';
import 'package:vaulta/design_system/theme/app_dimens.dart';
import 'package:vaulta/design_system/theme/app_typography.dart';

/// Builds the app's [ThemeData]. Dark-first; light exists for completeness.
/// Dynamic color is deliberately not used — banks own their brand (spec §5).
abstract final class AppTheme {
  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    const spacing = AppSpacing();
    const radii = AppRadii();
    final textTheme = buildTextTheme(colors);
    final typography = AppTypography.of(colors);

    final scheme = ColorScheme(
      brightness: brightness,
      primary: colors.accent,
      onPrimary: colors.onAccent,
      primaryContainer: colors.accentMuted,
      onPrimaryContainer: colors.textPrimary,
      secondary: colors.credit,
      onSecondary: colors.canvas,
      error: colors.danger,
      onError: colors.onAccent,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      surfaceContainerHighest: colors.surfaceRaised,
      onSurfaceVariant: colors.textSecondary,
      outline: colors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: 'Inter',
      textTheme: textTheme,
      scaffoldBackgroundColor: colors.canvas,
      canvasColor: colors.canvas,
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.canvas,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: 14,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(color: colors.textTertiary),
        helperStyle: textTheme.bodySmall,
        errorStyle: textTheme.bodySmall?.copyWith(color: colors.danger),
        enabledBorder: OutlineInputBorder(
          borderRadius: radii.brMd,
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radii.brMd,
          borderSide: BorderSide(color: colors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radii.brMd,
          borderSide: BorderSide(color: colors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radii.brMd,
          borderSide: BorderSide(color: colors.danger, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: radii.brMd,
          borderSide: BorderSide(color: colors.border.withValues(alpha: 0.5)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.accentMuted,
        height: 68,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelSmall),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? colors.accent
                : colors.textSecondary,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.accentMuted,
        selectedIconTheme: IconThemeData(color: colors.accent, size: 24),
        unselectedIconTheme: IconThemeData(
          color: colors.textSecondary,
          size: 24,
        ),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colors.textPrimary,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceRaised,
        showDragHandle: true,
        dragHandleColor: colors.border,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radii.xl)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.surfaceRaised,
        contentTextStyle: textTheme.bodyMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: radii.brSm),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.accent,
      ),
      splashFactory: InkRipple.splashFactory,
      extensions: [colors, spacing, radii, typography],
    );
  }
}
