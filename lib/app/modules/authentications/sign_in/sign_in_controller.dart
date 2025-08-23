import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_architecture/app/modules/authentications/auth_repository.dart';
import 'package:getx_architecture/app/ui/layouts/view_state_layout.dart';
import 'package:getx_architecture/app/ui/toast.dart';

class SignInController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isObscure = true.obs;
  Rx<DataState> dataState = DataState.initial.obs;

  void toggleObscure() => isObscure.value = !isObscure.value;

  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) return;

    try {
      dataState(DataState.loading);

      await _authRepository.signIn(
        emailController.text,
        passwordController.text,
      );

      dataState(DataState.success);

      /// Get.offAllNamed(AppRoutes.home);
    } on DioException catch (e) {
      dataState(DataState.error);
    } catch (e) {
      showError('somethingWentWrongTryAgain'.tr);
      dataState(DataState.error);
    }
  }
}
