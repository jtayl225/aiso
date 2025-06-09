import 'package:aiso/Auth/widgets/auth_profile_desktop.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AuthProfile extends StatelessWidget {
  const AuthProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => AuthProfileDesktop(),
      tablet: (BuildContext context) => AuthProfileDesktop(),
      desktop: (BuildContext context) => AuthProfileDesktop(),
    );
  }
}