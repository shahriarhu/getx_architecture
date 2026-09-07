import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/session/session_service.dart';
import '../../core/session/user.dart';
import '../../l10n/locale_controller.dart';
import '../../l10n/translation_keys.dart';
import '../../theme/theme_controller.dart';
import '../../widgets/feedback/app_dialog.dart';
import '../auth/data/auth_repository.dart';

/// Settings screen logic — a thin coordinator over the app-wide controllers.
class SettingsController extends GetxController {
  SettingsController({
    required ThemeController theme,
    required LocaleController locale,
    required SessionService session,
    required AuthRepository auth,
  }) : _theme = theme,
       _locale = locale,
       _session = session,
       _auth = auth;

  final ThemeController _theme;
  final LocaleController _locale;
  final SessionService _session;
  final AuthRepository _auth;

  final RxBool isSigningOut = false.obs;

  ThemeMode get themeMode => _theme.mode;

  AppLocale get currentLocale => _locale.current;

  List<AppLocale> get locales => LocaleController.supported;

  User? get user => _session.user.value;

  Future<void> setThemeMode(ThemeMode mode) => _theme.setMode(mode);

  Future<void> setLocale(AppLocale locale) => _locale.setLocale(locale);

  Future<void> confirmSignOut() async {
    final confirmed = await AppDialog.confirm(
      title: LocaleKeys.signOut.tr,
      message: LocaleKeys.signOutConfirm.tr,
      confirmLabel: LocaleKeys.signOut.tr,
      isDestructive: true,
    );
    if (!confirmed) return;

    isSigningOut.value = true;
    try {
      await _auth.signOut();
    } finally {
      isSigningOut.value = false;
    }
  }
}
