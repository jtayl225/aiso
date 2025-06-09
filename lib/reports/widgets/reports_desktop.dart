import 'package:aiso/Home/widgets/centered_view.dart';
import 'package:aiso/NavBar/views/navgation_bar.dart';
import 'package:aiso/Reports/view_models/reports_view_model.dart';
import 'package:aiso/Reports/widgets/report_card.dart';
import 'package:aiso/Reports/widgets/reports_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportsDesktop extends StatelessWidget {
  const ReportsDesktop({super.key});

  @override
  Widget build(BuildContext context) {

    final reportViewModel = context.watch<ReportViewModel>();
    final reports = reportViewModel.reports;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          children: <Widget>[
            MyNavigationBar(),
            Expanded(
              child: Row(
                children: [
                Column(
                  children: [
                    ReportsDetails(isCentered: false),
                    Spacer()
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children:
                        reports.map((report) => Padding(
                          padding: const EdgeInsets.only(bottom: 4), // `right` is for horizontal lists
                          child: ReportCard(leadingIcon: Icons.abc, title: report.title, lastRunAt: report.dbTimestamps.updatedAt,),
                        )).toList(),
                                  
                    ),
                  )
                )
              ]),
            )
          ]
          ),
      ),
    );
  }
}