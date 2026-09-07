import 'package:get/get.dart';

import 'splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // `Get.put`, not `lazyPut`: this controller's whole job is a side effect
    // (restore the session, then navigate). A lazily-registered controller is
    // only built when the view first reads `controller`, and SplashView never
    // does — so it would never run and the app would sit on the splash screen.
    Get.put(SplashController(Get.find()));
  }
}
