import 'package:aiso/Dashboards/views/dashboard_menu.dart';
import 'package:aiso/reports/models/report_run_model.dart';
import 'package:aiso/reports/view_models/report_view_model.dart';
import 'package:aiso/reports/widgets/prompt_card.dart';
import 'package:aiso/reports/widgets/recommendation_card.dart';
import 'package:aiso/reports/widgets/search_target_card.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportDesktop extends StatelessWidget {
  const ReportDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReportViewModel>();

    if (vm.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
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
                vm.report!.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

          SizedBox(height: 30.0,),

          const Text(
            "Report date:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 14.0,),

          DropdownButtonFormField<ReportRun>(
            value: vm.selectedReportRun,
            decoration: const InputDecoration(
              labelText: 'Date',
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

          SizedBox(height: 20.0,),
      
          const Text(
            "Business details:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
      
          if (vm.searchTarget != null)
            SizedBox(width: double.infinity, child: SearchTargetCard(target: vm.searchTarget!)),

          SizedBox(height: 20.0,),

          const Text(
            "Recommendations:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          // recommendation List
          if (vm.reportRunRecommendations != null && vm.reportRunRecommendations!.isNotEmpty)
            ...vm.reportRunRecommendations!.map((reco) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: RecoCard(
                reco: reco,
                onTap: () => debugPrint('DEBUG'),
                onMarkDone: () => vm.toggleRecommendationDone(
                    recommendationId: reco.id,
                    reportRunId: reco.reportRunId,
                  ),
                ),)
          ),

          SizedBox(height: 20.0,),

          const Text(
            "Dashboards:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
      
          // dashboard List
          if (vm.dashboards != null && vm.dashboards!.isNotEmpty)
            ...vm.dashboards!.map((dash) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: DashboardCard(
                dashboard: dash, 
                onTap: () async {
                    await vm.generateDashboardUrl(dash.number);
                  },
                ),
            )),
            
          if (vm.dashboards == null || vm.dashboards!.isEmpty)
            const Text('No dashboards available for this report run.'),

          SizedBox(height: 20.0,),
      
          const Text(
            "Prompts:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    if (vm.selectedReportRun?.id == null) {
                      debugPrint('❌ Cannot navigate: selectedReportRun.id is null');
                      return;
                    }
                    final uri = Uri(path: promptRoute, queryParameters: {'report_id': vm.reportId, 'report_run_id': vm.selectedReportRun?.id, 'prompt_id': prompt.id});
                    appRouter.go(uri.toString());
                  }
                  )),
            )),
            
          if (vm.prompts == null || vm.prompts!.isEmpty)
            const Text('No prompts available for this report run.'),

        ],
      ),
    );
  }
}
