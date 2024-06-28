import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: GoogleFonts.lato().fontFamily,
  brightness: Brightness.light,
  primaryTextTheme: GoogleFonts.latoTextTheme(),
  textTheme: GoogleFonts.latoTextTheme(),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: Colors.black),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.blue,
    secondary: (Colors.grey[200])!,
    tertiary: const Color(0xffEBEBEB),
    surface: Colors.white,
    onSurface: Colors.black,
  ),
);

ThemeData darkTheme = ThemeData(
  fontFamily: GoogleFonts.lato().fontFamily,
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900],
    elevation: 0,
    titleTextStyle:
        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.grey[900],
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.blue,
    secondary: (Colors.grey[200])!,
    tertiary: const Color(0xFF303030), // Darker color for tertiary in dark mode
    surface: Colors.grey,
    onSurface: Colors.black,
  ),
);
