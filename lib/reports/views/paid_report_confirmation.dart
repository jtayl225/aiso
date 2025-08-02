import 'package:aiso/reports/widgets/paid_report_thank_you.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PaidReportConfirmationView extends StatelessWidget {

  const PaidReportConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => PaidReportThankYou(deviceType: DeviceScreenType.mobile),
      tablet: (BuildContext context) => PaidReportThankYou(deviceType: DeviceScreenType.mobile),
      desktop: (BuildContext context) => PaidReportThankYou(deviceType: DeviceScreenType.desktop),
    );
  }
}