import 'package:get/get.dart';
import 'package:getx_architecture/app/core/services/auth_services.dart';

class SignInController extends GetxController {
  RxInt myInt = 0.obs;

  final _authService = AuthServices();

  void signIn() {
    _authService.signIn('01517033430', '12345678');
  }
}
