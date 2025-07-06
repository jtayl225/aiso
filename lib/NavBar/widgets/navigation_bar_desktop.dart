import 'package:aiso/Auth/views/auth_home_view.dart';
import 'package:aiso/Auth/views/auth_profile_view.dart';
import 'package:aiso/Home/widgets/home_tablet_desktop.dart';
import 'package:aiso/NavBar/widgets/nav_bar_item.dart';
import 'package:aiso/NavBar/widgets/nav_bar_logo.dart';
import 'package:aiso/reports/views/reports_view.dart';
import 'package:aiso/Store/views/store_screen.dart';
import 'package:aiso/Store/views/store_view.dart';
import 'package:aiso/locator.dart';
import 'package:aiso/models/auth_state_enum.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/services/navigation_service.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationBarDesktop extends StatelessWidget {
  const NavigationBarDesktop({super.key});

  void _launchBlog() async {
    final url = Uri.parse('https://medium.com/generative-engine-optimization/generative-engine-optimization-geo-2d78a01f8313');

    if (!await launchUrl(url, webOnlyWindowName: '_blank')) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthViewModel>().authState;
    final isLoggedIn = authState == MyAuthState.authenticated;
    final isSubscribed = context.watch<AuthViewModel>().isSubscribed;

    final navBarItems = <NavBarItem>[
      NavBarItem('About', onTap: () => appRouter.go(aboutRoute)),
      NavBarItem('Pricing', onTap: () => appRouter.go(storeRoute)),
      NavBarItem('News', onTap: _launchBlog),
      NavBarItem('FAQ''s', onTap: () => appRouter.go(faqRoute)),

      if (isLoggedIn)
        NavBarItem('Reports', onTap: () => appRouter.go(reportsRoute)),

      if (isLoggedIn)
        NavBarItem('Account', onTap: () => appRouter.go(profileRoute))
      else
        NavBarItem('Sign in', onTap: () => appRouter.go(signInRoute)),

    ];

    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          NavBarLogo(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...navBarItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: item,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
