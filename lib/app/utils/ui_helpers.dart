import 'package:get/get.dart';

class UIHelper {
  UIHelper._();

  static double _selectValue({required double large, required double medium, required double small}) {
    double screenHeight = Get.height - Get.mediaQuery.padding.top;

    if (screenHeight > 850) {
      return large;
    } else if (screenHeight > 650) {
      return medium;
    } else {
      return small;
    }
  }

  static double bigPadding() => _selectValue(large: 20, medium: 16, small: 12);
  static double mediumPadding() => _selectValue(large: 16, medium: 12, small: 8);
  static double smallPadding() => _selectValue(large: 10, medium: 8, small: 6);

  static double extraBigSpacing() => _selectValue(large: 48, medium: 44, small: 40);
  static double bigSpacing() => _selectValue(large: 36, medium: 32, small: 28);
  static double mediumSpacing() => _selectValue(large: 24, medium: 20, small: 18);
  static double smallSpacing() => _selectValue(large: 16, medium: 14, small: 12);
  static double extraSmallSpacing() => _selectValue(large: 10, medium: 8, small: 6);
}
