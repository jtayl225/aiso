// import 'package:aiso/Home/views/home_view.dart';
// import 'package:aiso/Home/widgets/home_tablet_desktop.dart';
import 'package:aiso/reports/view_models/free_report_view_model.dart';
import 'package:aiso/Store/view_models/store_view_model.dart';
// import 'package:aiso/reports/views/example_timeline_screen.dart';
// import 'package:aiso/locator.dart';
import 'package:aiso/routing/app_router.dart';
// import 'package:aiso/routing/route_names.dart';
// import 'package:aiso/routing/router.dart';
// import 'package:aiso/services/navigation_service.dart';
import 'package:aiso/themes/light_mode.dart';
import 'package:aiso/view_models/auth_view_model.dart';
// import 'package:aiso/reports/view_models/reports_view_model.dart';
// import 'package:aiso/views/auth/auth_checker_screen.dart';
import 'package:aiso/views/layout_template/layout_template.dart';
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

  // Handle magic link login (only needed on web)
  final currentUrl = web.window.location.href;
  final authResponse = await Supabase.instance.client.auth
      .getSessionFromUrl(Uri.parse(currentUrl));

  // Remove query params from URL after login
  // Clean up URL
  if (web.window.location.hash.isNotEmpty) {
    final cleanUrl = currentUrl.split('#').first;
    web.window.history.replaceState(null, '', cleanUrl);
  }

  // authResponse.session != null ? ReportsPage() : LoginPage()

  // setupLocator();
  usePathUrlStrategy();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        // ChangeNotifierProvider(create: (_) => MessengerViewModel()),
        ChangeNotifierProvider(create: (_) => FreeReportViewModel()), 
        // ChangeNotifierProvider(create: (_) => ReportsViewModel()), 
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
      title: 'GEO MAX',
      theme: lightMode,
      routerConfig: appRouter,
      builder: (context, child) {
        // locator<NavigationService>().setContext(context);
        return LayoutTemplate(child: child!);
      },
      // builder: (context, child) => LayoutTemplate(
      //   child: child!,
      // ),
      // navigatorKey: locator<NavigationService>().navigatorKey,
      // onGenerateRoute: generateRoute,
      // initialRoute: HomeRoute,
      // home: const LayoutTemplate(), // MyHome(), //AuthChecker(), // ExampleTimelineScreen(), AuthChecker(), // DashboardMenu(), // DashboardScreen(url: "https://www.wikipedia.org"), // StoreScreen(), //PromptHashScreen(), // AuthChecker(),  https://aiso-seyf.onrender.com 
    );
  }
}