import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/app/core/commons/auth/auth_session.dart';
import 'package:getx_architecture/app/core/commons/auth/auth_tokens.dart';
import 'package:getx_architecture/app/root_bindings.dart';
import 'package:getx_architecture/app/routes/app_pages.dart';
import 'package:getx_architecture/app/translations/language_controller.dart';
import 'package:getx_architecture/app/translations/translation.dart';
import 'package:getx_architecture/app/ui/theme/theme.dart';
import 'package:getx_architecture/app/ui/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RootBindings().dependencies();

  final tokenStore = SecureTokenStoreImpl();
  final authSession = AuthSession(tokenStore);

  final signedIn = await authSession.isSignedIn();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GetX Architecture',
      initialRoute: AppPages.getInitialPage(signedIn),
      getPages: AppPages.routes,
      // initialBinding: InitialBinding(),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeController.getThemeMode,
      translations: AppTranslations(),
      locale: langController.selectedLocale,
      fallbackLocale: langController.localeEn.locale,
    ),
  );
}
