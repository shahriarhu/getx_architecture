import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'theme_model.dart';

class ThemeController extends GetxController {
  static final instance = Get.find<ThemeController>();
  final _getStorage = GetStorage();
  Rx<bool> isDark = false.obs;
  static const theme = 'theme';

  String get currentTheme => _getStorage.read(theme) ?? ThemeMode.system.name;

  ThemeMode get getThemeMode {
    if (currentTheme == 'dark') {
      return ThemeMode.dark;
    } else if (currentTheme == 'light') {
      return ThemeMode.light;
    } else {
      return ThemeMode.light;
    }
  }

  ThemeModel darkTheme = ThemeModel(
    icon: Icons.dark_mode_rounded,
    title: 'dark',
    themeMode: ThemeMode.dark,
  );
  ThemeModel lightTheme = ThemeModel(
    icon: Icons.wb_sunny_rounded,
    title: 'light',
    themeMode: ThemeMode.light,
  );

  List<ThemeModel> get themes => [darkTheme, lightTheme];

  @override
  void onInit() {
    isDark.value = getThemeMode == ThemeMode.dark;
    super.onInit();
  }

  void saveThemeMode(ThemeMode themeMode) => _getStorage.write(theme, themeMode.name);

  void setThemeMode(ThemeMode themeMode) {
    saveThemeMode(themeMode);
    isDark.value = themeMode == ThemeMode.dark;
    Get.changeThemeMode(themeMode);
    update();
  }
}

ThemeController themeController = ThemeController.instance;
