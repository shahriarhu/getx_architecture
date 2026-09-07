import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/core/config/app_config.dart';
import 'package:getx_architecture/l10n/app_translations.dart';
import 'package:getx_architecture/l10n/locale_controller.dart';
import 'package:getx_architecture/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared test setup.
///
/// Call [setUpTestApp] from a `setUp` block so translations and configuration
/// behave the same as they do at runtime — otherwise `.tr` returns raw keys and
/// `AppConfig.instance` throws a `LateInitializationError`.
void setUpTestApp() {
  AppConfig.instance = const AppConfig(
    flavor: AppFlavor.dev,
    appName: 'Test App',
    apiBaseUrl: 'https://test.local',
    enableNetworkLogs: false,
  );

  // Never hit the network for fonts during tests.
  GoogleFonts.config.allowRuntimeFetching = false;

  Get.addTranslations(AppTranslations().keys);
  Get.locale = LocaleController.english.locale;
  Get.fallbackLocale = LocaleController.fallback.locale;
}

/// Tears down GetX state so tests cannot leak controllers into each other.
Future<void> tearDownTestApp() => Get.deleteAll(force: true);

/// Pumps [widget] inside a real `GetMaterialApp`, which is what makes
/// `Get.snackbar`, `Get.dialog` and named navigation work under test.
Future<void> pumpApp(
  WidgetTester tester,
  Widget widget, {
  List<GetPage<dynamic>> pages = const [],
  Bindings? binding,
}) async {
  await tester.pumpWidget(
    GetMaterialApp(
      home: widget,
      getPages: pages,
      initialBinding: binding,
      theme: AppTheme.light,
      translations: AppTranslations(),
      locale: LocaleController.english.locale,
      fallbackLocale: LocaleController.fallback.locale,
    ),
  );
  await tester.pump();
}
