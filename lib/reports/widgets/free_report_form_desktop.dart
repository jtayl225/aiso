import 'package:aiso/reports/widgets/free_report_form.dart';
import 'package:aiso/reports/widgets/free_report_form_details.dart';
import 'package:flutter/material.dart';

class FreeReportDesktop extends StatelessWidget {
  const FreeReportDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FreeReportFormDetails(isCentered: false),
                  FreeReportForm()
              ]);
  }
}