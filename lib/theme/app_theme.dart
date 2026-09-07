import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Light and dark themes, both produced by [_build] from a color scheme.
///
/// One builder means the two themes can never drift apart: a component styled
/// here is styled identically in both, and widgets read `Theme.of(context)`
/// instead of hardcoding colors.
abstract final class AppTheme {
  static ThemeData get light =>
      _build(AppColors.light, AppSemanticColors.light);

  static ThemeData get dark => _build(AppColors.dark, AppSemanticColors.dark);

  static ThemeData _build(ColorScheme colors, AppSemanticColors semantic) {
    final text = AppTypography.textTheme(colors);
    final isLight = colors.brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      textTheme: text,
      brightness: colors.brightness,
      scaffoldBackgroundColor: colors.surfaceContainerLow,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      extensions: [semantic],

      appBarTheme: AppBarThemeData(
        backgroundColor: colors.surfaceContainerLow,
        foregroundColor: colors.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
        systemOverlayStyle:
            isLight ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      ),

      cardTheme: CardThemeData(
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: colors.outlineVariant),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: colors.outlineVariant,
        space: 1,
        thickness: 1,
      ),

      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: colors.surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        labelStyle: text.bodyMedium,
        errorStyle: text.bodySmall?.copyWith(color: colors.error),
        border: _border(colors.outlineVariant),
        enabledBorder: _border(colors.outlineVariant),
        focusedBorder: _border(colors.primary, AppSizes.focusedBorderWidth),
        errorBorder: _border(colors.error),
        focusedErrorBorder: _border(colors.error, AppSizes.focusedBorderWidth),
        disabledBorder: _border(colors.outlineVariant.withValues(alpha: 0.5)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: colors.onSurface.withValues(alpha: 0.38),
          minimumSize: const Size(0, AppSizes.buttonHeight),
          elevation: 0,
          textStyle: text.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          minimumSize: const Size(0, AppSizes.buttonHeight),
          textStyle: text.labelLarge,
          side: BorderSide(color: colors.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: text.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 2,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(
          color: colors.onInverseSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: text.titleLarge,
        contentTextStyle: text.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: colors.onSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceContainer,
        side: BorderSide(color: colors.outlineVariant),
        labelStyle: text.labelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.surfaceContainer,
      ),

      iconTheme: IconThemeData(color: colors.onSurface, size: AppSizes.iconLg),
    );
  }

  static OutlineInputBorder _border(
    Color color, [
    double width = AppSizes.borderWidth,
  ]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.md),
    borderSide: BorderSide(color: color, width: width),
  );
}
