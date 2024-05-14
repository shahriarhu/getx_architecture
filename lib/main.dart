import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_architecture/app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GetX Architecture',
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      // initialBinding: InitialBinding(),
      // theme: lightTheme,
      // darkTheme: darkTheme,
      // themeMode: themeController.getThemes,
      // translations: AppTranslations(),
      // locale: langController.selectedLocale,
      // fallbackLocale: langController.localeEn.locale,
    ),
  );
}

// class RootBinding implements Bindings {
//   @override
//   Future<dynamic> dependencies() async {
//     await GetStorage.init();
//   }
// }
