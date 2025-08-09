import 'package:aiso/Dashboards/views/dashboard_menu.dart';
import 'package:aiso/reports/models/report_run_model.dart';
import 'package:aiso/reports/view_models/report_view_model.dart';
import 'package:aiso/reports/widgets/prompt_card.dart';
import 'package:aiso/reports/widgets/recommendation_card.dart';
import 'package:aiso/reports/widgets/search_target_card.dart';
import 'package:aiso/reports/widgets/upgrade_prompt_card.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/themes/h1_heading.dart';
import 'package:aiso/themes/typography.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ReportDesktop extends StatelessWidget {
  const ReportDesktop({super.key});

  @override
  Widget build(BuildContext context) {

    final authVm = context.watch<AuthViewModel>();
    final vm = context.watch<ReportViewModel>();

    final bool canShow = (vm.report?.isPaid == true || authVm.isSubscribed == true) ? true : false;

    if (vm.isLoading || vm.reportRuns.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('Your report is still processing and will be ready soon. Please try again in a few minutes (up to 10 minutes).'),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Row(
          //   children: [

          //     const Text(
          //       "Report title: ",
          //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          //     ),

          //     Text(
          //       vm.report!.title,
          //       style: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
          //     ),

          //   ],
          // ),

          Text(
            vm.report?.title ?? 'Untitled Report',
            // style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            style: AppTextStyles.h1(DeviceScreenType.desktop).copyWith(fontWeight: FontWeight.bold)
          ),

          // H1Heading(deviceType: DeviceScreenType.desktop, text: vm.report?.title ?? 'Untitled Report'),

          SizedBox(height: 8.0,),

          //  const Text(
          //   "Business details:",
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          // ),
      
          

          // const Text(
          //   "Report date:",
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          // ),

          SizedBox(height: 8.0,),

          DropdownButtonFormField<ReportRun>(
            value: vm.selectedReportRun,
            decoration: const InputDecoration(
              labelText: 'Report Date',
              border: OutlineInputBorder(),
            ),
            items:
                vm.reportRuns.map((run) {
                  return DropdownMenuItem<ReportRun>(
                    value: run,
                    child: Text(
                      DateFormat('d MMMM y').format(run.dbTimestamps.createdAt), // run.dbTimestamps.createdAt
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                vm.selectedReportRun = value;
              }
            },
          ),

          SizedBox(height: 8.0,),

          if (vm.searchTarget != null)
            SizedBox(width: double.infinity, child: SearchTargetCard(target: vm.searchTarget!)),

          SizedBox(height: 40.0,),

          Text(
            "Ranking reports:",
            // style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            style: AppTextStyles.h2(DeviceScreenType.desktop).copyWith(fontWeight: FontWeight.bold),
          ),
      
          // Prompts List
          if (vm.prompts != null && vm.prompts!.isNotEmpty)
            ...vm.prompts!.map((prompt) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: SizedBox(
                width: double.infinity, 
                child: PromptCard(
                  prompt: prompt,
                  onTap: () {

                    debugPrint('DEBUG: about to navigate to prompt results');

                    // if (vm.selectedReportRun?.id == null) {
                    //   debugPrint('❌ Cannot navigate: selectedReportRun.id is null');
                    //   return;
                    // }
                    final runId = vm.selectedReportRun?.id;

                    if (runId == null) {
                      debugPrint('❌ Cannot navigate: selectedReportRun.id is null');
                      return;
                    }

                    final uri = Uri(path: promptRoute, queryParameters: {'report_id': vm.reportId, 'report_run_id': runId, 'prompt_id': prompt.id});
                    appRouter.go(uri.toString());
                  }
                  )),
            )),
            
          if (vm.prompts == null || vm.prompts!.isEmpty)
            const Text('No ranking reports available for this report run.'),

          SizedBox(height: 20.0,),

          Text(
            "Recommendations:",
            // style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            style: AppTextStyles.h2(DeviceScreenType.desktop).copyWith(fontWeight: FontWeight.bold),
          ),



          // recommendation List
          if (canShow && vm.reportRunRecommendations != null && vm.reportRunRecommendations!.isNotEmpty)
            ...vm.reportRunRecommendations!.map((reco) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: RecoCard(
                reco: reco,
                onTap: () => debugPrint('DEBUG'),
                onMarkDone: () => vm.toggleRecommendationDone(
                    recommendationId: reco.id,
                    reportRunId: reco.reportRunId,
                  ),
                deviceType: DeviceScreenType.desktop,
                ),
                )
          ),

          if (!canShow)
            // Text('Upgrade to see recommendations.'),
            UpgradePromptCard(onSubscribe: () => appRouter.go(storeRoute)),

          SizedBox(height: 20.0,),

          Text(
            "Dashboards:",
            // style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            style: AppTextStyles.h2(DeviceScreenType.desktop).copyWith(fontWeight: FontWeight.bold),
          ),

          if (!canShow)
            // Text('Upgrade to see recommendations.'),
            UpgradePromptCard(onSubscribe: () => appRouter.go(storeRoute)),

          if (canShow)
            DashboardCard(
              dashboard: vm.dash0,
              onTap: () {
                  final uri = Uri(path: dash00Route, queryParameters: {'report_id': vm.reportId});
                  appRouter.go(uri.toString());
                }
              ),

          if (canShow && vm.reportRuns.length > 1)
            DashboardCard(
              dashboard: vm.dash1,
              onTap: () {
                  final uri = Uri(path: dash00Route, queryParameters: {'report_id': vm.reportId});
                  appRouter.go(uri.toString());
                }
              ),
      
          // // dashboard List
          // if (vm.dashboards != null && vm.dashboards!.isNotEmpty)
          //   ...vm.dashboards!.map((dash) => Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 2),
          //     child: DashboardCard(
          //       dashboard: dash, 
          //       // onTap: () async {
          //       //     await vm.generateDashboardUrl(dash.number);
          //       //   },
          //       // ),
          //       // onTap: () => appRouter.go(dash00Route),
          //       onTap: () {

          //         final uri = Uri(path: dash00Route, queryParameters: {'report_id': vm.reportId});
          //         appRouter.go(uri.toString());

          //       }
          //       ),
          //   )),
            
          // if (vm.dashboards == null || vm.dashboards!.isEmpty)
          //   const Text('No dashboards available for this report run.'),

          SizedBox(height: 20.0,),
      
          

        ],
      ),
    );
  }
}
