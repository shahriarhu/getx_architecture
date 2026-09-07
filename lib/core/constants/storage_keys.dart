/// Keys used for local (unencrypted) and secure (encrypted) storage.
///
/// Keep them together so it is obvious what the app persists and where.
abstract final class StorageKeys {
  // Secure storage — credentials only.
  static const accessToken = 'auth.access_token';
  static const refreshToken = 'auth.refresh_token';
  static const accessExpiry = 'auth.access_expiry';

  // Local storage — non-sensitive preferences and caches.
  static const themeMode = 'settings.theme_mode';
  static const localeCode = 'settings.locale_code';
  static const cachedUser = 'auth.cached_user';
  static const onboardingSeen = 'app.onboarding_seen';
}
