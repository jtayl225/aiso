import 'package:aiso/Widgets/row_col.dart';
import 'package:aiso/reports/view_models/reports_view_model.dart';
import 'package:aiso/reports/widgets/report_card.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ReportsRowCol extends StatelessWidget {
  final DeviceScreenType deviceType;

  const ReportsRowCol({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    final RowColType layoutType =
        deviceType == DeviceScreenType.desktop
            ? RowColType.row
            : RowColType.column;
    final isDesktop = deviceType == DeviceScreenType.desktop;
    final isCentered = !isDesktop;
    final spacing = isDesktop ? 100.0 : 50.0;
    final reportViewModel = context.watch<ReportsViewModel>();
    final reports = reportViewModel.reports;

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              RowCol(
                layoutType: layoutType,
                spacing: spacing,
                colCrossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                    mainAxisAlignment: isDesktop ? MainAxisAlignment.start :  MainAxisAlignment.center,
                    children: [
                      Text(
                        'Reports.',
                        style: AppTextStyles.h1(deviceType),
                        textAlign: isCentered ? TextAlign.center : TextAlign.start,
                      ),
                      SizedBox(height: 30),
                      Text(
                        'All of your reports can be found here. You can have up to 10 reports.',
                        style: AppTextStyles.body(deviceType),
                        textAlign: isCentered ? TextAlign.center : TextAlign.start,
                      ),
                    ],
                  ),
          
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 200, maxWidth: 400),
                      child: ElevatedButton(
                        onPressed: () {
                          appRouter.go(newReportRoute);
                        },
                        child: Text('New Report'),
                      ),
                    ),
                  ),
                ],
              ),
          
              SizedBox(height: 50,),
          
              ...reports.map((report) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: InkWell(
                    onTap: () {
                      final uri = Uri(
                        path: reportRoute,
                        queryParameters: {'report_id': report.id},
                      );
                      appRouter.go(uri.toString());
                    },
                    child: ReportCard(
                      leadingIcon: Icons.abc,
                      title: report.title,
                      lastRunAt: report.dbTimestamps.updatedAt,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
