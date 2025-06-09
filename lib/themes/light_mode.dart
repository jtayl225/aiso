import 'package:aiso/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  textTheme: GoogleFonts.montserratTextTheme(),
  scaffoldBackgroundColor: Colors.white, //Colors.grey.shade100,

  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    primary: AppColors.color1,
    onPrimary: Colors.white,
    secondary: AppColors.color2,
    onSecondary: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    primaryContainer: AppColors.color1.withValues(alpha: 0.2),
    onPrimaryContainer: Colors.black,
    secondaryContainer: AppColors.color2.withValues(alpha: 0.2),
    onSecondaryContainer: Colors.black,
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.color1,
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white
      ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.color6,   // ← was `primary:`
      foregroundColor: Colors.white,        // ← was `onPrimary:`
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.montserrat(
      fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white
      ),
    ),
    
  ),

  cardTheme: CardThemeData(           // ← use CardThemeData, not CardTheme
    color: Colors.white,
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      side: BorderSide(
      color: Colors.grey.shade300, // light‐gray border
      width: 1,
    ),
    ),
  ),

  // …any other overrides…
);