import 'package:getx_architecture/app/core/commons/auth/auth_tokens.dart';
import 'package:getx_architecture/app/modules/authentications/auth_services.dart';
import 'package:getx_architecture/app/utils/user_provider.dart';

class AuthRepository {
  AuthRepository(this._authServices, this._tokenStore);

  final AuthServices _authServices;
  final TokenStore _tokenStore;

  Future<void> signIn({
    required String mobileNumber,
    required String password,
  }) async {
    final user = await _authServices.signIn(mobileNumber: mobileNumber, password: password);

    // 1️⃣ Save tokens securely
    if (user.accessToken != null && user.refreshToken != null && user.accessExpiry != null) {
      await _tokenStore.save(
        AuthTokens(
          accessToken: user.accessToken!,
          refreshToken: user.refreshToken!,
          accessExpiry: user.accessExpiry!,
        ),
      );
    }

    // 2️⃣ Save user profile (no tokens!)
    await UserProvider.setProfile(user);
  }

  Future<void> logout() async {
    await _tokenStore.clear();
    await UserProvider.clearProfile();
  }
}
