import 'package:flutter/material.dart';
import 'package:getx_architecture/app/ui/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// Light Theme
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
  inputDecorationTheme: _inputDecorationTheme(
    lightDisabledTextColor,
    lightDividerColor,
  ),
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
  dividerTheme: const DividerThemeData(color: lightDividerColor),
  colorScheme: _lightColorScheme,
  textTheme: _textTheme(lightPrimaryTextColor, lightSecondaryTextColor),
  brightness: Brightness.light,
);

/// Dark Theme
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
  inputDecorationTheme: _inputDecorationTheme(
    darkDisabledTextColor,
    darkDividerColor,
  ),
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
  dividerTheme: const DividerThemeData(color: darkDividerColor),
  colorScheme: _darkColorScheme,
  textTheme: _textTheme(darkPrimaryTextColor, darkSecondaryTextColor),
  brightness: Brightness.dark,
);

/// Text Theme
TextTheme _textTheme(Color primaryColor, Color secondaryColor) => TextTheme(
      bodySmall: TextStyle(
        fontFamily: GoogleFonts.inter().fontFamily,
        color: secondaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.4,
      ),
      bodyMedium: TextStyle(
        fontFamily: GoogleFonts.inter().fontFamily,
        color: secondaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontFamily: GoogleFonts.inter().fontFamily,
        color: secondaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        fontFamily: GoogleFonts.inter().fontFamily,
        color: primaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 12,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontFamily: GoogleFonts.inter().fontFamily,
        color: primaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 14,
        height: 1.4,
      ),
      titleLarge: TextStyle(
        fontFamily: GoogleFonts.inter().fontFamily,
        color: primaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        height: 1.4,
      ),
      headlineSmall: TextStyle(
        fontFamily: GoogleFonts.inter().fontFamily,
        color: primaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 20,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontFamily: GoogleFonts.inter().fontFamily,
        color: primaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        height: 1.3,
      ),
      headlineLarge: TextStyle(
        fontFamily: GoogleFonts.inter().fontFamily,
        color: primaryColor,
        fontWeight: FontWeight.w800,
        fontSize: 28,
        height: 1.3,
      ),
    );

ColorScheme _lightColorScheme = const ColorScheme.light().copyWith(
  primary: primaryColor,
  secondary: secondaryColor,
  tertiary: secondaryColor,
  error: errorColor,
  surface: lightCanvasColor,
  brightness: Brightness.light,
);

ColorScheme _darkColorScheme = const ColorScheme.dark().copyWith(
  primary: primaryColor,
  secondary: secondaryColor,
  tertiary: secondaryColor,
  error: errorColor,
  surface: darkCanvasColor,
  brightness: Brightness.dark,
);

/// Appbar Theme
AppBarTheme _appBarTheme(Color backgroundColor, Color foregroundColor) => AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
    );

/// InputDecoration Theme
InputDecorationTheme _inputDecorationTheme(Color fontColor, Color borderColor) =>
    InputDecorationTheme(
      hintStyle: TextStyle(
        color: fontColor,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(width: 1.4),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: borderColor,
          width: 1.4,
        ),
      ),
    );

/// Floating Action Button Theme
const FloatingActionButtonThemeData _floatingActionButtonTheme = FloatingActionButtonThemeData(
  foregroundColor: Colors.white,
  backgroundColor: secondaryColor,
);

/// Elevated Button Theme
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
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);

/// Text Button Theme
TextButtonThemeData _textButtonThemeData = TextButtonThemeData(
  style: TextButton.styleFrom(
    textStyle: const TextStyle(
      color: primaryColor,
      fontSize: 18,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);

/// Icon Button Theme
IconButtonThemeData _iconButtonThemeData = IconButtonThemeData(
  style: IconButton.styleFrom(
    foregroundColor: primaryColor,
    backgroundColor: Colors.transparent,
    highlightColor: primaryColor,
  ),
);

/// Page Transition Theme (Navigation)
const PageTransitionsTheme _pageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
  },
);
