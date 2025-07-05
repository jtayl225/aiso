import 'package:aiso/locator.dart';
import 'package:aiso/reports/view_models/reports_view_model.dart';
import 'package:aiso/reports/widgets/report_card.dart';
import 'package:aiso/reports/widgets/reports_details.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:aiso/routing/app_router.dart';

class ReportsDesktop extends StatelessWidget {
  const ReportsDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final reportViewModel = context.watch<ReportsViewModel>();
    final reports = reportViewModel.reports;

    return Column(
      children: [
        ReportsDetails(isCentered: false),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children:
                  reports.map((report) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: InkWell(
                        onTap: () {
                          // locator<NavigationService>().navigateTo(reportRoute, queryParams: {'report_id': report.id});
                          final uri = Uri(path: reportRoute, queryParameters: {'report_id': report.id});
                          appRouter.go(uri.toString());
                          // context.go(uri.toString());
                        },
                        child: ReportCard(
                          leadingIcon: Icons.abc,
                          title: report.title,
                          lastRunAt: report.dbTimestamps.updatedAt,
                        ),
                      ),
                    );
                  }).toList(),
            ),

            // child: Column(
            //   children:
            //     reports.map((report) => Padding(
            //       padding: const EdgeInsets.only(bottom: 4), // `right` is for horizontal lists
            //       child: ReportCard(leadingIcon: Icons.abc, title: report.title, lastRunAt: report.dbTimestamps.updatedAt,),
            //     )).toList(),

            //     locator<NavigationService>().navigateTo(reportRoute, queryParams: {'report_id': report.id});

            // ),
          ),
        ),
      ],
    );
  }
}
