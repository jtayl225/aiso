import 'package:aiso/Dashboards/views/dashboard_menu.dart';
import 'package:aiso/reports/models/report_run_model.dart';
import 'package:aiso/reports/view_models/report_view_model.dart';
import 'package:aiso/reports/widgets/prompt_card.dart';
import 'package:aiso/reports/widgets/search_target_card.dart';
import 'package:flutter/material.dart';
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

          Row(
            children: [

              const Text(
                "Report title: ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              Text(
                vm.report!.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
              ),

            ],
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
                      run.dbTimestamps.createdAt.toIso8601String(),
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

          SizedBox(height: 14.0,),
      
          const Text(
            "Search Target:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
      
          if (vm.searchTarget != null)
            SearchTargetCard(target: vm.searchTarget!),

          SizedBox(height: 14.0,),

          const Text(
            "Dashboards:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
      
          // Prompts List
          if (vm.dashboards != null && vm.dashboards!.isNotEmpty)
            ...vm.dashboards!.map((dash) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DashboardCard(
                dashboard: dash, 
                onTap: () async {
                    await vm.generateDashboardUrl(dash.number);
                  },
                ),
            )),
            
          if (vm.dashboards == null || vm.dashboards!.isEmpty)
            const Text('No dashboards available for this report run.'),

          SizedBox(height: 14.0,),
      
          const Text(
            "Prompts:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
      
          // Prompts List
          if (vm.prompts != null && vm.prompts!.isNotEmpty)
            ...vm.prompts!.map((prompt) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 600.0),
                child: PromptCard(prompt: prompt)),
            )),
            
          if (vm.prompts == null || vm.prompts!.isEmpty)
            const Text('No prompts available for this report run.'),


      
      
      
      
        ],
      ),
    );
  }
}
