import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:flutter/material.dart';

class NavBarLogo extends StatelessWidget {

  const NavBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 150.0, maxWidth: 150.0),
      child: GestureDetector(
        onTap:() => appRouter.go(homeRoute),
        child: Image.asset(logoImage)),
    );
  }
}