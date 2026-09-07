import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The type scale, built once and tinted per color scheme.
///
/// Uses `google_fonts`, which downloads Inter at first run. To ship fonts in
/// the bundle instead (recommended for production and offline first-launch):
/// add the .ttf files under `assets/fonts/`, declare them in `pubspec.yaml`,
/// then replace [_base] with `Typography.material2021().black.apply(
/// fontFamily: 'Inter')` and set
/// `GoogleFonts.config.allowRuntimeFetching = false`.
abstract final class AppTypography {
  static const fontFamily = 'Inter';

  static TextTheme _base() => GoogleFonts.interTextTheme();

  static TextTheme textTheme(ColorScheme colors) {
    final onSurface = colors.onSurface;
    final muted = colors.onSurfaceVariant;

    return _base()
        .copyWith(
          displayLarge: _style(57, FontWeight.w700, onSurface, 1.12),
          displayMedium: _style(45, FontWeight.w700, onSurface, 1.16),
          displaySmall: _style(36, FontWeight.w700, onSurface, 1.22),
          headlineLarge: _style(30, FontWeight.w700, onSurface, 1.25),
          headlineMedium: _style(26, FontWeight.w700, onSurface, 1.27),
          headlineSmall: _style(22, FontWeight.w600, onSurface, 1.3),
          titleLarge: _style(20, FontWeight.w600, onSurface, 1.35),
          titleMedium: _style(16, FontWeight.w600, onSurface, 1.4),
          titleSmall: _style(14, FontWeight.w600, onSurface, 1.4),
          bodyLarge: _style(16, FontWeight.w400, onSurface, 1.5),
          bodyMedium: _style(14, FontWeight.w400, onSurface, 1.5),
          bodySmall: _style(12, FontWeight.w400, muted, 1.45),
          labelLarge: _style(14, FontWeight.w600, onSurface, 1.2),
          labelMedium: _style(12, FontWeight.w500, muted, 1.2),
          labelSmall: _style(11, FontWeight.w500, muted, 1.2),
        )
        .apply(fontFamily: _base().bodyMedium?.fontFamily);
  }

  static TextStyle _style(
    double size,
    FontWeight weight,
    Color color,
    double height,
  ) => TextStyle(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: size >= 30 ? -0.5 : 0,
  );
}
