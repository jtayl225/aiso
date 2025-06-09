import 'package:aiso/Auth/widgets/auth_home_desktop.dart';
import 'package:aiso/Auth/widgets/auth_home_mobile.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AuthHome extends StatelessWidget {
  const AuthHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => AuthHomeMobile(),
      tablet: (BuildContext context) => AuthHomeMobile(),
      desktop: (BuildContext context) => AuthHomeDesktop(),
    );
  }
}