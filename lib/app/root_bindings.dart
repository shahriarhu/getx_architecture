import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_architecture/app/core/apis/environment.dart';
import 'package:getx_architecture/app/translations/language_controller.dart';
import 'package:getx_architecture/app/ui/theme/theme_controller.dart';

class RootBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    EnvironmentConfig.init(Environment.development);

    await GetStorage.init();

    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    Get.lazyPut<LanguageController>(() => LanguageController(), fenix: true);
  }
}
