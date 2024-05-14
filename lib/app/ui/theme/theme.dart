import 'package:flutter/material.dart';
import 'package:getx_architecture/app/ui/theme/colors.dart';
import 'package:getx_architecture/app/utils/ui_helpers.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: primaryColor,
  primaryColorLight: primaryColorLight,
  primaryColorDark: primaryColorDark,
  canvasColor: darkCanvasColor,
  cardColor: darkCardColor,
  scaffoldBackgroundColor: darkScaffoldColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  iconTheme: const IconThemeData(color: Colors.white),
  primaryIconTheme: const IconThemeData(color: Colors.white),
  appBarTheme: _appBarTheme(darkScaffoldColor, darkSecondaryFontColor),
  floatingActionButtonTheme: _floatingActionButtonTheme,
  elevatedButtonTheme: _elevatedButtonThemeData,
  iconButtonTheme: _iconButtonThemeData,
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
  }),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: darkScaffoldColor,
    elevation: 0,
    shape: CircularNotchedRectangle(),
  ),
  colorScheme: _lightColorScheme,
  textTheme: _textTheme(Colors.white),
  brightness: Brightness.dark,
);

ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: primaryColor,
  primaryColorLight: primaryColorLight,
  primaryColorDark: primaryColorDark,
  canvasColor: lightCanvasColor,
  cardColor: lightCardColor,
  scaffoldBackgroundColor: lightScaffoldColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryIconTheme: const IconThemeData(color: primaryColor),
  appBarTheme: _appBarTheme(lightScaffoldColor, secondaryColor),
  floatingActionButtonTheme: _floatingActionButtonTheme,
  elevatedButtonTheme: _elevatedButtonThemeData,
  textButtonTheme: _textButtonThemeData,
  iconButtonTheme: _iconButtonThemeData,
  iconTheme: const IconThemeData(color: Colors.black),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
  }),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: lightScaffoldColor,
    elevation: 0,
    shape: CircularNotchedRectangle(),
  ),
  colorScheme: _darkColorScheme,
  textTheme: _textTheme(Colors.black),
  brightness: Brightness.light,
);

AppBarTheme _appBarTheme(Color color, Color foregroundColor) => AppBarTheme(
      color: color,
      foregroundColor: foregroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
    );

TextTheme _textTheme(Color color) => TextTheme(
    // displayLarge: TextStyle(
    //   fontFamily: GoogleFonts.inter().fontFamily,
    //   color: color,
    //   fontWeight: FontWeight.w900,
    //   fontSize: 70,
    // ),
    // displayMedium: TextStyle(
    //   fontFamily: GoogleFonts.inter().fontFamily,
    //   color: color,
    //   fontWeight: FontWeight.w900,
    // ),
    // displaySmall: TextStyle(
    //   fontFamily: GoogleFonts.inter().fontFamily,
    //   color: color,
    //   fontWeight: FontWeight.w900,
    // ),
    // headlineLarge: TextStyle(
    //   fontFamily: GoogleFonts.inter().fontFamily,
    //   color: color,
    //   fontWeight: FontWeight.bold,
    // ),
    // headlineMedium: TextStyle(
    //   fontFamily: GoogleFonts.inter().fontFamily,
    //   color: color,
    //   fontWeight: FontWeight.bold,
    // ),
    // headlineSmall: TextStyle(
    //   fontFamily: GoogleFonts.inter().fontFamily,
    //   color: color,
    //   fontWeight: FontWeight.bold,
    // ),
    // titleLarge: TextStyle(
    //   fontFamily: GoogleFonts.inter().fontFamily,
    //   color: color,
    //   fontWeight: FontWeight.w900,
    // ),
    // titleMedium: TextStyle(
    //   fontFamily: GoogleFonts.inter().fontFamily,
    //   color: color,
    //   fontWeight: FontWeight.w900,
    // ),
    // titleSmall: TextStyle(
    //   fontFamily: GoogleFonts.inter().fontFamily,
    //   color: color,
    //   fontWeight: FontWeight.w900,
    // ),
    // bodyLarge: TextStyle(
    //   fontFamily: GoogleFonts.inter().fontFamily,
    //   color: color,
    //   fontWeight: FontWeight.w200,
    //   fontSize: 20,
    // ),
    // bodyMedium: TextStyle(
    //   fontFamily: GoogleFonts.inter().fontFamily,
    //   color: color,
    //   fontWeight: FontWeight.w200,
    //   fontSize: 16,
    // ),
    // bodySmall: TextStyle(
    //   fontFamily: GoogleFonts.inter().fontFamily,
    //   color: color,
    //   fontWeight: FontWeight.w200,
    //   fontSize: 12,
    // ),
    // labelLarge: TextStyle(
    //   fontFamily: GoogleFonts.inter().fontFamily,
    //   color: color,
    //   fontWeight: FontWeight.w600,
    //   fontSize: 20,
    // ),
    // labelMedium: TextStyle(
    //   fontFamily: GoogleFonts.inter().fontFamily,
    //   color: color,
    //   fontWeight: FontWeight.w600,
    //   fontSize: 16,
    // ),
    // labelSmall: TextStyle(
    //   fontFamily: GoogleFonts.inter().fontFamily,
    //   color: color,
    //   fontWeight: FontWeight.w600,
    //   fontSize: 12,
    // ),
    );

ColorScheme _lightColorScheme = ThemeData.light()
    .colorScheme
    .copyWith(primary: primaryColor)
    .copyWith(secondary: secondaryColor)
    .copyWith(tertiary: tertiaryColor)
    .copyWith(error: errorColor)
    .copyWith(background: lightCanvasColor)
    .copyWith(brightness: Brightness.light);

ColorScheme _darkColorScheme = ThemeData.light()
    .colorScheme
    .copyWith(primary: primaryColor)
    .copyWith(secondary: secondaryColor)
    .copyWith(tertiary: tertiaryColor)
    .copyWith(error: errorColor)
    .copyWith(background: darkCanvasColor)
    .copyWith(brightness: Brightness.dark);

const FloatingActionButtonThemeData _floatingActionButtonTheme = FloatingActionButtonThemeData(
  foregroundColor: Colors.white,
  backgroundColor: tertiaryColor,
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
      borderRadius: BorderRadius.circular(UIHelper.mediumSpacing()),
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
      borderRadius: BorderRadius.circular(UIHelper.mediumSpacing()),
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
