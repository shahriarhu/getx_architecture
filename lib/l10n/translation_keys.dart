/// Typed translation keys.
///
/// Never write a raw string key at a call site: a typo in `'sing_in'.tr`
/// silently renders the key itself, whereas `LocaleKeys.signIn.tr` is a
/// compile error if it does not exist, and rename/find-usages work.
abstract final class LocaleKeys {
  // Common
  static const appName = 'app_name';
  static const ok = 'ok';
  static const cancel = 'cancel';
  static const retry = 'retry';
  static const save = 'save';
  static const close = 'close';
  static const confirm = 'confirm';
  static const search = 'search';
  static const loading = 'loading';
  static const somethingWentWrong = 'something_went_wrong';
  static const noDataFound = 'no_data_found';
  static const noDataFoundMessage = 'no_data_found_message';
  static const offline = 'offline';
  static const offlineMessage = 'offline_message';

  // Auth
  static const signIn = 'sign_in';
  static const signOut = 'sign_out';
  static const signInSubtitle = 'sign_in_subtitle';
  static const welcomeBack = 'welcome_back';
  static const email = 'email';
  static const emailHint = 'email_hint';
  static const password = 'password';
  static const passwordHint = 'password_hint';
  static const forgotPassword = 'forgot_password';
  static const signOutConfirm = 'sign_out_confirm';
  static const sessionExpired = 'session_expired';
  static const continueAsGuest = 'continue_as_guest';

  // Home
  static const home = 'home';
  static const articles = 'articles';
  static const articlesEmpty = 'articles_empty';
  static const pullToRefresh = 'pull_to_refresh';

  // Settings
  static const settings = 'settings';
  static const appearance = 'appearance';
  static const themeMode = 'theme_mode';
  static const themeSystem = 'theme_system';
  static const themeLight = 'theme_light';
  static const themeDark = 'theme_dark';
  static const language = 'language';
  static const account = 'account';
  static const about = 'about';
  static const version = 'version';

  // Errors
  static const errorNoConnection = 'error_no_connection';
  static const errorTimeout = 'error_timeout';
  static const errorCancelled = 'error_cancelled';
  static const errorBadCertificate = 'error_bad_certificate';
  static const errorBadRequest = 'error_bad_request';
  static const errorUnauthorized = 'error_unauthorized';
  static const errorForbidden = 'error_forbidden';
  static const errorNotFound = 'error_not_found';
  static const errorConflict = 'error_conflict';
  static const errorValidation = 'error_validation';
  static const errorTooManyRequests = 'error_too_many_requests';
  static const errorServer = 'error_server';
  static const errorParsing = 'error_parsing';
  static const errorUnexpected = 'error_unexpected';
  static const errorRouteNotFound = 'error_route_not_found';

  // Validation
  static const validationRequired = 'validation_required';
  static const validationEmail = 'validation_email';
  static const validationPhone = 'validation_phone';
  static const validationMinLength = 'validation_min_length';
  static const validationMaxLength = 'validation_max_length';
  static const validationPassword = 'validation_password';
  static const validationMismatch = 'validation_mismatch';

  // Relative time
  static const timeJustNow = 'time_just_now';
  static const timeMinutesAgo = 'time_minutes_ago';
  static const timeHoursAgo = 'time_hours_ago';
  static const timeDaysAgo = 'time_days_ago';
}
