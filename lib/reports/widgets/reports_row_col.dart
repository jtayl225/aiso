import 'package:aiso/Widgets/row_col.dart';
import 'package:aiso/reports/view_models/reports_view_model.dart';
import 'package:aiso/reports/widgets/report_card.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/themes/typography.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ReportsRowCol extends StatelessWidget {
  final DeviceScreenType deviceType;

  const ReportsRowCol({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

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
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RowCol(
              layoutType: layoutType,
              spacing: spacing,
              colMainAxisAlignment: MainAxisAlignment.center,
              colCrossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Reports.',
                  style: AppTextStyles.h1(deviceType),
                  textAlign: isCentered ? TextAlign.center : TextAlign.start,
                ),
      
                Text(
                  'All of your reports can be found here. You can have up to 10 reports.',
                  style: AppTextStyles.body(deviceType),
                  textAlign: isCentered ? TextAlign.center : TextAlign.start,
                ),
      
                // Column(
                //   crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                //   mainAxisAlignment: isDesktop ? MainAxisAlignment.start :  MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       'Reports.',
                //       style: AppTextStyles.h1(deviceType),
                //       textAlign: isCentered ? TextAlign.center : TextAlign.start,
                //     ),
                //     SizedBox(height: 30),
                //     Text(
                //       'All of your reports can be found here. You can have up to 10 reports.',
                //       style: AppTextStyles.body(deviceType),
                //       textAlign: isCentered ? TextAlign.center : TextAlign.start,
                //     ),
                //   ],
                // ),
      
                // Center(
                //   child: ConstrainedBox(
                //     constraints: BoxConstraints(minWidth: 200, maxWidth: 400),
                //     child: ElevatedButton(
                //     onPressed: reports.length >= 10
                //         ? null // ❌ disables the button
                //         : () {
                //             authVM.isSubscribed
                //                 ? appRouter.go(newReportRoute)
                //                 : appRouter.go(storeRoute);
                //           },
                //     child: const Text('New Report'),
                //   ),
      
                //   ),
                // ),
              ],
            ),
      
            SizedBox(height: 50),
      
            ...reports.map((report) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: ReportCard(
                  leadingIcon: Icons.abc,
                  title: report.title,
                  onPressedRank: () {
                    final uri = Uri(
                      // path: report.isPaid ? reportRoute : freeReportRoute,
                      path: rankPaidRoute,
                      queryParameters: {'report_id': report.id},
                    );
                    appRouter.go(uri.toString());
                  },
                  onPressedRecommendations: () {
                    final uri = Uri(
                      // path: report.isPaid ? reportRoute : freeReportRoute,
                      path: recoPaidRoute,
                      queryParameters: {'report_id': report.id},
                    );
                    appRouter.go(uri.toString());
                  },
                  lastRunAt: report.dbTimestamps.updatedAt,
                  deviceType: deviceType
                ),
                // child: InkWell(
                //   onTap: () {
                //     final uri = Uri(
                //       // path: report.isPaid ? reportRoute : freeReportRoute,
                //       path: reportRoute,
                //       queryParameters: {'report_id': report.id},
                //     );
                //     appRouter.go(uri.toString());
                //   },
                //   child: ReportCard(
                //     leadingIcon: Icons.abc,
                //     title: report.title,
                //     onPressedRank: () {
      
                //       final uri = Uri(
                //       // path: report.isPaid ? reportRoute : freeReportRoute,
                //       path: reportRoute,
                //       queryParameters: {'report_id': report.id},
                //       );
                //       appRouter.go(uri.toString());
      
                //     },
                //     lastRunAt: report.dbTimestamps.updatedAt,
                //   ),
                // ),
              );
            }),
      
            SizedBox(height: 24,),
      
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 200, maxWidth: 400),
              child: ElevatedButton(
                onPressed:
                    reports.length >= 10
                        ? null // ❌ disables the button
                        : () {
                          authVM.isSubscribed
                              ? appRouter.go(newReportRoute)
                              : appRouter.go(storeRoute);
                        },
                child: const Text('New Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
