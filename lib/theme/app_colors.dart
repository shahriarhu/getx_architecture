import 'package:flutter/material.dart';

/// Brand palette and the color schemes derived from it.
///
/// Rebranding starts and ends here: change [seed] and Material generates a
/// complete, contrast-checked scheme for both brightnesses.
abstract final class AppColors {
  static const seed = Color(0xFF4F46E5);

  // Raw brand values — use these only to build schemes, never in widgets.
  static const brand = Color(0xFF4F46E5);
  static const brandDark = Color(0xFF3730A3);
  static const accent = Color(0xFF06B6D4);

  static const success = Color(0xFF15803D);
  static const successDark = Color(0xFF4ADE80);
  static const warning = Color(0xFFB45309);
  static const warningDark = Color(0xFFFBBF24);
  static const info = Color(0xFF1D4ED8);
  static const infoDark = Color(0xFF60A5FA);
  static const danger = Color(0xFFB91C1C);
  static const dangerDark = Color(0xFFF87171);

  static final ColorScheme light = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
  ).copyWith(
    primary: brand,
    secondary: accent,
    error: danger,
    surface: const Color(0xFFFFFFFF),
    surfaceContainerLowest: const Color(0xFFFFFFFF),
    surfaceContainerLow: const Color(0xFFF8FAFC),
    surfaceContainer: const Color(0xFFF1F5F9),
    outlineVariant: const Color(0xFFE2E8F0),
  );

  static final ColorScheme dark = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  ).copyWith(
    primary: const Color(0xFF8B87F5),
    secondary: const Color(0xFF22D3EE),
    error: dangerDark,
    surface: const Color(0xFF101014),
    surfaceContainerLowest: const Color(0xFF0B0B0E),
    surfaceContainerLow: const Color(0xFF16161B),
    surfaceContainer: const Color(0xFF1C1C22),
    outlineVariant: const Color(0xFF2E2E36),
  );
}

/// Colors Material's [ColorScheme] has no slot for.
///
/// A [ThemeExtension] keeps them theme-aware — `context.semantic.success`
/// resolves correctly in light and dark without any `isDarkMode` branching at
/// the call site.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.onStatus,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.overlay,
  });

  final Color success;
  final Color warning;
  final Color info;

  /// Foreground for content placed on any status color.
  final Color onStatus;

  final Color shimmerBase;
  final Color shimmerHighlight;

  /// Scrim behind modals and blocking loaders.
  final Color overlay;

  static const light = AppSemanticColors(
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
    onStatus: Color(0xFFFFFFFF),
    shimmerBase: Color(0xFFE2E8F0),
    shimmerHighlight: Color(0xFFF8FAFC),
    overlay: Color(0x66000000),
  );

  static const dark = AppSemanticColors(
    success: AppColors.successDark,
    warning: AppColors.warningDark,
    info: AppColors.infoDark,
    onStatus: Color(0xFF0B0B0E),
    shimmerBase: Color(0xFF23232B),
    shimmerHighlight: Color(0xFF2F2F39),
    overlay: Color(0x99000000),
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? onStatus,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? overlay,
  }) => AppSemanticColors(
    success: success ?? this.success,
    warning: warning ?? this.warning,
    info: info ?? this.info,
    onStatus: onStatus ?? this.onStatus,
    shimmerBase: shimmerBase ?? this.shimmerBase,
    shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    overlay: overlay ?? this.overlay,
  );

  @override
  AppSemanticColors lerp(covariant AppSemanticColors? other, double t) {
    if (other == null) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      onStatus: Color.lerp(onStatus, other.onStatus, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight:
          Color.lerp(
            shimmerHighlight,
            other.shimmerHighlight,
            t,
          )!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }
}
