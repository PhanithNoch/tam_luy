import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'constant.dart';

// English
ThemeData darkTheme = ThemeData(
  fontFamily: Get.locale?.languageCode == 'kh' ? 'Battambang' : "SF Pro Text",
  brightness: Brightness.dark,
  primaryColor: Colors.amber,
  // add black color to primaryColorDark
  primaryColorDark: Colors.black,

  canvasColor: kBackgroundColorDark,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.amber,
  ),
  appBarTheme: AppBarTheme(
    color: Colors.transparent,
    elevation: 0,
    iconTheme: const IconThemeData(color: kBackgroundColor),
    titleTextStyle: kTitle1LightStyle,
    foregroundColor: kPrimaryLabelColorLight,
  ),
  buttonBarTheme: const ButtonBarThemeData(
    buttonTextTheme: ButtonTextTheme.accent,
  ),
  textTheme: const TextTheme().apply(
    bodyColor: Colors.amber,
    displayColor: Colors.amber,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.amber,
    disabledColor: Colors.amber,
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.white,
  ),
);

ThemeData lightTheme = ThemeData(
  primaryColorDark: Color(0xFFe63946),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blueAccent,
    shape: RoundedRectangleBorder(),
    textTheme: ButtonTextTheme.normal,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFe63946),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Color(0xFFe63946),
  ),
  brightness: Brightness.light,
  // primaryColor: googleColor,
  colorScheme: ColorScheme.light(
    primary: Color(0xffDF4A32),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  secondaryHeaderColor: Color(0xFFe63946),
  primarySwatch: const MaterialColor(0xffDF4A32, {
    50: Color(0xffDF4A32),
    100: Color(0xffDF4A32),
    200: Color(0xffDF4A32),
    300: Color(0xffDF4A32),
    400: Color(0xffDF4A32),
    500: Color(0xffDF4A32),
    600: Color(0xffDF4A32),
    700: Color(0xffDF4A32),
    800: Color(0xffDF4A32),
    900: Color(0xffDF4A32),
  }),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    color: Colors.transparent,
    elevation: 0,
    iconTheme: const IconThemeData(color: kBackgroundColorDark),
    titleTextStyle: kTitle1Style,
    // foregroundColor: kBackgroundColorDark,
  ),
  textTheme: const TextTheme().apply(
    bodyColor: Colors.black,
    displayColor: Colors.black,
  ),
  scaffoldBackgroundColor: kSidebarBackgroundColor,

  tabBarTheme: TabBarTheme(
    labelColor: kBackgroundColorDark,
    unselectedLabelColor: kPrimaryLabelColor,
  ),
);
