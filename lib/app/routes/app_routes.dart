/// Route names. Referencing a constant instead of a string literal means a
/// renamed route is a compile error, not a runtime dead end.
abstract final class AppRoutes {
  static const splash = '/';
  static const signIn = '/sign-in';
  static const home = '/home';
  static const settings = '/settings';
  static const notFound = '/not-found';
}
