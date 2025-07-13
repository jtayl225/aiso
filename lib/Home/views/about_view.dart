import 'package:aiso/Home/widgets/about_row_col.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => AboutRowCol(deviceType: DeviceScreenType.mobile,),
      tablet: (BuildContext context) => AboutRowCol(deviceType: DeviceScreenType.mobile,),
      desktop: (BuildContext context) => AboutRowCol(deviceType: DeviceScreenType.desktop,),
    );
  }
}