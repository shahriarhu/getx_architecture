import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/app/core/controllers/sing_in_controller.dart';
import 'package:getx_architecture/app/utils/user_provider.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('MD Shahriar Hossain'),
              Obx(
                () => Text(
                  controller.myInt.value.toString(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.myInt.value = controller.myInt.value + 1;

                  controller.signIn();
                  // UserProvider.removeUser();
                },
                child: const Text('Hello'),
              ),
              ElevatedButton(
                onPressed: () {
                  print(UserProvider.userCred.name);
                  print(UserProvider.userCred.mobileNumber);
                  print(UserProvider.userCred.token);
                  print(UserProvider.userCred.email);
                  print(UserProvider.userCred.shopCount);
                  print(UserProvider.userCred.language);
                },
                child: const Text('GET DATA'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
