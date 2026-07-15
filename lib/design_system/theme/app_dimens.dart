import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 4pt spacing scale. Use `context.spacing` — no magic paddings.
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    this.xxs = 2,
    this.xs = 4,
    this.sm = 8,
    this.md = 16,
    this.lg = 24,
    this.xl = 32,
    this.xxl = 48,
  });

  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  /// Default horizontal screen inset.
  EdgeInsets get screenPadding => EdgeInsets.symmetric(horizontal: md);

  @override
  AppSpacing copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return AppSpacing(
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  AppSpacing lerp(AppSpacing? other, double t) {
    if (other == null) return this;
    double l(double a, double b) => lerpDouble(a, b, t)!;
    return AppSpacing(
      xxs: l(xxs, other.xxs),
      xs: l(xs, other.xs),
      sm: l(sm, other.sm),
      md: l(md, other.md),
      lg: l(lg, other.lg),
      xl: l(xl, other.xl),
      xxl: l(xxl, other.xxl),
    );
  }
}

/// Corner radii. `full` yields pill shapes.
class AppRadii extends ThemeExtension<AppRadii> {
  const AppRadii({
    this.xs = 6,
    this.sm = 10,
    this.md = 14,
    this.lg = 20,
    this.xl = 28,
    this.full = 999,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double full;

  BorderRadius get brXs => BorderRadius.circular(xs);
  BorderRadius get brSm => BorderRadius.circular(sm);
  BorderRadius get brMd => BorderRadius.circular(md);
  BorderRadius get brLg => BorderRadius.circular(lg);
  BorderRadius get brXl => BorderRadius.circular(xl);
  BorderRadius get brFull => BorderRadius.circular(full);

  @override
  AppRadii copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? full,
  }) {
    return AppRadii(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      full: full ?? this.full,
    );
  }

  @override
  AppRadii lerp(AppRadii? other, double t) {
    if (other == null) return this;
    double l(double a, double b) => lerpDouble(a, b, t)!;
    return AppRadii(
      xs: l(xs, other.xs),
      sm: l(sm, other.sm),
      md: l(md, other.md),
      lg: l(lg, other.lg),
      xl: l(xl, other.xl),
      full: l(full, other.full),
    );
  }
}
