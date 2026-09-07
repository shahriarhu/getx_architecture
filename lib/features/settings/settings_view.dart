import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/config/app_config.dart';
import '../../core/extensions/num_extensions.dart';
import '../../core/extensions/string_extensions.dart';
import '../../l10n/locale_controller.dart';
import '../../l10n/translation_keys.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/app_text.dart';
import '../../widgets/buttons/app_button.dart';
import '../../widgets/layouts/app_scaffold.dart';
import '../../widgets/layouts/responsive_layout.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: LocaleKeys.settings.tr,
      body: ConstrainedBody(
        child: ListView(
          children: [
            AppSpacing.md.verticalSpace,
            const _AccountCard(),
            AppSpacing.xl.verticalSpace,

            _Section(
              title: LocaleKeys.appearance.tr,
              child: Obx(
                () => RadioGroup<ThemeMode>(
                  groupValue: controller.themeMode,
                  onChanged: (mode) {
                    if (mode != null) unawaited(controller.setThemeMode(mode));
                  },
                  child: Column(
                    children: [
                      for (final mode in ThemeMode.values)
                        RadioListTile<ThemeMode>(
                          value: mode,
                          contentPadding: EdgeInsets.zero,
                          title: AppText.bodyLarge(_themeLabel(mode)),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            _Section(
              title: LocaleKeys.language.tr,
              child: Obx(
                () => RadioGroup<AppLocale>(
                  groupValue: controller.currentLocale,
                  onChanged: (locale) {
                    if (locale != null) unawaited(controller.setLocale(locale));
                  },
                  child: Column(
                    children: [
                      for (final locale in controller.locales)
                        RadioListTile<AppLocale>(
                          value: locale,
                          contentPadding: EdgeInsets.zero,
                          title: AppText.bodyLarge(locale.nativeName),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            _Section(
              title: LocaleKeys.about.tr,
              child: Column(
                children: [
                  _InfoRow(
                    label: LocaleKeys.version.tr,
                    value: '1.0.0 (${AppConfig.instance.flavor.name})',
                  ),
                ],
              ),
            ),

            AppSpacing.xl.verticalSpace,
            Obx(
              () => AppButton.danger(
                label: LocaleKeys.signOut.tr,
                icon: Icons.logout_rounded,
                loading: controller.isSigningOut.value,
                onPressed: controller.confirmSignOut,
              ),
            ),
            AppSpacing.xxl.verticalSpace,
          ],
        ),
      ),
    );
  }

  String _themeLabel(ThemeMode mode) => switch (mode) {
    ThemeMode.system => LocaleKeys.themeSystem.tr,
    ThemeMode.light => LocaleKeys.themeLight.tr,
    ThemeMode.dark => LocaleKeys.themeDark.tr,
  };
}

class _AccountCard extends StatelessWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    final colors = Theme.of(context).colorScheme;

    return Obx(() {
      final user = controller.user;
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              CircleAvatar(
                radius: AppSizes.avatarMd / 2,
                backgroundColor: colors.primaryContainer,
                child: AppText.titleMedium(
                  user?.initials ?? '?',
                  color: colors.onPrimaryContainer,
                ),
              ),
              AppSpacing.lg.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.titleMedium(
                      user?.name.ifBlank(LocaleKeys.account.tr),
                      maxLines: 1,
                    ),
                    AppText.bodySmall(user?.email ?? '—', maxLines: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText.labelLarge(
        title.toUpperCase(),
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      AppSpacing.sm.verticalSpace,
      child,
      AppSpacing.lg.verticalSpace,
    ],
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.bodyLarge(label),
        AppText.bodyMedium(
          value,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    ),
  );
}
