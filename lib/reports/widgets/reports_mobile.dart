import 'package:aiso/Reports/view_models/reports_view_model.dart';
import 'package:aiso/Reports/widgets/report_card.dart';
import 'package:aiso/Reports/widgets/reports_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportsMobile extends StatelessWidget {
  const ReportsMobile({super.key});

  @override
  Widget build(BuildContext context) {

    final reportViewModel = context.watch<ReportViewModel>();
    final reports = reportViewModel.reports;

    return SingleChildScrollView(
                child: Column(
                  children: [
                  ReportsDetails(isCentered: true),
                  Column(
                    children:
                      reports.map((report) => Padding(
                        padding: const EdgeInsets.only(bottom: 4), // `right` is for horizontal lists
                        child: ReportCard(leadingIcon: Icons.abc, title: report.title, lastRunAt: report.dbTimestamps.updatedAt,),
                      )).toList(),
                                
                  )
                ]),
              );
  }
}