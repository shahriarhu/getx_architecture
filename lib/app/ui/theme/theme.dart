import 'package:flutter/material.dart';
import 'package:getx_architecture/app/ui/theme/colors.dart';
import 'package:getx_architecture/app/utils/ui_helpers.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: primaryColor,
  primaryColorLight: primaryColorLight,
  primaryColorDark: primaryColorDark,
  canvasColor: lightCanvasColor,
  scaffoldBackgroundColor: lightScaffoldColor,
  cardColor: lightCardColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  iconTheme: const IconThemeData(color: lightIconColor),
  primaryIconTheme: const IconThemeData(color: lightIconColor),
  appBarTheme: _appBarTheme(lightScaffoldColor, lightPrimaryTextColor),
  floatingActionButtonTheme: _floatingActionButtonTheme,
  elevatedButtonTheme: _elevatedButtonThemeData,
  textButtonTheme: _textButtonThemeData,
  iconButtonTheme: _iconButtonThemeData,
  pageTransitionsTheme: _pageTransitionsTheme,
  bottomAppBarTheme: const BottomAppBarTheme(
    color: lightScaffoldColor,
    elevation: 0,
    shape: CircularNotchedRectangle(),
  ),
  colorScheme: _lightColorScheme,
  textTheme: _textTheme(lightPrimaryTextColor),
  brightness: Brightness.light,
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: primaryColor,
  primaryColorLight: primaryColorLight,
  primaryColorDark: primaryColorDark,
  canvasColor: darkCanvasColor,
  scaffoldBackgroundColor: darkScaffoldColor,
  cardColor: darkCardColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  iconTheme: const IconThemeData(color: darkIconColor),
  primaryIconTheme: const IconThemeData(color: darkIconColor),
  appBarTheme: _appBarTheme(darkScaffoldColor, darkPrimaryTextColor),
  floatingActionButtonTheme: _floatingActionButtonTheme,
  elevatedButtonTheme: _elevatedButtonThemeData,
  textButtonTheme: _textButtonThemeData,
  iconButtonTheme: _iconButtonThemeData,
  pageTransitionsTheme: _pageTransitionsTheme,
  bottomAppBarTheme: const BottomAppBarTheme(
    color: darkScaffoldColor,
    elevation: 0,
    shape: CircularNotchedRectangle(),
  ),
  colorScheme: _darkColorScheme,
  textTheme: _textTheme(darkPrimaryTextColor),
  brightness: Brightness.dark,
);

TextTheme _textTheme(Color color) => TextTheme(
      bodySmall: TextStyle(color: color),
      bodyMedium: TextStyle(color: color),
      bodyLarge: TextStyle(color: color),
      titleSmall: TextStyle(color: color),
      titleMedium: TextStyle(color: color),
      titleLarge: TextStyle(color: color),
      headlineSmall: TextStyle(color: color),
      headlineMedium: TextStyle(color: color),
      headlineLarge: TextStyle(color: color),
    );

ColorScheme _lightColorScheme = const ColorScheme.light().copyWith(
  primary: primaryColor,
  secondary: secondaryColor,
  tertiary: secondaryColor, // Adjust as needed
  error: errorColor,
  surface: lightCanvasColor,
  brightness: Brightness.light,
);

ColorScheme _darkColorScheme = const ColorScheme.dark().copyWith(
  primary: primaryColor,
  secondary: secondaryColor,
  tertiary: secondaryColor, // Adjust as needed
  error: errorColor,
  surface: darkCanvasColor,
  brightness: Brightness.dark,
);

AppBarTheme _appBarTheme(Color backgroundColor, Color foregroundColor) => AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
    );

const FloatingActionButtonThemeData _floatingActionButtonTheme = FloatingActionButtonThemeData(
  foregroundColor: Colors.white,
  backgroundColor: secondaryColor,
);

ElevatedButtonThemeData _elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: primaryColor,
    elevation: 0,
    shadowColor: Colors.transparent,
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(UIHelper.xSmall),
    ),
  ),
);

TextButtonThemeData _textButtonThemeData = TextButtonThemeData(
  style: TextButton.styleFrom(
    textStyle: const TextStyle(
      color: primaryColor,
      fontSize: 18,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(UIHelper.xLarge),
    ),
  ),
);

IconButtonThemeData _iconButtonThemeData = IconButtonThemeData(
  style: IconButton.styleFrom(
    foregroundColor: primaryColor,
    backgroundColor: Colors.transparent,
    highlightColor: primaryColor,
  ),
);

const PageTransitionsTheme _pageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
  },
);
