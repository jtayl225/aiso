import 'package:aiso/Reports/widgets/reports_desktop.dart';
import 'package:aiso/Reports/widgets/reports_mobile.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MyReports extends StatelessWidget {
  const MyReports({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => ReportsMobile(),
      tablet: (BuildContext context) => ReportsMobile(),
      desktop: (BuildContext context) => ReportsDesktop(),
    );
  }
}