import 'package:aiso/NavBar/widgets/nav_bar_logo.dart';
import 'package:aiso/NavBar/widgets/nav_draw_item.dart';
import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/models/auth_state_enum.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:url_launcher/url_launcher.dart';

class MyNavigationDrawer extends StatelessWidget {
  const MyNavigationDrawer({super.key});

  void _launchBlog() async {
    final url = Uri.parse(newsTabLink);

    if (!await launchUrl(url, webOnlyWindowName: '_blank')) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthViewModel>().authState;
    final isLoggedIn = authState == MyAuthState.authenticated;
    // final isSubscribed = context.watch<AuthViewModel>().isSubscribed;

    final navDrawItems = <NavDrawItem>[

      NavDrawItem(
        'About',
        Icons.info,
        onTap: () {
          // 1. Close the drawer
          Scaffold.of(context).closeDrawer();
          // 2. Then navigate to your Route
          appRouter.go(aboutRoute);
        },
      ),

       NavDrawItem(
        'Pricing',
        Icons.monetization_on_outlined,
        onTap: () {
          Scaffold.of(context).closeDrawer();
          appRouter.go(storeRoute);
        },
      ),

       NavDrawItem(
        'News',
        Icons.newspaper,
        onTap: () {
          Scaffold.of(context).closeDrawer();
          _launchBlog();
        },
      ),

      NavDrawItem(
        'FAQ''s',
        Icons.question_mark,
        onTap: () {
          Scaffold.of(context).closeDrawer();
          appRouter.go(faqRoute);
        },
      ),

      if (isLoggedIn)
        NavDrawItem(
          'Reports',
          Icons.document_scanner,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            appRouter.go(reportsRoute);
          },
        ),

      if (isLoggedIn)
        NavDrawItem(
          'Account',
          Icons.person,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            appRouter.go(profileRoute);
          },
        )
      else
        NavDrawItem(
          'Sign in',
          Icons.login,
          onTap: () {
            Scaffold.of(context).closeDrawer();
            appRouter.go(signInRoute);
          },
        ),

      NavDrawItem(
        'Terms & Conditions',
        Icons.description_outlined,
        onTap: () {
          Scaffold.of(context).closeDrawer();
          appRouter.go(termsRoute);
        },
      ),

      NavDrawItem(
        'Privacy Policy',
        Icons.privacy_tip,
        onTap: () {
          Scaffold.of(context).closeDrawer();
          appRouter.go(privacyRoute);
        },
      ),

    ];

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16)],
      ),
      child: Column(
        children: [
          // Center(child: NavBarLogo()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [NavBarLogo()],
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                   ...navDrawItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: item,
                ),
              ),
                ]
              ),
            ),
          )
      
         
        ],
      ),
    );
  }
}
