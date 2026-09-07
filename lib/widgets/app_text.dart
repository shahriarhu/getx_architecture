import 'package:flutter/material.dart';

/// Selects a style from the active [TextTheme].
typedef TextStyleSelector = TextStyle? Function(TextTheme theme);

/// The app's single text widget.
///
/// It replaces a class-per-size hierarchy with one class and a named
/// constructor per Material 3 style, so styles always come from the theme and
/// never from hardcoded font sizes. Null text renders as empty rather than
/// throwing, and setting [maxLines] turns on ellipsis automatically.
///
/// ```dart
/// AppText.titleMedium(user.name)
/// AppText.bodySmall(article.body, maxLines: 2, color: context.colors.outline)
/// ```
class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.selector = _bodyMedium,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  });

  const AppText.displayLarge(
    this.data, {
    super.key,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  }) : selector = _displayLarge;

  const AppText.displayMedium(
    this.data, {
    super.key,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  }) : selector = _displayMedium;

  const AppText.displaySmall(
    this.data, {
    super.key,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  }) : selector = _displaySmall;

  const AppText.headlineLarge(
    this.data, {
    super.key,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  }) : selector = _headlineLarge;

  const AppText.headlineMedium(
    this.data, {
    super.key,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  }) : selector = _headlineMedium;

  const AppText.headlineSmall(
    this.data, {
    super.key,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  }) : selector = _headlineSmall;

  const AppText.titleLarge(
    this.data, {
    super.key,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  }) : selector = _titleLarge;

  const AppText.titleMedium(
    this.data, {
    super.key,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  }) : selector = _titleMedium;

  const AppText.titleSmall(
    this.data, {
    super.key,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  }) : selector = _titleSmall;

  const AppText.bodyLarge(
    this.data, {
    super.key,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  }) : selector = _bodyLarge;

  const AppText.bodyMedium(
    this.data, {
    super.key,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  }) : selector = _bodyMedium;

  const AppText.bodySmall(
    this.data, {
    super.key,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  }) : selector = _bodySmall;

  const AppText.labelLarge(
    this.data, {
    super.key,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  }) : selector = _labelLarge;

  const AppText.labelMedium(
    this.data, {
    super.key,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  }) : selector = _labelMedium;

  const AppText.labelSmall(
    this.data, {
    super.key,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.weight,
    this.decoration,
    this.softWrap = true,
    this.style,
  }) : selector = _labelSmall;

  final String? data;
  final TextStyleSelector selector;
  final Color? color;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? weight;
  final TextDecoration? decoration;
  final bool softWrap;

  /// Merged last — for the rare one-off tweak.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base = selector(Theme.of(context).textTheme) ?? const TextStyle();

    return Text(
      data ?? '',
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      style: base
          .copyWith(color: color, fontWeight: weight, decoration: decoration)
          .merge(style),
    );
  }

  static TextStyle? _displayLarge(TextTheme theme) => theme.displayLarge;

  static TextStyle? _displayMedium(TextTheme theme) => theme.displayMedium;

  static TextStyle? _displaySmall(TextTheme theme) => theme.displaySmall;

  static TextStyle? _headlineLarge(TextTheme theme) => theme.headlineLarge;

  static TextStyle? _headlineMedium(TextTheme theme) => theme.headlineMedium;

  static TextStyle? _headlineSmall(TextTheme theme) => theme.headlineSmall;

  static TextStyle? _titleLarge(TextTheme theme) => theme.titleLarge;

  static TextStyle? _titleMedium(TextTheme theme) => theme.titleMedium;

  static TextStyle? _titleSmall(TextTheme theme) => theme.titleSmall;

  static TextStyle? _bodyLarge(TextTheme theme) => theme.bodyLarge;

  static TextStyle? _bodyMedium(TextTheme theme) => theme.bodyMedium;

  static TextStyle? _bodySmall(TextTheme theme) => theme.bodySmall;

  static TextStyle? _labelLarge(TextTheme theme) => theme.labelLarge;

  static TextStyle? _labelMedium(TextTheme theme) => theme.labelMedium;

  static TextStyle? _labelSmall(TextTheme theme) => theme.labelSmall;
}
