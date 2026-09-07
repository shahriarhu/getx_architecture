import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_spacing.dart';
import '../app_text.dart';

/// Labelled form field used across the app.
///
/// Wraps [TextFormField] so every field gets the same label treatment,
/// required marker and validation styling. [AppTextField.password] owns its own
/// obscure-text toggle, which keeps that piece of UI state out of controllers.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.isRequired = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofillHints,
    this.inputFormatters,
    this.onTap,
  }) : obscure = false,
       isPassword = false;

  /// Password field with a built-in show/hide toggle.
  const AppTextField.password({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.validator,
    this.textInputAction,
    this.prefixIcon = Icons.lock_outline,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.isRequired = false,
    this.autofocus = false,
    this.autofillHints = const [AutofillHints.password],
  }) : obscure = true,
       isPassword = true,
       keyboardType = TextInputType.visiblePassword,
       suffixIcon = null,
       readOnly = false,
       maxLines = 1,
       minLines = null,
       maxLength = null,
       inputFormatters = null,
       onTap = null;

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool enabled;
  final bool readOnly;
  final bool isRequired;
  final bool autofocus;
  final bool obscure;
  final bool isPassword;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscure;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              AppText.labelLarge(widget.label),
              if (widget.isRequired)
                AppText.labelLarge(' *', color: colors.error),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.controller == null ? widget.initialValue : null,
          focusNode: widget.focusNode,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction:
              widget.textInputAction ??
              (widget.maxLines > 1
                  ? TextInputAction.newline
                  : TextInputAction.next),
          obscureText: _obscured,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          maxLines: _obscured ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          autofillHints: widget.autofillHints,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon:
                widget.prefixIcon == null
                    ? null
                    : Icon(widget.prefixIcon, size: AppSizes.iconLg),
            suffixIcon: _buildSuffix(),
            counterText: '',
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffix() {
    if (!widget.isPassword) return widget.suffixIcon;

    return IconButton(
      onPressed: () => setState(() => _obscured = !_obscured),
      icon: Icon(
        _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: AppSizes.iconLg,
      ),
      tooltip: _obscured ? 'Show password' : 'Hide password',
    );
  }
}
