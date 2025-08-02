import 'package:aiso/NavBar/widgets/markdown_viewer.dart';
import 'package:aiso/free_reports/widgets/free_report_thank_you.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FreeReportConfirmationView extends StatelessWidget {
  const FreeReportConfirmationView({super.key});

  final String viewText = """
# **Thank you!**

## Your free report is processing.

We will send you an email once your free report is ready.

This may take up to 10 minutes.
""";

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => FreeReportThankYou(deviceType: DeviceScreenType.mobile), //MarkdownContent(markdownText: viewText, deviceType: DeviceScreenType.mobile),
      tablet: (BuildContext context) => FreeReportThankYou(deviceType: DeviceScreenType.mobile), //MarkdownContent(markdownText: viewText, deviceType: DeviceScreenType.mobile),
      desktop: (BuildContext context) => FreeReportThankYou(deviceType: DeviceScreenType.desktop), //MarkdownContent(markdownText: viewText, deviceType: DeviceScreenType.desktop),
    );
  }
}