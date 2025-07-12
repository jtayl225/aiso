import 'package:aiso/free_reports/view_models/free_report_view_model.dart';
import 'package:aiso/free_reports/widgets/free_report_row_col.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FreeReport extends StatelessWidget {
  const FreeReport({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FreeReportViewModel(),
      child: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => FreeReportRowCol(deviceType: DeviceScreenType.mobile), //FreeReportMobile(),
        tablet: (BuildContext context) => FreeReportRowCol(deviceType: DeviceScreenType.mobile),
        desktop: (BuildContext context) => FreeReportRowCol(deviceType: DeviceScreenType.desktop), //FreeReportDesktop(),
      ),
    );
  }
}