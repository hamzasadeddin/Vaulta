import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vaulta/design_system/theme/theme_context.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

enum AppButtonSize { small, medium, large }

/// The app's only button. `FilledButton` & co. are not used directly so
/// every touchpoint shares one visual contract.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.loading = false,
    this.expand = false,
    super.key,
  });

  final String label;

  /// `null` renders the disabled state.
  final VoidCallback? onPressed;

  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;

  /// Shows a spinner and suppresses taps; keeps width stable.
  final bool loading;

  /// Stretch to the available width (primary CTAs).
  final bool expand;

  bool get _enabled => onPressed != null && !loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final (Color background, Color foreground) = switch (variant) {
      AppButtonVariant.primary => (colors.accent, colors.onAccent),
      AppButtonVariant.secondary => (colors.accentMuted, colors.textPrimary),
      AppButtonVariant.ghost => (Colors.transparent, colors.textPrimary),
      AppButtonVariant.danger => (colors.danger, colors.onAccent),
    };
    final resolvedBackground = _enabled
        ? background
        : (variant == AppButtonVariant.ghost
            ? Colors.transparent
            : colors.surfaceRaised);
    final resolvedForeground = _enabled ? foreground : colors.textTertiary;

    final (double height, double hPadding, double fontSize) = switch (size) {
      AppButtonSize.small => (36, 12, 13),
      AppButtonSize.medium => (48, 16, 15),
      AppButtonSize.large => (56, 20, 16),
    };

    final textStyle = context.textStyles.labelLarge?.copyWith(
      fontSize: fontSize,
      color: resolvedForeground,
    );

    return Semantics(
      button: true,
      enabled: _enabled,
      label: label,
      child: SizedBox(
        height: height,
        width: expand ? double.infinity : null,
        child: Material(
          color: resolvedBackground,
          borderRadius: context.radii.brMd,
          child: InkWell(
            onTap: _enabled ? _handleTap : null,
            borderRadius: context.radii.brMd,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: Row(
                mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: loading
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: resolvedForeground,
                              ),
                            ),
                          )
                        : icon != null
                            ? Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(
                                  icon,
                                  size: 18,
                                  color: resolvedForeground,
                                ),
                              )
                            : const SizedBox.shrink(),
                  ),
                  Flexible(
                    child: Text(
                      label,
                      style: textStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    unawaited(HapticFeedback.selectionClick());
    onPressed?.call();
  }
}
