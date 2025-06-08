import 'package:aiso/reports/view_models/free_report_view_model.dart';
import 'package:aiso/reports/views/timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FreeReportTimelineScreen extends StatelessWidget {
  const FreeReportTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FreeReportViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Free Report Progress'),
      ),
      body: Center(
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
              if (vm.currentStep < vm.steps.length - 1)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Hang tight! This may take a moment...',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              if (vm.currentStep == vm.steps.length - 1)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle),
                    label: const Text("View Report"),
                    onPressed: () {
                      // TODO: Navigate to report detail screen
                      // Navigator.push(...);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
