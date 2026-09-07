import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import '../core/config/app_config.dart';
import '../l10n/app_translations.dart';
import '../l10n/locale_controller.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

/// Root widget.
///
/// Theme mode and locale are read once here; afterwards `Get.changeThemeMode`
/// and `Get.updateLocale` (called from their controllers) rebuild the app, so
/// this widget never has to be reactive.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final locale = Get.find<LocaleController>();

    return GetMaterialApp(
      title: AppConfig.instance.appName,
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: theme.mode,

      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      unknownRoute: AppPages.unknown,
      defaultTransition: Transition.cupertino,
      transitionDuration: AppDurations.fast,

      translations: AppTranslations(),
      locale: locale.locale,
      fallbackLocale: LocaleController.fallback.locale,
      supportedLocales: LocaleController.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      builder:
          (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
            // Screens with an AppBar take their overlay style from AppBarTheme;
            // this covers the ones without (splash, sign-in), which would
            // otherwise keep the platform default and mis-contrast the icons.
            value: _overlayStyle(Theme.of(context).brightness),
            // Honour the user's font-size preference, but clamp it so layouts
            // stay usable at the extremes.
            child: MediaQuery.withClampedTextScaling(
              minScaleFactor: 0.85,
              maxScaleFactor: 1.4,
              child: child ?? const SizedBox.shrink(),
            ),
          ),
    );
  }

  /// Transparent status bar with icons that contrast against the app's own
  /// background rather than the platform's.
  static SystemUiOverlayStyle _overlayStyle(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // Android reads statusBarIconBrightness; iOS reads statusBarBrightness.
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    );
  }
}
