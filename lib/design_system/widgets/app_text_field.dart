import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/theme/theme_context.dart';

/// Themed text input. Visual states (focus, error, disabled) come from
/// [InputDecorationTheme]; this widget adds the external label, the obscure
/// toggle, and a consistent prop surface for the formz layer (Phase 3+).
class AppTextField extends StatefulWidget {
  const AppTextField({
    this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.helperText,
    this.obscure = false,
    this.prefixIcon,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofillHints,
    this.inputFormatters,
    this.focusNode,
    this.autocorrect = true,
    super.key,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final String? helperText;

  /// Renders as a password field with a reveal toggle.
  final bool obscure;

  final IconData? prefixIcon;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autocorrect;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscure;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = widget.label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label, style: context.textStyles.labelMedium),
          SizedBox(height: context.spacing.sm - 2),
        ],
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          obscureText: _obscured,
          autocorrect: widget.autocorrect && !widget.obscure,
          enableSuggestions: !widget.obscure,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          autofillHints: widget.autofillHints,
          inputFormatters: widget.inputFormatters,
          style: context.textStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            helperText: widget.helperText,
            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(
                    widget.prefixIcon,
                    size: 20,
                    color: colors.textSecondary,
                  ),
            suffixIcon: widget.obscure
                ? IconButton(
                    onPressed: () => setState(() => _obscured = !_obscured),
                    tooltip: _obscured ? 'Show' : 'Hide',
                    icon: Icon(
                      _obscured ? LucideIcons.eye : LucideIcons.eyeOff,
                      size: 20,
                      color: colors.textSecondary,
                    ),
                  )
                : widget.suffix,
          ),
        ),
      ],
    );
  }
}
