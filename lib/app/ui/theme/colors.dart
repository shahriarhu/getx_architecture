import 'package:flutter/material.dart';
import 'package:getx_architecture/app/ui/theme/theme_controller.dart';

// LIGHT THEME COLORS
const Color lightCanvasColor = Color(0xFFF2F5FF);
const Color lightScaffoldColor = Color(0xFFFFFFFF);
const Color lightCardColor = Color(0xFFFFFFFF);

// DARK THEME COLORS
const Color darkCanvasColor = Color(0xFF202020);
const Color darkScaffoldColor = Color(0xFF141414);
const Color darkCardColor = Color(0xFF333232);

const Color lightPrimaryFontColor = Color(0xFF000000);
const Color lightSecondaryFontColor = Color.fromRGBO(0, 0, 0, 0.4);

const Color darkPrimaryFontColor = Color(0xFFFFFFFF);
const Color darkSecondaryFontColor = Color.fromRGBO(255, 255, 255, 0.4);

// COMMON COLOR
const Color primaryColorLight = Color(0xFFF7C727);
const Color primaryColor = Color(0xFFF7C727);
const Color primaryColorDark = Color(0xFFF2994A);

const Color secondaryColorLight = Color(0xFF2F80ED);
const Color secondaryColor = Color(0xFF222A41);
const Color secondaryColorDark = Color(0xFF242C45);

const Color tertiaryColorLight = Color(0xFFFCF0C7);
const Color tertiaryColor = Color(0xFFF8D247);
const Color tertiaryColorDark = Color(0xFFE0B827);

const Color errorColor = Color(0xFFE03616);
const Color errorColorLight = Color(0xFFFD5839);
const Color errorColordark = Color(0xFFBB2D13);

const Color successColor = Color(0xFF00AF54);
const Color successColorLight = Color(0xFF24DD7D);
const Color successColordark = Color(0xFF0F8849);

const Color backgroundBlue = Color(0xFFF2F6FF);
const Color greyDeepColor = Color(0xFFE0E0E0);

Color primaryBackdrop = primaryColor.withOpacity(0.15);

Color get dividerColor => themeController.isDark.value ? Colors.grey.withOpacity(0.2) : Colors.grey.withOpacity(0.3);

Color get primaryTextColor => themeController.isDark.value ? darkPrimaryFontColor : lightPrimaryFontColor;
Color get secondaryTextColor => themeController.isDark.value ? darkSecondaryFontColor : lightSecondaryFontColor;

Color get brightColor => themeController.isDark.value ? Colors.white : Colors.black;

Color get brightColorLight => themeController.isDark.value ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1);

Color statusColor(String status) {
  Color textColor = status == "pending"
      ? const Color(0xFFBDBDBD)
      : status == "completed"
          ? const Color(0xFFF7C727)
          : status == "confirmed"
              ? const Color(0xFF00FF6C)
              : status == "reschedule"
                  ? const Color(0xFF6227B0)
                  : const Color(0xFFFF0000);

  return textColor;
}
