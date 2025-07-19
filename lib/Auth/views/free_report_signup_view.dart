import 'package:aiso/Auth/widgets/free_report_signup_row_col.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FreeReportSignUpView extends StatelessWidget {
  const FreeReportSignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => FreeReportSignUpRowCol(deviceType: DeviceScreenType.mobile,),
      tablet: (BuildContext context) => FreeReportSignUpRowCol(deviceType: DeviceScreenType.mobile,),
      desktop: (BuildContext context) => FreeReportSignUpRowCol(deviceType: DeviceScreenType.desktop,),
    );
  }
}