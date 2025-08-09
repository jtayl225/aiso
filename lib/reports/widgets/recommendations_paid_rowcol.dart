import 'package:aiso/Dashboards/views/dashboard_menu.dart';
import 'package:aiso/reports/models/report_run_model.dart';
import 'package:aiso/reports/view_models/recommendation_view_model.dart';
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

class RecommendationsPaidRowCol extends StatelessWidget {

  final DeviceScreenType deviceType;

  const RecommendationsPaidRowCol({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {

    final authVm = context.watch<AuthViewModel>();
    final vm = context.watch<RecommendationViewModel>();

    final bool canShow = (vm.report?.isPaid == true || authVm.isSubscribed == true) ? true : false;

    if (vm.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (vm.recommendations.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('Your report is still processing and will be ready soon. Please try again in a few minutes (up to 10 minutes).'),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Text(
            (vm.report?.locality?.name != null) ? 'Recommendations to become #1 in ${vm.report!.locality!.name}' : 'Recommendations to become #1',
            // style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            style: AppTextStyles.h1(deviceType).copyWith(fontWeight: FontWeight.bold)
          ),

          SizedBox(height: 8.0,),

          // DropdownButtonFormField<ReportRun>(
          //   value: vm.selectedReportRun,
          //   decoration: const InputDecoration(
          //     labelText: 'Report Date',
          //     border: OutlineInputBorder(),
          //   ),
          //   items:
          //       vm.reportRuns.map((run) {
          //         return DropdownMenuItem<ReportRun>(
          //           value: run,
          //           child: Text(
          //             DateFormat('d MMMM y').format(run.dbTimestamps.createdAt), // run.dbTimestamps.createdAt
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //         );
          //       }).toList(),
          //   onChanged: (value) {
          //     if (value != null) {
          //       vm.selectedReportRun = value;
          //     }
          //   },
          // ),       

          SizedBox(height: 40.0,),

          // recommendation List
          if (canShow && vm.recommendations.isNotEmpty)
            ...vm.recommendations.map((reco) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: RecoCard(
                reco: reco,
                onTap: () => debugPrint('DEBUG'),
                onMarkDone: () => vm.toggleRecommendationDone(recommendationId: reco.id),
                deviceType: deviceType
                ),)
          ),

          if (!canShow)
            // Text('Upgrade to see recommendations.'),
            UpgradePromptCard(onSubscribe: () => appRouter.go(storeRoute)),

          SizedBox(height: 20.0,),    
          

        ],
      ),
    );
  }
}
