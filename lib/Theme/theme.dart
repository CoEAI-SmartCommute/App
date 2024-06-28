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
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.blue,
    secondary: (Colors.grey)!,
    tertiary: Color(0xffEBEBEB),
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  shadowColor: Colors.grey[200],
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
  colorScheme: ColorScheme.dark(
    background: (Colors.grey[900])!,
    primary: Colors.blue,
    secondary: (Colors.grey[300])!,
    tertiary: Color(0xFF303030), // Darker color for tertiary in dark mode
    surface: Colors.grey,
    onSurface: Colors.white,
  ),
  shadowColor: Colors.grey[500],
);
