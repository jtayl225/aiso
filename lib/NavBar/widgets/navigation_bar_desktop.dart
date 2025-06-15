import 'package:aiso/Auth/views/auth_home_view.dart';
import 'package:aiso/Auth/views/auth_profile_view.dart';
import 'package:aiso/Home/widgets/home_tablet_desktop.dart';
import 'package:aiso/NavBar/widgets/nav_bar_item.dart';
import 'package:aiso/NavBar/widgets/nav_bar_logo.dart';
import 'package:aiso/Reports/views/reports_view.dart';
import 'package:aiso/Store/views/store_screen.dart';
import 'package:aiso/Store/views/store_view.dart';
import 'package:aiso/locator.dart';
import 'package:aiso/models/auth_state_enum.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/services/navigation_service.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationBarDesktop extends StatelessWidget {
  
  const NavigationBarDesktop({super.key});

  @override
  Widget build(BuildContext context) {

    final authState = context.watch<AuthViewModel>().authState;
    final isLoggedIn = authState == MyAuthState.authenticated;

    // 1️⃣ Define the two separate lists
    final loggedOutItems = <NavBarItem>[
       NavBarItem(
        'About',
        // onTap: () => Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => const HomeTabletDesktop()),
        // ),
        onTap: () {
          locator<NavigationService>().navigateTo(HomeRoute);
        }
      ),

      NavBarItem(
        'Pricing',
        // onTap: () => Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => const MyStore()),
        // ),
        onTap: () {
          locator<NavigationService>().navigateTo(StoreRoute);
        }
      ),
     
      NavBarItem(
        'Get started',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AuthHome()),
        ),
      ),
    ];

    final loggedInItems = <NavBarItem>[
       NavBarItem(
        'About',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomeTabletDesktop()),
        ),
      ),

      NavBarItem(
        'Pricing',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyStore()),
        ),
      ),
     
      NavBarItem(
        'Reports',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyReports()),
        ),
      ),
      NavBarItem(
        'Account',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AuthProfile()),
        ),
      ),
    ];

    // 2️⃣ Pick the right list
    final navBarItems = isLoggedIn ? loggedInItems : loggedOutItems;
    
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
              ...navBarItems.map((item) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: item,
              )),
            ],
          )
        ],
      ),
    );
  }
}