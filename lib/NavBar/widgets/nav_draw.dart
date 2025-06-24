import 'package:aiso/Auth/views/auth_home_view.dart';
import 'package:aiso/Auth/views/auth_profile_view.dart';
import 'package:aiso/NavBar/widgets/nav_bar_logo.dart';
import 'package:aiso/NavBar/widgets/nav_draw_item.dart';
import 'package:aiso/reports/views/reports_view.dart';
import 'package:aiso/locator.dart';
import 'package:aiso/models/auth_state_enum.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/services/navigation_service.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyNavigationDrawer extends StatelessWidget {
  const MyNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    final authState = context.watch<AuthViewModel>().authState;
    final isLoggedIn = authState == MyAuthState.authenticated;

    // 1️⃣ Define the two separate lists
    final loggedOutItems = <NavDrawItem>[
       NavDrawItem(
        'About',
        Icons.help,
        onTap: () {
          // 1. Close the drawer
          // Navigator.of(context).pop();
          // Navigator.of(context, rootNavigator: true).pop();
          // 2. Then navigate to your Route
          locator<NavigationService>().navigateTo(HomeRoute);
        }
      ),

      NavDrawItem(
        'Pricing',
        Icons.money,
        onTap: () {
          // 1. Close the drawer
          // Navigator.of(context).pop();
          // Navigator.of(context, rootNavigator: true).pop();
          // 2. Then navigate to your Route
          locator<NavigationService>().navigateTo(StoreRoute);
        }
      ),
     
      NavDrawItem(
        'Get started',
        Icons.airplane_ticket,
        onTap: () {
          // 1. Close the drawer
          // Navigator.of(context).pop();
          // Navigator.of(context, rootNavigator: true).pop();
          // 2. Then navigate to your Route
          locator<NavigationService>().navigateTo(GetStartedRoute);
        }
      ),
    ];

    final loggedInItems = <NavDrawItem>[
      NavDrawItem(
        'About',
        Icons.help,
        onTap: () {
          // 1. Close the drawer
          Navigator.of(context).pop();
          // 2. Then navigate to your Route
          locator<NavigationService>().navigateTo(HomeRoute);
        }
      ),

      NavDrawItem(
        'Pricing',
        Icons.money,
        onTap: () {
          // 1. Close the drawer
          Navigator.of(context).pop();
          // 2. Then navigate to your Route
          locator<NavigationService>().navigateTo(StoreRoute);
        }
      ),
     
      NavDrawItem(
        'Reports',
        Icons.document_scanner,
        onTap: () {
          // 1. Close the drawer
          Navigator.of(context).pop();
          // 2. Then navigate to your Route
          locator<NavigationService>().navigateTo(ReportsRoute);
        }
      ),

      NavDrawItem(
        'Account',
        Icons.document_scanner,
        onTap: () {
          // 1. Close the drawer
          Navigator.of(context).pop();
          // 2. Then navigate to your Route
          locator<NavigationService>().navigateTo(ProfileRoute);
        }
      ),
    ];

    // 2️⃣ Pick the right list
    final navBarItems = isLoggedIn ? loggedInItems : loggedOutItems;
    
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16)]
      ),
      child: Column(
        children: [
          NavBarLogo(),
      
          ...navBarItems.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: item,
                )),
      
        ]
      
      ),
    );
  }
}