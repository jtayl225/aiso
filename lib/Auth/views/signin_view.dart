import 'package:aiso/Auth/widgets/sigin_desktop.dart';
import 'package:aiso/Auth/widgets/signin_mobile.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => SignInMobile(),
      tablet: (BuildContext context) => SignInMobile(),
      desktop: (BuildContext context) => SignInDesktop(),
    );
  }
}