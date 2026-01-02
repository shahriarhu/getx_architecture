import 'auth_tokens.dart';

class AuthSession {
  AuthSession(this.tokenStore);

  final TokenStore tokenStore;

  Future<bool> isSignedIn() async {
    final tokens = await tokenStore.read();

    return tokens != null && tokens.refreshToken.isNotEmpty;
  }
}
