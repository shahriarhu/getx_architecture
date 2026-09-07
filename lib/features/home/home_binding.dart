import 'package:get/get.dart';

import 'data/home_repository.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeRepository(Get.find()));
    Get.lazyPut(
      () => HomeController(repository: Get.find(), session: Get.find()),
    );
  }
}
