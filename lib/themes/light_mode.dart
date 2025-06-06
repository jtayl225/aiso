import 'package:aiso/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  textTheme: GoogleFonts.montserratTextTheme(),
  // primaryColor: AppColors.color1,
  scaffoldBackgroundColor: Colors.grey.shade100,
  // canvasColor: AppColors.color3,
  colorScheme: ColorScheme.light(
    brightness: Brightness.light, 
    primary: AppColors.color1,
    onPrimary: Colors.white,
    secondary: AppColors.color2,
    onSecondary: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    surface: AppColors.color3, // background
    onSurface: Colors.black,
    primaryContainer: AppColors.color1.withValues(alpha:0.8),
    onPrimaryContainer: Colors.white,
    secondaryContainer: AppColors.color2.withValues(alpha: 0.8),
    onSecondaryContainer: Colors.black,
    ),
    
);