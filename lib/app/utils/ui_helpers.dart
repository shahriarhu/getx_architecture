import 'package:get/get.dart';

class UIHelper {
  UIHelper._();

  static double _selectValue({
    required double small,
    required double medium,
    required double large,
    required double tablet,
    required double desktop,
  }) {
    double screenHeight = Get.height - Get.mediaQuery.padding.top;

    if (screenHeight > 1600) {
      return desktop;
    } else if (screenHeight > 1200) {
      return tablet;
    } else if (screenHeight > 850) {
      return large;
    } else if (screenHeight > 650) {
      return medium;
    } else {
      return small;
    }
  }

  /// Padding
  static double smallPadding() => _selectValue(small: 6, medium: 8, large: 10, tablet: 16, desktop: 20);
  static double mediumPadding() => _selectValue(small: 8, medium: 12, large: 16, tablet: 22, desktop: 28);
  static double bigPadding() => _selectValue(small: 12, medium: 18, large: 24, tablet: 32, desktop: 40);

  /// Spacing
  static double extraSmallSpacing() => _selectValue(small: 4, medium: 6, large: 8, tablet: 12, desktop: 16);
  static double smallSpacing() => _selectValue(small: 8, medium: 12, large: 16, tablet: 22, desktop: 28);
  static double mediumSpacing() => _selectValue(small: 16, medium: 20, large: 24, tablet: 32, desktop: 40);
  static double bigSpacing() => _selectValue(small: 28, medium: 34, large: 40, tablet: 48, desktop: 56);
  static double extraBigSpacing() => _selectValue(small: 36, medium: 44, large: 52, tablet: 62, desktop: 72);
}
