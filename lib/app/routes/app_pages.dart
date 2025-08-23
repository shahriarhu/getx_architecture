import 'package:get/get.dart';
import 'package:getx_architecture/app/modules/authentications/sign_in/sign_in_binding.dart';
import 'package:getx_architecture/app/modules/authentications/sign_in/sign_in_view.dart';
import 'package:getx_architecture/app/routes/app_routes.dart';
import 'package:getx_architecture/app/utils/user_provider.dart';

abstract class AppPages {
  AppPages._();

  static String getInitialPage() {
    bool isSignedIn = UserProvider.userCred.token?.isNotEmpty ?? false;

    if (isSignedIn) {
      return AppRoutes.signIn;
    } else {
      return AppRoutes.signIn;
    }
  }

  static final routes = [
    GetPage(
      name: AppRoutes.signIn,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
  ];
}
