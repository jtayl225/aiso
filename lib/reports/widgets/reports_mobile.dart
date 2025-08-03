import 'package:aiso/widgets/row_col.dart';
import 'package:aiso/reports/view_models/reports_view_model.dart';
import 'package:aiso/reports/widgets/report_card.dart';
import 'package:aiso/reports/widgets/reports_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ReportsMobile extends StatelessWidget {
  const ReportsMobile({super.key});

  @override
  Widget build(BuildContext context) {

    final reportViewModel = context.watch<ReportsViewModel>();
    final reports = reportViewModel.reports;

    return SingleChildScrollView(
                child: Column(
                  children: [
                  ReportsDetails(isCentered: true),
                  Column(
                    children:
                      reports.map((report) => Padding(
                        padding: const EdgeInsets.only(bottom: 4), // `right` is for horizontal lists
                        child: ReportCard(leadingIcon: Icons.abc, title: report.title, lastRunAt: report.dbTimestamps.updatedAt, deviceType: DeviceScreenType.mobile),
                      )).toList(),
                                
                  )
                ]),
              );
  }
}