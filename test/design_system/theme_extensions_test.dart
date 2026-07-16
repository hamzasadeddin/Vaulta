import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/design_system/design_system.dart';

/// `copyWith` and `lerp` are hand-written per ThemeExtension field, which
/// makes a mis-mapped field (`credit: other.debit`) the realistic bug here.
/// These tests walk every field rather than spot-checking one.
void main() {
  group('AppColors', () {
    // Every field, so a mis-mapped lerp/copyWith cannot hide.
    final fields = <String, Color Function(AppColors)>{
      'canvas': (c) => c.canvas,
      'surface': (c) => c.surface,
      'surfaceRaised': (c) => c.surfaceRaised,
      'border': (c) => c.border,
      'overlay': (c) => c.overlay,
      'textPrimary': (c) => c.textPrimary,
      'textSecondary': (c) => c.textSecondary,
      'textTertiary': (c) => c.textTertiary,
      'accent': (c) => c.accent,
      'onAccent': (c) => c.onAccent,
      'accentMuted': (c) => c.accentMuted,
      'credit': (c) => c.credit,
      'debit': (c) => c.debit,
      'pending': (c) => c.pending,
      'success': (c) => c.success,
      'warning': (c) => c.warning,
      'danger': (c) => c.danger,
      'info': (c) => c.info,
      'skeletonBase': (c) => c.skeletonBase,
      'skeletonHighlight': (c) => c.skeletonHighlight,
    };

    test('lerp at t=0 yields the source for every field', () {
      final lerped = AppColors.dark.lerp(AppColors.light, 0);
      for (final entry in fields.entries) {
        expect(
          entry.value(lerped),
          entry.value(AppColors.dark),
          reason: entry.key,
        );
      }
    });

    test('lerp at t=1 yields the target for every field', () {
      final lerped = AppColors.dark.lerp(AppColors.light, 1);
      for (final entry in fields.entries) {
        expect(
          entry.value(lerped),
          entry.value(AppColors.light),
          reason: entry.key,
        );
      }
    });

    test('lerp with a null target returns the source unchanged', () {
      expect(AppColors.dark.lerp(null, 0.5), same(AppColors.dark));
    });

    test('copyWith replaces only the named field', () {
      final copy = AppColors.dark.copyWith(accent: const Color(0xFF00FF00));
      expect(copy.accent, const Color(0xFF00FF00));
      for (final entry in fields.entries) {
        if (entry.key == 'accent') continue;
        expect(
          entry.value(copy),
          entry.value(AppColors.dark),
          reason: entry.key,
        );
      }
    });

    test('copyWith with no arguments preserves every field', () {
      final copy = AppColors.dark.copyWith();
      for (final entry in fields.entries) {
        expect(
          entry.value(copy),
          entry.value(AppColors.dark),
          reason: entry.key,
        );
      }
    });
  });

  group('AppSpacing', () {
    const source = AppSpacing();
    const target = AppSpacing(
      xxs: 4,
      xs: 8,
      sm: 16,
      md: 32,
      lg: 48,
      xl: 64,
      xxl: 96,
    );

    final fields = <String, double Function(AppSpacing)>{
      'xxs': (s) => s.xxs,
      'xs': (s) => s.xs,
      'sm': (s) => s.sm,
      'md': (s) => s.md,
      'lg': (s) => s.lg,
      'xl': (s) => s.xl,
      'xxl': (s) => s.xxl,
    };

    test('follows a 4pt scale', () {
      expect(source.md, 16);
      expect(source.lg, 24);
      expect(source.screenPadding, const EdgeInsets.symmetric(horizontal: 16));
    });

    test('lerp interpolates every field', () {
      final half = source.lerp(target, 0.5);
      for (final entry in fields.entries) {
        expect(
          entry.value(half),
          (entry.value(source) + entry.value(target)) / 2,
          reason: entry.key,
        );
      }
      expect(source.lerp(null, 0.5), same(source));
    });

    test('copyWith replaces only the named field', () {
      final copy = source.copyWith(md: 99);
      expect(copy.md, 99);
      expect(copy.lg, source.lg);
      expect(copy.xxs, source.xxs);
      expect(source.copyWith().xxl, source.xxl);
    });
  });

  group('AppRadii', () {
    const source = AppRadii();
    const target = AppRadii(xs: 12, sm: 20, md: 28, lg: 40, xl: 56, full: 500);

    test('exposes BorderRadius helpers', () {
      expect(source.brXs, BorderRadius.circular(source.xs));
      expect(source.brSm, BorderRadius.circular(source.sm));
      expect(source.brMd, BorderRadius.circular(source.md));
      expect(source.brLg, BorderRadius.circular(source.lg));
      expect(source.brXl, BorderRadius.circular(source.xl));
      expect(source.brFull, BorderRadius.circular(source.full));
    });

    test('lerp interpolates every field', () {
      final half = source.lerp(target, 0.5);
      expect(half.xs, (source.xs + target.xs) / 2);
      expect(half.sm, (source.sm + target.sm) / 2);
      expect(half.md, (source.md + target.md) / 2);
      expect(half.lg, (source.lg + target.lg) / 2);
      expect(half.xl, (source.xl + target.xl) / 2);
      expect(half.full, (source.full + target.full) / 2);
      expect(source.lerp(null, 0.5), same(source));
    });

    test('copyWith replaces only the named field', () {
      final copy = source.copyWith(lg: 42);
      expect(copy.lg, 42);
      expect(copy.md, source.md);
      expect(source.copyWith().full, source.full);
    });
  });

  group('AppTypography', () {
    final dark = AppTypography.of(AppColors.dark);
    final light = AppTypography.of(AppColors.light);

    test('every money style carries tabular figures', () {
      const tabular = FontFeature.tabularFigures();
      for (final style in [
        dark.balanceDisplay,
        dark.moneyLg,
        dark.moneyMd,
        dark.moneySm,
      ]) {
        expect(style.fontFeatures, contains(tabular));
        expect(style.fontFamily, 'Inter');
      }
    });

    test('balance display is the heaviest, largest style', () {
      expect(dark.balanceDisplay.fontSize, greaterThan(dark.moneyLg.fontSize!));
      expect(dark.balanceDisplay.fontWeight, FontWeight.w800);
    });

    test('lerp interpolates every style', () {
      final half = dark.lerp(light, 0.5);
      expect(
        half.balanceDisplay,
        TextStyle.lerp(dark.balanceDisplay, light.balanceDisplay, 0.5),
      );
      expect(half.moneyLg, TextStyle.lerp(dark.moneyLg, light.moneyLg, 0.5));
      expect(half.moneyMd, TextStyle.lerp(dark.moneyMd, light.moneyMd, 0.5));
      expect(half.moneySm, TextStyle.lerp(dark.moneySm, light.moneySm, 0.5));
      expect(dark.lerp(null, 0.5), same(dark));
    });

    test('copyWith replaces only the named style', () {
      const replacement = TextStyle(fontSize: 11);
      final copy = dark.copyWith(moneySm: replacement);
      expect(copy.moneySm, replacement);
      expect(copy.moneyMd, dark.moneyMd);
      expect(dark.copyWith().balanceDisplay, dark.balanceDisplay);
    });
  });

  group('AppTheme', () {
    test('registers every extension on both brightnesses', () {
      for (final theme in [AppTheme.dark(), AppTheme.light()]) {
        expect(theme.extension<AppColors>(), isNotNull);
        expect(theme.extension<AppSpacing>(), isNotNull);
        expect(theme.extension<AppRadii>(), isNotNull);
        expect(theme.extension<AppTypography>(), isNotNull);
        expect(theme.useMaterial3, isTrue);
      }
    });

    test('dark theme paints the brand canvas, not M3 defaults', () {
      final theme = AppTheme.dark();
      expect(theme.scaffoldBackgroundColor, AppColors.dark.canvas);
      expect(theme.colorScheme.primary, AppColors.dark.accent);
      expect(theme.brightness, Brightness.dark);
    });
  });
}
