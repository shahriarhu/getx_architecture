import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/session/auth_tokens.dart';
import '../../../core/session/session_service.dart';
import '../../../core/session/user.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/feedback/app_snackbar.dart';
import '../data/auth_repository.dart';

/// Screen logic for sign-in.
///
/// The controller owns form state and talks only to [AuthRepository] — it has
/// no idea HTTP exists, which is what keeps it unit-testable.
class SignInController extends GetxController {
  SignInController({
    required AuthRepository repository,
    required SessionService session,
  }) : _repository = repository,
       _session = session;

  final AuthRepository _repository;
  final SessionService _session;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isSubmitting = false.obs;

  late final emailValidator = Validators.compose([
    Validators.required(),
    Validators.email(),
  ]);

  late final passwordValidator = Validators.compose([
    Validators.required(),
    Validators.password(),
  ]);

  Future<void> submit() async {
    if (isSubmitting.value) return;
    if (!(formKey.currentState?.validate() ?? false)) return;

    isSubmitting.value = true;
    try {
      await _repository.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    } on AppException catch (error) {
      AppSnackbar.failure(error);
      return;
    } finally {
      isSubmitting.value = false;
    }

    _goHome();
  }

  /// Demo shortcut so the starter can be explored without a backend.
  /// Only reachable outside production — delete it in a real app.
  Future<void> continueAsDemoUser() async {
    await _session.start(
      tokens: AuthTokens(
        accessToken: 'demo-access-token',
        refreshToken: 'demo-refresh-token',
        accessExpiry: DateTime.now().add(const Duration(days: 7)),
      ),
      user: const User(
        id: 'demo',
        name: 'Demo User',
        email: 'demo@example.com',
      ),
    );
    _goHome();
  }

  /// Navigation is deliberately not awaited: the future returned by
  /// `Get.offAllNamed` completes only when the *new* route is popped, so
  /// awaiting it would leave the submit button spinning forever.
  void _goHome() => unawaited(Get.offAllNamed<void>(AppRoutes.home));

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
