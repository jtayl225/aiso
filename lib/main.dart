import 'package:aiso/Store/view_models/store_view_model.dart';
import 'package:aiso/free_reports/view_models/free_report_view_model.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/themes/light_mode.dart';
import 'package:aiso/utils/logger.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:aiso/Widgets/layout_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web/web.dart' as web;

Future<void> main() async {

  await Supabase.initialize(
    url: 'https://evekbdfpapkdsmsxnhcc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV2ZWtiZGZwYXBrZHNtc3huaGNjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0Mzk3NjMsImV4cCI6MjA2MzAxNTc2M30.7bL6wXGb6PqyFCLvlgC3Ug_xJE4ReejddA3XuPrYV24',
  );

  final currentUrl = web.window.location.href;
  printDebug('URL: $currentUrl');

  if (currentUrl.contains("access_token") && currentUrl.contains("refresh_token")) {
    try {
 
      final params = Uri.splitQueryString(currentUrl.replaceFirst('#', ''));
      printDebug('params: $params');
      final refreshToken = params['refresh_token'];

      if (refreshToken != null) {
        await Supabase.instance.client.auth.setSession(refreshToken);
        appRouter.go(reportRoute);
      }
      
      final user = Supabase.instance.client.auth.currentUser;
      printInfo('Logged in as: ${user?.email}');
      
      // Clean up URL
      final cleanUrl = currentUrl.split('#').first;
      web.window.history.replaceState(null, '', cleanUrl);

    } catch (e) {
      printError("❌ Error during magic link login: $e");
    }
  }

  // setupLocator();
  usePathUrlStrategy();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
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
    return MaterialApp.router(
      title: 'GEOMAX',
      theme: lightMode,
      routerConfig: appRouter,
      builder: (context, child) {
        return LayoutTemplate(child: child!);
      },
    );
  }
}