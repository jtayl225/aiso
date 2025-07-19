import 'package:aiso/Auth/widgets/subscribe_signup_row_col.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SubscribeSignUpView extends StatelessWidget {
  const SubscribeSignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => SubscribeSignUpRowCol(deviceType: DeviceScreenType.mobile,),
      tablet: (BuildContext context) => SubscribeSignUpRowCol(deviceType: DeviceScreenType.mobile,),
      desktop: (BuildContext context) => SubscribeSignUpRowCol(deviceType: DeviceScreenType.desktop,),
    );
  }
}