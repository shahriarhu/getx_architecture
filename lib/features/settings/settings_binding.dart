import 'package:get/get.dart';

import '../auth/data/auth_repository.dart';
import 'settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AuthRepository(api: Get.find(), session: Get.find()),
      fenix: true,
    );
    Get.lazyPut(
      () => SettingsController(
        theme: Get.find(),
        locale: Get.find(),
        session: Get.find(),
        auth: Get.find(),
      ),
    );
  }
}
