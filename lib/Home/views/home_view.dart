import 'package:aiso/Home/widgets/home_mobile.dart';
import 'package:aiso/Home/widgets/home_row_col.dart';
import 'package:aiso/Home/widgets/home_tablet_desktop.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => HomeRowCol(deviceType: DeviceScreenType.mobile,), // HomeMobile(),
      tablet: (BuildContext context) => HomeRowCol(deviceType: DeviceScreenType.mobile,),
      desktop: (BuildContext context) => HomeRowCol(deviceType: DeviceScreenType.desktop,), // HomeTabletDesktop(),
    );
  }
}