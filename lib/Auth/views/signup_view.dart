import 'package:aiso/Auth/widgets/signup_desktop.dart';
import 'package:aiso/Auth/widgets/signup_mobile.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => SignUpMobile(),
      tablet: (BuildContext context) => SignUpMobile(),
      desktop: (BuildContext context) => SignUpDesktop(),
    );
  }
}