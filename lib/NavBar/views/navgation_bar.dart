import 'package:aiso/NavBar/widgets/navigation_bar_mobile.dart';
import 'package:aiso/NavBar/widgets/navigation_bar_desktop.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => NavigationBarMobile(),
      tablet: (BuildContext context) => NavigationBarMobile(),
      desktop: (BuildContext context) => NavigationBarDesktop(),
    );
  }
}