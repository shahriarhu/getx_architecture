import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

enum AppButtonVariant { filled, outlined, text, danger }

enum AppButtonSize { small, medium, large }

/// The app's button.
///
/// One widget with variants rather than a subclass per style: the loading
/// state, minimum tap target and icon spacing are then guaranteed to be
/// consistent everywhere. A button is disabled while [loading], so a
/// double-tap cannot fire two requests.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = true,
  });

  const AppButton.outlined({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = true,
  }) : variant = AppButtonVariant.outlined;

  const AppButton.text({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = false,
  }) : variant = AppButtonVariant.text;

  const AppButton.danger({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = true,
  }) : variant = AppButtonVariant.danger;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool loading;

  /// Stretches to the parent's width. Off by default for text buttons.
  final bool expanded;

  bool get _enabled => onPressed != null && !loading;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final child = _Content(
      label: label,
      icon: icon,
      trailingIcon: trailingIcon,
      loading: loading,
      size: size,
    );

    final button = switch (variant) {
      AppButtonVariant.filled => ElevatedButton(
        onPressed: _enabled ? onPressed : null,
        style: _style(),
        child: child,
      ),
      AppButtonVariant.danger => ElevatedButton(
        onPressed: _enabled ? onPressed : null,
        style: _style().copyWith(
          backgroundColor: WidgetStatePropertyAll(colors.error),
          foregroundColor: WidgetStatePropertyAll(colors.onError),
        ),
        child: child,
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: _enabled ? onPressed : null,
        style: _style(),
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: _enabled ? onPressed : null,
        style: _style(),
        child: child,
      ),
    };

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }

  ButtonStyle _style() => ButtonStyle(
    minimumSize: WidgetStatePropertyAll(Size(0, _height)),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: _horizontalPadding),
    ),
  );

  double get _height => switch (size) {
    AppButtonSize.small => 36,
    AppButtonSize.medium => AppSizes.buttonHeight,
    AppButtonSize.large => 56,
  };

  double get _horizontalPadding => switch (size) {
    AppButtonSize.small => AppSpacing.md,
    AppButtonSize.medium => AppSpacing.lg,
    AppButtonSize.large => AppSpacing.xl,
  };
}

class _Content extends StatelessWidget {
  const _Content({
    required this.label,
    required this.icon,
    required this.trailingIcon,
    required this.loading,
    required this.size,
  });

  final String label;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool loading;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    final iconSize =
        size == AppButtonSize.small ? AppSizes.iconMd : AppSizes.iconLg;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading) ...[
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: DefaultTextStyle.of(context).style.color,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (icon != null) ...[
          Icon(icon, size: iconSize),
          const SizedBox(width: AppSpacing.sm),
        ],
        // Deliberately a plain `Text`: the label must inherit the button's
        // foreground color. `AppText` resolves a color from the text theme,
        // which would paint the label as body text on a filled button.
        Flexible(
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        if (trailingIcon != null && !loading) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(trailingIcon, size: iconSize),
        ],
      ],
    );
  }
}
