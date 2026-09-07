import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/errors/app_exception.dart';
import '../../l10n/translation_keys.dart';
import '../../theme/app_spacing.dart';
import '../app_text.dart';
import '../buttons/app_button.dart';

/// Centered spinner — the default while a screen loads.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.lg),
          AppText.bodyMedium(message, align: TextAlign.center),
        ],
      ],
    ),
  );
}

/// Shared layout for the "nothing to show" and "it broke" screens, so both
/// always look like they belong to the same app.
class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: iconColor ?? colors.onSurfaceVariant),
            const SizedBox(height: AppSpacing.lg),
            AppText.titleMedium(title, align: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              AppText.bodyMedium(
                message,
                align: TextAlign.center,
                color: colors.onSurfaceVariant,
              ),
            ],
            if (onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              AppButton.outlined(
                label: actionLabel ?? LocaleKeys.retry.tr,
                onPressed: onAction,
                expanded: false,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shown when a request succeeded but returned nothing.
class EmptyView extends StatelessWidget {
  const EmptyView({super.key, this.title, this.message, this.onRetry});

  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => MessageView(
    icon: Icons.inbox_outlined,
    title: title ?? LocaleKeys.noDataFound.tr,
    message: message ?? LocaleKeys.noDataFoundMessage.tr,
    onAction: onRetry,
  );
}

/// Shown when a request failed. Offers a retry only for transient failures —
/// there is no point retrying a 403.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry});

  final AppException error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final isOffline = error.type == AppErrorType.network;

    return MessageView(
      icon: isOffline ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
      iconColor: Theme.of(context).colorScheme.error,
      title:
          isOffline ? LocaleKeys.offline.tr : LocaleKeys.somethingWentWrong.tr,
      message: error.message,
      onAction: onRetry,
    );
  }
}
