import 'package:aiso/free_reports/view_models/free_report_form_view_model.dart';
import 'package:aiso/free_reports/widgets/free_report_form_row_col.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FreeReportFormView extends StatelessWidget {
  const FreeReportFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FreeReportFormViewModel(),
      child: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => FreeReportFormRowCol(deviceType: DeviceScreenType.mobile), //FreeReportMobile(),
        tablet: (BuildContext context) => FreeReportFormRowCol(deviceType: DeviceScreenType.mobile),
        desktop: (BuildContext context) => FreeReportFormRowCol(deviceType: DeviceScreenType.desktop), //FreeReportDesktop(),
      ),
    );
  }
}