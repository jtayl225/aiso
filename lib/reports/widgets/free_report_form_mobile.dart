import 'package:aiso/reports/widgets/free_report_form.dart';
import 'package:aiso/reports/widgets/free_report_form_details.dart';
import 'package:flutter/material.dart';

class FreeReportMobile extends StatelessWidget {
  const FreeReportMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FreeReportFormDetails(isCentered: true),
                    FreeReportForm()
                ]),
              );
  }
}