import 'package:aiso/reports/view_models/report_view_model.dart';
import 'package:aiso/reports/widgets/report_desktop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MyReportView extends StatelessWidget {

  final String reportId;

  const MyReportView({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportViewModel(reportId: reportId),
      child: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => ReportDesktop(),
        tablet: (BuildContext context) => ReportDesktop(),
        desktop: (BuildContext context) => ReportDesktop(),
      ),
    );
  }
}