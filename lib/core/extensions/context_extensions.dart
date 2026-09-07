import 'package:flutter/material.dart';

import '../../theme/app_breakpoints.dart';
import '../../theme/app_colors.dart';

/// Shortcuts for values read constantly inside `build`.
///
/// GetX already adds `context.theme`, `context.textTheme` and `context.width`;
/// these fill the gaps without shadowing them.
extension AppContextX on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Brand colors that Material's [ColorScheme] has no slot for
  /// (success, warning, info…).
  AppSemanticColors get semantic =>
      Theme.of(this).extension<AppSemanticColors>() ?? AppSemanticColors.light;

  ScreenSize get screenSize => AppBreakpoints.of(MediaQuery.sizeOf(this).width);

  bool get isMobileScreen => screenSize == ScreenSize.mobile;

  bool get isTabletScreen => screenSize == ScreenSize.tablet;

  bool get isDesktopScreen => screenSize == ScreenSize.desktop;

  /// Picks a value for the current breakpoint, falling back to the next
  /// smaller one so only [mobile] is ever mandatory.
  T responsive<T>({required T mobile, T? tablet, T? desktop}) =>
      switch (screenSize) {
        ScreenSize.mobile => mobile,
        ScreenSize.tablet => tablet ?? mobile,
        ScreenSize.desktop => desktop ?? tablet ?? mobile,
      };

  double get topInset => MediaQuery.paddingOf(this).top;

  double get bottomInset => MediaQuery.paddingOf(this).bottom;

  double get keyboardInset => MediaQuery.viewInsetsOf(this).bottom;

  bool get isKeyboardVisible => keyboardInset > 0;

  /// Dismisses the keyboard without needing a focus node.
  void unfocus() => FocusScope.of(this).unfocus();
}
