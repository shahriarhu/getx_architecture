/// Spacing scale (4pt grid).
///
/// These are plain constants on purpose. The old approach — scaling every value
/// off `Get.height` at startup — produced numbers that were captured once and
/// then wrong after a rotation, a split-screen resize, or in any widget test.
/// Adapt *layouts* to the screen via `context.responsive(...)`, not the scale.
abstract final class AppSpacing {
  static const xxs = 2.0;
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 48.0;

  /// Default horizontal page padding.
  static const page = 16.0;
}

abstract final class AppRadius {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const pill = 999.0;
}

abstract final class AppSizes {
  static const iconSm = 16.0;
  static const iconMd = 20.0;
  static const iconLg = 24.0;
  static const iconXl = 32.0;

  static const buttonHeight = 48.0;
  static const inputHeight = 48.0;
  static const appBarHeight = 56.0;
  static const avatarSm = 32.0;
  static const avatarMd = 44.0;
  static const avatarLg = 72.0;
  static const borderWidth = 1.0;
  static const focusedBorderWidth = 1.6;
}

abstract final class AppDurations {
  static const instant = Duration(milliseconds: 120);
  static const fast = Duration(milliseconds: 200);
  static const normal = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 500);
}
