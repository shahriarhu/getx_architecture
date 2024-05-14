import 'package:get/get.dart';
import 'package:getx_architecture/app/core/controllers/sing_in_controller.dart';

class SignInBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
  }
}
