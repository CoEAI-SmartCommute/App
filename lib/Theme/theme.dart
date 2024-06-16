import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
  ),
  colorScheme: const ColorScheme.light(
      background: Colors.white,
      primary: Colors.blue,
      secondary: Color(0xff868782),
      tertiary: Color(0xffEBEBEB)),
);
