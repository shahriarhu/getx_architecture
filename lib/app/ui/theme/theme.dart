import 'package:flutter/material.dart';
import 'package:getx_architecture/app/ui/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// LIGHT & DARK THEME

ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: primaryColor,
  canvasColor: lightCanvasColor,
  scaffoldBackgroundColor: lightScaffoldColor,
  cardColor: lightCardColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  iconTheme: const IconThemeData(color: lightIconColor),
  primaryIconTheme: const IconThemeData(color: lightIconColor),
  appBarTheme: _appBarTheme(lightScaffoldColor, lightPrimaryTextColor),
  inputDecorationTheme: _inputDecorationTheme(lightDisabledTextColor, lightDividerColor),
  floatingActionButtonTheme: _floatingActionButtonTheme(primaryColor: secondaryColor),
  elevatedButtonTheme: _elevatedButtonThemeData(primaryColor: primaryColor),
  textButtonTheme: _textButtonThemeData(primaryColor: primaryColor),
  iconButtonTheme: _iconButtonThemeData(primaryColor: primaryColor),
  bottomAppBarTheme: BottomAppBarThemeData(
    color: lightScaffoldColor,
    elevation: 0,
    shape: const CircularNotchedRectangle(),
  ),
  dividerTheme: const DividerThemeData(color: lightDividerColor),
  colorScheme: _colorScheme(brightness: Brightness.light),
  textTheme: _textTheme(primaryColor: lightPrimaryTextColor, secondaryColor: lightSecondaryTextColor),
  brightness: Brightness.light,
  pageTransitionsTheme: _pageTransitionsTheme,
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: primaryColor,
  canvasColor: darkCanvasColor,
  scaffoldBackgroundColor: darkScaffoldColor,
  cardColor: darkCardColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  iconTheme: const IconThemeData(color: darkIconColor),
  primaryIconTheme: const IconThemeData(color: darkIconColor),
  appBarTheme: _appBarTheme(darkScaffoldColor, darkPrimaryTextColor),
  inputDecorationTheme: _inputDecorationTheme(darkDisabledTextColor, darkDividerColor),
  floatingActionButtonTheme: _floatingActionButtonTheme(primaryColor: secondaryColor),
  elevatedButtonTheme: _elevatedButtonThemeData(primaryColor: primaryColor),
  textButtonTheme: _textButtonThemeData(primaryColor: primaryColor),
  iconButtonTheme: _iconButtonThemeData(primaryColor: primaryColor),
  bottomAppBarTheme: BottomAppBarThemeData(
    color: darkScaffoldColor,
    elevation: 0,
    shape: const CircularNotchedRectangle(),
  ),
  dividerTheme: const DividerThemeData(color: darkDividerColor),
  colorScheme: _colorScheme(brightness: Brightness.dark),
  textTheme: _textTheme(primaryColor: darkPrimaryTextColor, secondaryColor: darkSecondaryTextColor),
  brightness: Brightness.dark,
  pageTransitionsTheme: _pageTransitionsTheme,
);

/// TEXT THEME
TextTheme _textTheme({required Color primaryColor, required Color secondaryColor}) => TextTheme(
      bodySmall: GoogleFonts.inter(color: secondaryColor, fontWeight: FontWeight.w500, fontSize: 12, height: 1.4),
      bodyMedium: GoogleFonts.inter(color: secondaryColor, fontWeight: FontWeight.w500, fontSize: 14, height: 1.4),
      bodyLarge: GoogleFonts.inter(color: secondaryColor, fontWeight: FontWeight.w500, fontSize: 16, height: 1.4),
      titleSmall: GoogleFonts.inter(color: primaryColor, fontWeight: FontWeight.w700, fontSize: 12, height: 1.4),
      titleMedium: GoogleFonts.inter(color: primaryColor, fontWeight: FontWeight.w700, fontSize: 14, height: 1.4),
      titleLarge: GoogleFonts.inter(color: primaryColor, fontWeight: FontWeight.w700, fontSize: 16, height: 1.4),
      headlineSmall: GoogleFonts.inter(color: primaryColor, fontWeight: FontWeight.w700, fontSize: 20, height: 1.3),
      headlineMedium: GoogleFonts.inter(color: primaryColor, fontWeight: FontWeight.w700, fontSize: 24, height: 1.3),
      headlineLarge: GoogleFonts.inter(color: primaryColor, fontWeight: FontWeight.w800, fontSize: 28, height: 1.3),
    );

/// COLOR SCHEME
ColorScheme _colorScheme({required Brightness brightness}) =>
    (brightness == Brightness.light ? const ColorScheme.light() : const ColorScheme.dark()).copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: secondaryColor,
      error: errorColor,
      surface: brightness == Brightness.light ? lightCanvasColor : darkCanvasColor,
      brightness: brightness,
    );

/// APPBAR THEME
AppBarTheme _appBarTheme(Color backgroundColor, Color foregroundColor) => AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
    );

/// INPUT DECORATION THEME
InputDecorationTheme _inputDecorationTheme(Color fontColor, Color borderColor) => InputDecorationTheme(
      hintStyle: TextStyle(color: fontColor, fontWeight: FontWeight.w500),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(width: 1.4),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor, width: 1.4),
      ),
    );

/// BUTTON & ICON THEMES
FloatingActionButtonThemeData _floatingActionButtonTheme({required Color primaryColor}) =>
    FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: primaryColor,
    );

ElevatedButtonThemeData _elevatedButtonThemeData({required Color primaryColor}) => ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        textStyle: const TextStyle(color: Colors.white, fontSize: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

TextButtonThemeData _textButtonThemeData({required Color primaryColor}) => TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: TextStyle(color: primaryColor, fontSize: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

IconButtonThemeData _iconButtonThemeData({required Color primaryColor}) => IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: primaryColor,
        backgroundColor: Colors.transparent,
        highlightColor: primaryColor,
      ),
    );

/// PAGE TRANSITIONS
const PageTransitionsTheme _pageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
  },
);
