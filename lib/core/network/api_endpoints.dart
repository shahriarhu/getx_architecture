/// Every server path in one place. Paths are relative to `AppConfig.apiBaseUrl`.
abstract final class ApiEndpoints {
  // Auth
  static const signIn = '/auth/login';
  static const signUp = '/auth/register';
  static const refreshToken = '/auth/refresh';
  static const signOut = '/auth/logout';
  static const profile = '/auth/me';

  // Articles (demo feature — points at jsonplaceholder in the dev flavour)
  static const articles = '/posts';

  static String article(Object id) => '/posts/$id';

  /// Requests to these paths must never carry (or wait for) an access token.
  static const Set<String> public = {signIn, signUp, refreshToken};
}
