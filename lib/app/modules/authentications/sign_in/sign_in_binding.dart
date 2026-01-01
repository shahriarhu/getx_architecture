import 'package:get/get.dart';
import 'package:getx_architecture/app/modules/authentications/auth_repository.dart';
import 'package:getx_architecture/app/modules/authentications/auth_services.dart';
import 'package:getx_architecture/app/modules/authentications/sign_in/sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthServices(apiClient: Get.find()));
    Get.lazyPut(() => AuthRepository(Get.find()));
    Get.lazyPut(() => SignInController(Get.find()));
  }
}
