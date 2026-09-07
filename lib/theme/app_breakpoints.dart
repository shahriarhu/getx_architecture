enum ScreenSize { mobile, tablet, desktop }

/// Layout breakpoints, aligned with Material 3's window size classes.
abstract final class AppBreakpoints {
  static const tablet = 600.0;
  static const desktop = 1024.0;

  /// Widest a single content column should ever get on a large screen —
  /// stops forms stretching to 2000px on desktop and web.
  static const maxContentWidth = 560.0;

  static ScreenSize of(double width) {
    if (width >= desktop) return ScreenSize.desktop;
    if (width >= tablet) return ScreenSize.tablet;
    return ScreenSize.mobile;
  }
}
