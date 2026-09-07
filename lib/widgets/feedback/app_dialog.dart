import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../l10n/translation_keys.dart';
import '../../theme/app_spacing.dart';
import '../app_text.dart';
import '../buttons/app_button.dart';

/// Context-free dialogs, for the same reason as [AppSnackbar]: controllers
/// need to ask a question without holding a `BuildContext`.
abstract final class AppDialog {
  /// Returns true only when the user explicitly confirms.
  static Future<bool> confirm({
    required String title,
    String? message,
    String? confirmLabel,
    String? cancelLabel,
    bool isDestructive = false,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: AppText.titleLarge(title),
        content: message == null ? null : AppText.bodyMedium(message),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        actions: [
          AppButton.text(
            label: cancelLabel ?? LocaleKeys.cancel.tr,
            onPressed: () => Get.back<bool>(result: false),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (isDestructive)
            AppButton.danger(
              label: confirmLabel ?? LocaleKeys.confirm.tr,
              expanded: false,
              onPressed: () => Get.back<bool>(result: true),
            )
          else
            AppButton(
              label: confirmLabel ?? LocaleKeys.confirm.tr,
              expanded: false,
              onPressed: () => Get.back<bool>(result: true),
            ),
        ],
      ),
      barrierDismissible: true,
    );

    return result ?? false;
  }

  /// Blocking spinner for operations with no other visible progress.
  /// Always pair with [hideLoading] in a `finally`.
  static void showLoading() {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog<void>(
      const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen ?? false) Get.back<void>();
  }
}
