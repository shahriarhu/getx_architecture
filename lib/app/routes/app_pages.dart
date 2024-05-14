import 'package:get/get.dart';
import 'package:getx_architecture/app/core/bindings/sing_in_bindings.dart';
import 'package:getx_architecture/app/routes/app_routes.dart';
import 'package:getx_architecture/app/ui/views/sign_in_view.dart';

abstract class AppPages {
  AppPages._();

  static const initial = Routes.signIn;

  static final routes = [
    GetPage(
      name: Routes.signIn,
      page: () => const SignInView(),
      binding: SignInBindings(),
    ),
  ];
}
