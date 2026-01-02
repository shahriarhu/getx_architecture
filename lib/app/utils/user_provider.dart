import 'package:get_storage/get_storage.dart';
import 'package:getx_architecture/app/core/commons/models/auth_user_model.dart';

class UserProvider {
  UserProvider._();

  static final GetStorage _box = GetStorage();
  static const _kUser = 'authUserProfile';

  static AuthUserModel get profile {
    final raw = _box.read(_kUser);
    if (raw == null) return AuthUserModel();
    return AuthUserModel.fromJson(raw);
  }

  static Future<void> setProfile(AuthUserModel user) async {
    await _box.write(_kUser, user.toJson());
  }

  static Future<void> clearProfile() async {
    await _box.remove(_kUser);
  }
}
