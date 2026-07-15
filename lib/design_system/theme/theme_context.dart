import 'package:flutter/material.dart';
import 'package:vaulta/design_system/theme/app_colors.dart';
import 'package:vaulta/design_system/theme/app_dimens.dart';
import 'package:vaulta/design_system/theme/app_typography.dart';

/// `context.colors.accent`, `context.spacing.md`, `context.radii.brLg`, …
extension ThemeContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textStyles => theme.textTheme;

  AppColors get colors => theme.extension<AppColors>()!;

  AppSpacing get spacing => theme.extension<AppSpacing>()!;

  AppRadii get radii => theme.extension<AppRadii>()!;

  AppTypography get typography => theme.extension<AppTypography>()!;
}
