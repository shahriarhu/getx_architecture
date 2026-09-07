/// Values that never change between environments.
///
/// Anything environment-specific belongs in `AppConfig` instead.
abstract final class AppConstants {
  static const defaultPageSize = 20;
  static const searchDebounce = Duration(milliseconds: 400);
  static const splashMinimumDuration = Duration(milliseconds: 600);
  static const snackbarDuration = Duration(seconds: 4);

  static const minPasswordLength = 8;
  static const maxPasswordLength = 64;

  static const supportEmail = 'support@example.com';
  static const privacyPolicyUrl = 'https://example.com/privacy';
  static const termsUrl = 'https://example.com/terms';
}
