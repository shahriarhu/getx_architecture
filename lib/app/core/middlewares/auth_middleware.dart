import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/app/routes/app_routes.dart';
import 'package:getx_architecture/app/utils/user_provider.dart';

class AuthMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (UserProvider.userCred.token == null || UserProvider.userCred.token == '') {
      return const RouteSettings(name: Routes.signIn);
    }
    return null;
  }
}
