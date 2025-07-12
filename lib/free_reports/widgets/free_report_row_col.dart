import 'package:aiso/Widgets/row_col.dart';
import 'package:aiso/free_reports/widgets/free_report_form.dart';
import 'package:aiso/free_reports/widgets/free_report_form_details.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FreeReportRowCol extends StatelessWidget {

  final DeviceScreenType deviceType;

  const FreeReportRowCol({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    final RowColType layoutType =
        deviceType == DeviceScreenType.desktop
            ? RowColType.row
            : RowColType.column;
    final bool isDesktop =
        deviceType == DeviceScreenType.desktop ? true : true; //false

    return RowCol(
      layoutType: layoutType,
      flexes: [1,1],
      spacing: 16.0,
      rowMainAxisAlignment: MainAxisAlignment.center,
      rowCrossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FreeReportFormDetails(deviceType: deviceType, isCentered: isDesktop),
        FreeReportForm(deviceType: deviceType),
      ],
    );
  }
}
