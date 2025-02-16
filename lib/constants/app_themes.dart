import 'package:flexx_bet/constants/colors.dart';
import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  static const Color dodgerBlue = Color.fromRGBO(29, 161, 242, 1);
  static const Color whiteLilac = Color.fromRGBO(248, 250, 252, 1);
  static const Color blackPearl = Color.fromRGBO(30, 31, 43, 1);
  static const Color brinkPink = Color.fromRGBO(255, 97, 136, 1);
  static const Color juneBud = Color.fromRGBO(186, 215, 97, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color nevada = Color.fromRGBO(105, 109, 119, 1);
  static const Color ebonyClay = Color.fromRGBO(40, 42, 58, 1);

  static String font1 = "Poppins";
  static String font2 = "Inter";
  //constants color range for light theme
  //main color
  static final Color _lightPrimaryColor = ColorConstant.primaryColor;

  //Background Colors
  static const Color _lightBackgroundColor = whiteLilac;
  static final Color _lightBackgroundAppBarColor = _lightPrimaryColor;
  static const Color _lightBackgroundSecondaryColor = white;
  static const Color _lightBackgroundAlertColor = blackPearl;
  static const Color _lightBackgroundActionTextColor = white;

  //Text Colors
  static const Color _lightTextColor = Colors.black;

  //Icon Color
  static const Color _lightIconColor = nevada;

  //constants color range for dark theme
  static final Color _darkPrimaryColor = ColorConstant.primaryColor;

  //Background Colors
  static const Color _darkBackgroundColor = ebonyClay;
  static final Color _darkBackgroundAppBarColor = _darkPrimaryColor;
  static const Color _darkBackgroundSecondaryColor =
      Color.fromRGBO(0, 0, 0, .6);
  static const Color _darkBackgroundAlertColor = blackPearl;
  static const Color _darkBackgroundActionTextColor = white;

  //Text Colors
  static const Color _darkTextColor = Colors.white;

  //Icon Color
  static const Color _darkIconColor = nevada;

  static const Color _darkInputFillColor = _darkBackgroundSecondaryColor;

  //text theme for light theme
  static final TextTheme _lightTextTheme = TextTheme(
    displayLarge: const TextStyle(fontSize: 20.0, color: _lightTextColor),
    bodyLarge: const TextStyle(fontSize: 16.0, color: _lightTextColor),
    bodyMedium: const TextStyle(fontSize: 14.0, color: Colors.black),
    labelLarge: const TextStyle(
        fontSize: 15.0, color: _lightTextColor, fontWeight: FontWeight.w600),
    titleLarge: const TextStyle(fontSize: 16.0, color: _lightTextColor),
    titleMedium: const TextStyle(fontSize: 16.0, color: _lightTextColor),
    bodySmall: TextStyle(fontSize: 12.0, color: _lightBackgroundAppBarColor),
  );

  //the light theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: font1,
    scaffoldBackgroundColor: _lightBackgroundColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _lightPrimaryColor,
    ),
    appBarTheme: AppBarTheme(
      color: _lightBackgroundAppBarColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: _lightTextColor),
      titleTextStyle: const TextStyle(fontSize: 16.0, color: _darkTextColor),
    ),
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      // secondary: _lightSecondaryColor,
    ),
    snackBarTheme: const SnackBarThemeData(
        backgroundColor: _lightBackgroundAlertColor,
        actionTextColor: _lightBackgroundActionTextColor),
    iconTheme: const IconThemeData(
      color: _lightIconColor,
    ),
    popupMenuTheme: PopupMenuThemeData(color: _lightBackgroundAppBarColor),
    textTheme: _lightTextTheme,
    buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        buttonColor: _lightPrimaryColor,
        textTheme: ButtonTextTheme.primary),
    unselectedWidgetColor: _lightPrimaryColor,
    inputDecorationTheme: const InputDecorationTheme(
      //prefixStyle: TextStyle(color: _lightIconColor),

      fillColor: _lightBackgroundSecondaryColor,
      //focusColor: _lightBorderActiveColor,
    ),
  );

  static final TextTheme _darkTextTheme = TextTheme(
    displayLarge: const TextStyle(fontSize: 20.0, color: _darkTextColor),
    bodyLarge: const TextStyle(fontSize: 16.0, color: _darkTextColor),
    bodyMedium: const TextStyle(fontSize: 14.0, color: Colors.grey),
    labelLarge: const TextStyle(
        fontSize: 15.0, color: _darkTextColor, fontWeight: FontWeight.w600),
    titleLarge: const TextStyle(fontSize: 16.0, color: _darkTextColor),
    titleMedium: const TextStyle(fontSize: 16.0, color: _darkTextColor),
    bodySmall: TextStyle(fontSize: 12.0, color: _darkBackgroundAppBarColor),
  );

  //the dark theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    //primarySwatch: _darkPrimaryColor, //cant be Color on MaterialColor so it can compute different shades.
    primaryColor: _darkPrimaryColor, //prefix icon color form input on focus

    fontFamily: font1,
    scaffoldBackgroundColor: _darkBackgroundColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _darkPrimaryColor,
    ),
    appBarTheme: AppBarTheme(
      color: _darkBackgroundAppBarColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: _darkTextColor),
      titleTextStyle: const TextStyle(fontSize: 16.0, color: _darkTextColor),
    ),
    colorScheme: ColorScheme.dark(
      primary: _darkPrimaryColor,

      // secondary: _darkSecondaryColor,
    ),
    snackBarTheme: const SnackBarThemeData(
        contentTextStyle: TextStyle(color: Colors.white),
        backgroundColor: _darkBackgroundAlertColor,
        actionTextColor: _darkBackgroundActionTextColor),
    iconTheme: const IconThemeData(
      color: _darkIconColor, //_darkIconColor,
    ),
    popupMenuTheme: PopupMenuThemeData(color: _darkBackgroundAppBarColor),
    textTheme: _darkTextTheme,
    buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        buttonColor: _darkPrimaryColor,
        textTheme: ButtonTextTheme.primary),
    unselectedWidgetColor: _darkPrimaryColor,
    inputDecorationTheme: const InputDecorationTheme(
      prefixStyle: TextStyle(color: _darkIconColor),
      //labelStyle: TextStyle(color: nevada),

      fillColor: _darkInputFillColor,
      //focusColor: _darkBorderActiveColor,
    ),
  );
}
