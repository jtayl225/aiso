import 'package:aiso/Auth/widgets/signin_row_col.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => SignInRowCol(deviceType: DeviceScreenType.mobile,),
      tablet: (BuildContext context) => SignInRowCol(deviceType: DeviceScreenType.mobile,),
      desktop: (BuildContext context) => SignInRowCol(deviceType: DeviceScreenType.desktop,),
    );
  }
}