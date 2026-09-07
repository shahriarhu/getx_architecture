import 'package:get/get.dart';

import '../../../core/session/session_service.dart';
import '../data/auth_repository.dart';
import 'sign_in_controller.dart';

/// Feature-scoped dependencies.
///
/// `Get.find()` resolves the app-wide services registered in `AppBindings`;
/// everything created here is disposed with the route.
class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AuthRepository(api: Get.find(), session: Get.find()),
      fenix: true,
    );
    Get.lazyPut(
      () => SignInController(
        repository: Get.find(),
        session: Get.find<SessionService>(),
      ),
    );
  }
}
