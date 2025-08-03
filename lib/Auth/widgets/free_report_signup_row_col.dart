import 'package:aiso/Auth/widgets/free_report_signup_details.dart';
import 'package:aiso/Auth/widgets/free_report_signup_form.dart';
import 'package:aiso/widgets/row_col.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FreeReportSignUpRowCol extends StatelessWidget {

  final DeviceScreenType deviceType;

  const FreeReportSignUpRowCol({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {

    final bool isDesktop =
        deviceType == DeviceScreenType.desktop ? true : false;

    final RowColType layoutType =
        isDesktop ? RowColType.row : RowColType.column;

    final BoxConstraints constraints = isDesktop
      ? const BoxConstraints(maxWidth: 1400, minHeight: 600)
      : const BoxConstraints(maxWidth: 600); // mobile/tablet view

    return ConstrainedBox(
      constraints: constraints,
      child: RowCol(
        layoutType: layoutType,
        flexes: [1,1],
        spacing: 16.0,
        rowMainAxisAlignment: MainAxisAlignment.center,
        rowCrossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FreeReportSignUpDetails(deviceType: deviceType),
          FreeReportSignUpForm()
        ],
      ),
    );
  }
}
