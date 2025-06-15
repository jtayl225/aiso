import 'package:aiso/Reports/view_models/free_report_view_model.dart';
import 'package:aiso/Reports/widgets/free_report_form_desktop.dart';
import 'package:aiso/Reports/widgets/free_report_form_mobile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FreeReport extends StatelessWidget {
  const FreeReport({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => FreeReportMobile(),
      tablet: (BuildContext context) => FreeReportMobile(),
      desktop: (BuildContext context) => FreeReportDesktop(),
    );
  }
}

class FreeReportWrapper extends StatelessWidget {
  const FreeReportWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FreeReportViewModel(userId: '0'),
      child: const FreeReport(),
    );
  }
}
