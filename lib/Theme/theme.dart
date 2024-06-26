import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
  ),
  colorScheme: const ColorScheme.light(
    background: Colors.white,
    primary: Colors.blue,
    secondary: Color(0xff868782),
    tertiary: Color(0xffEBEBEB),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[800],
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
  ),
  colorScheme: const ColorScheme.dark(
    background: Colors.black,
    primary: Colors.blue,
    secondary: Color(0xff868782),
    tertiary: Color(0xffEBEBEB),
  ),
);
