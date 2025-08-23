import 'package:get/get.dart';

class UISpacing {
  UISpacing._();

  /// Cached screen height (excluding status bar)
  static double get _screenHeight => Get.height - Get.mediaQuery.padding.top;

  /// Dynamic Scale Factor Based on Screen Size
  static double _scaleFactor() {
    if (_screenHeight > 1800) return 2.0; // Large Desktop
    if (_screenHeight > 1400) return 1.75; // Standard Desktop
    if (_screenHeight > 1100) return 1.5; // Tablets & Large Phones
    if (_screenHeight > 800) return 1.25; // Large Phones
    if (_screenHeight > 600) return 1.0; // Medium Phones (Baseline)
    return 0.85; // Small Phones
  }

  /// Unified Scalable Spacing & Padding
  static double space(double base) => base * _scaleFactor();

  /// Predefined Sizes for Consistency
  static final double xxSmall = space(4);
  static final double xSmall = space(8);
  static final double small = space(12);
  static final double medium = space(16);
  static final double large = space(24);
  static final double xLarge = space(32);
  static final double xxLarge = space(40);
}
