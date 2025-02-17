import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/app/modules/sign_in/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
