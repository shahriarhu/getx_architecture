import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exception.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../app_text.dart';

/// App-wide transient messages.
///
/// Routed through GetX so a snackbar can be raised from a controller without a
/// `BuildContext` — which is exactly what you need when the trigger is an API
/// failure rather than a tap.
abstract final class AppSnackbar {
  static void success(String message, {String? title}) => _show(
    message,
    title: title,
    icon: Icons.check_circle_outline,
    kind: _Kind.success,
  );

  static void error(String message, {String? title}) => _show(
    message,
    title: title,
    icon: Icons.error_outline,
    kind: _Kind.error,
  );

  static void warning(String message, {String? title}) => _show(
    message,
    title: title,
    icon: Icons.warning_amber_rounded,
    kind: _Kind.warning,
  );

  static void info(String message, {String? title}) =>
      _show(message, title: title, icon: Icons.info_outline, kind: _Kind.info);

  /// Shows the user-facing message of a failure — the single call every
  /// `catch` block in a controller needs.
  static void failure(AppException exception) => error(exception.message);

  static void dismiss() {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
  }

  static void _show(
    String message, {
    required IconData icon,
    required _Kind kind,
    String? title,
  }) {
    final theme = Get.theme;
    final semantic =
        theme.extension<AppSemanticColors>() ??
        (theme.brightness == Brightness.dark
            ? AppSemanticColors.dark
            : AppSemanticColors.light);

    final accent = switch (kind) {
      _Kind.success => semantic.success,
      _Kind.error => theme.colorScheme.error,
      _Kind.warning => semantic.warning,
      _Kind.info => semantic.info,
    };

    // Replace any visible snackbar so messages never stack up.
    dismiss();

    Get.rawSnackbar(
      messageText: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: AppSizes.iconLg),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  AppText.titleSmall(title),
                  const SizedBox(height: AppSpacing.xxs),
                ],
                AppText.bodyMedium(message, maxLines: 4),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.surface,
      borderColor: theme.colorScheme.outlineVariant,
      borderWidth: AppSizes.borderWidth,
      borderRadius: AppRadius.md,
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      duration: AppConstants.snackbarDuration,
      snackPosition: SnackPosition.TOP,
      isDismissible: true,
      boxShadows: const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ],
    );
  }
}

enum _Kind { success, error, warning, info }
