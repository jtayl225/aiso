import 'package:aiso/reports/view_models/reports_view_model.dart';
import 'package:aiso/reports/widgets/reports_row_col.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MyReports extends StatelessWidget {
  const MyReports({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportsViewModel(),
      child: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => ReportsRowCol(deviceType: DeviceScreenType.mobile,),
        tablet: (BuildContext context) => ReportsRowCol(deviceType: DeviceScreenType.mobile,),
        desktop: (BuildContext context) => ReportsRowCol(deviceType: DeviceScreenType.desktop,),
      ),
    );
  }
}