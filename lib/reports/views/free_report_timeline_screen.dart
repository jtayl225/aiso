// import 'package:aiso/reports/view_models/free_report_view_model.dart';
// import 'package:aiso/reports/views/timeline.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class FreeReportTimelineScreen extends StatelessWidget {
//   const FreeReportTimelineScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<FreeReportViewModel>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Free Report Progress'),
//       ),
//       body: Center(
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 400),
//           child: Column(
//             children: [
//               Expanded(
//                 child: Timeline(
//                   steps: vm.steps,
//                   currentStep: vm.currentStep,
//                   highlightColor: Colors.green,
//                   defaultColor: Colors.grey.shade300,
//                 ),
//               ),
//               if (vm.currentStep < vm.steps.length - 1)
//                 const Padding(
//                   padding: EdgeInsets.only(bottom: 16.0),
//                   child: Text(
//                     'Hang tight! This may take a moment...',
//                     style: TextStyle(fontStyle: FontStyle.italic),
//                   ),
//                 ),
//               if (vm.currentStep == vm.steps.length)
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.check_circle),
//                     label: const Text("View Report"),
//                     onPressed: () {
//                       // TODO: Navigate to report detail screen
//                       // Navigator.push(...);
//                     },
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:aiso/Reports/view_models/free_report_view_model.dart';
import 'package:aiso/Reports/views/free_report_results_screen.dart';
import 'package:aiso/Reports/views/timeline.dart';
import 'package:aiso/locator.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FreeReportTimelineScreen extends StatefulWidget {
  const FreeReportTimelineScreen({super.key});

  @override
  State<FreeReportTimelineScreen> createState() => _FreeReportTimelineScreenState();
}

class _FreeReportTimelineScreenState extends State<FreeReportTimelineScreen> {
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FreeReportViewModel>();

    // Trigger navigation when all steps are complete
    if (!_hasNavigated && vm.currentStep == vm.steps.length) {
      _hasNavigated = true;
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        locator<NavigationService>().navigateTo(freeReportResultsRoute);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => ChangeNotifierProvider.value(
        //       value: vm,
        //       child: const FreeReportResultScreen(),
        //     ),
        //   ),
        // );
        
      });
    }

    // ✅ Always return a widget
    return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            children: [
              Expanded(
                child: Timeline(
                  steps: vm.steps,
                  currentStep: vm.currentStep,
                  highlightColor: Colors.green,
                  defaultColor: Colors.grey.shade300,
                ),
              ),
              if (vm.currentStep < vm.steps.length)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Hang tight! This may take a moment...',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
            ],
          ),
        ),
      );
  }


}
