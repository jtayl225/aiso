import 'package:aiso/constants/app_colors.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:aiso/view_models/reports_view_model.dart';
import 'package:aiso/views/auth/auth_checker_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {

  await Supabase.initialize(
    url: 'https://evekbdfpapkdsmsxnhcc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV2ZWtiZGZwYXBrZHNtc3huaGNjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0Mzk3NjMsImV4cCI6MjA2MzAxNTc2M30.7bL6wXGb6PqyFCLvlgC3Ug_xJE4ReejddA3XuPrYV24',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        // ChangeNotifierProvider(create: (_) => MessengerViewModel()),
        ChangeNotifierProvider(create: (_) => ReportViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Search Optimisation',
      theme: ThemeData(
        // Set the default font family to Roboto Mono
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        // If you want to set it globally for app UI, you can also update the fontFamily directly like:
        fontFamily: 'Montserrat',
        
        // Set primary swatch and other colors
        primaryColor: AppColors.color1,
        scaffoldBackgroundColor: AppColors.color3,
        canvasColor: AppColors.color4,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.color1,
          onPrimary: Colors.white,
          secondary: AppColors.color2,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          surface: AppColors.color4,
          onSurface: Colors.black,
        ),
      ),
      home: const AuthChecker(),
    );
  }
}