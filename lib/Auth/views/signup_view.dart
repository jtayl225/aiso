import 'package:aiso/Auth/widgets/signup_row_col.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => SignUpRowCol(deviceType: DeviceScreenType.mobile,),
      tablet: (BuildContext context) => SignUpRowCol(deviceType: DeviceScreenType.mobile,),
      desktop: (BuildContext context) => SignUpRowCol(deviceType: DeviceScreenType.desktop,),
    );
  }
}