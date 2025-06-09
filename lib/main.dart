import 'package:aiso/Home/views/home_view.dart';
import 'package:aiso/Home/widgets/home_tablet_desktop.dart';
import 'package:aiso/Store/view_models/store_view_model.dart';
import 'package:aiso/Reports/views/example_timeline_screen.dart';
import 'package:aiso/themes/light_mode.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:aiso/Reports/view_models/reports_view_model.dart';
import 'package:aiso/views/auth/auth_checker_screen.dart';
import 'package:flutter/material.dart';
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
        ChangeNotifierProvider(create: (_) => StoreViewModel()),
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
      title: 'GEO MAX',
      theme: lightMode,
      home: const MyHome(), //AuthChecker(), // ExampleTimelineScreen(), AuthChecker(), // DashboardMenu(), // DashboardScreen(url: "https://www.wikipedia.org"), // StoreScreen(), //PromptHashScreen(), // AuthChecker(),  https://aiso-seyf.onrender.com 
    );
  }
}