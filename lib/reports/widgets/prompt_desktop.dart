import 'package:aiso/Widgets/row_col.dart';
import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/reports/models/report_run_model.dart';
import 'package:aiso/reports/view_models/prompt_view_model.dart';
import 'package:aiso/reports/view_models/rank_view_model.dart';
import 'package:aiso/reports/widgets/prompt_result_card.dart';
import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PromptDesktop extends StatelessWidget {
  final DeviceScreenType deviceType;

  const PromptDesktop({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    // final vm = context.watch<PromptViewModel>();
    final vm = context.watch<RankViewModel>();

    if (vm.isLoading || vm.prompt == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [

          SizedBox(height: 4),

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

          SizedBox(height: 30),

          Text(vm.prompt!.prompt, style: AppTextStyles.h2(deviceType)),

          SizedBox(height: 30),

          IntrinsicHeight(
            child: RowCol(
              layoutType:
                  deviceType == DeviceScreenType.desktop
                      ? RowColType.row
                      : RowColType.column,
              flexes: [1,1],
              spacing: 16.0,
              // rowCrossAxisAlignment: CrossAxisAlignment.start,
              rowCrossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const Text('ChatGPT'),

                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 30,
                            maxWidth: 30,
                          ),
                          child: Image.asset(logoChatGPT),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      vm.chatGptTargetRank != -1
                          ? 'You are ranked #${vm.chatGptTargetRank}'
                          : 'You are not in the top 10.',
                      style: AppTextStyles.h3(deviceType),
                      textAlign: TextAlign.center,
                    ),

                    // const SizedBox(height: 4),

                    const SizedBox(height: 16),

                    ...vm.chatGptPromptResults.map(
                      (promptResult) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PromptResultCard(result: promptResult),
                      ),
                    ),
                  ],
                ),
            
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const Text('Gemini'),

                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 30,
                            maxWidth: 30,
                          ),
                          child: Image.asset(logoGemini),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      vm.geminiTargetRank != -1
                          ? 'You are ranked #${vm.geminiTargetRank}'
                          : 'You are not in the top 10.',
                      style: AppTextStyles.h3(deviceType),
                      textAlign: TextAlign.center,
                    ),

                    // const SizedBox(height: 4),

                    const SizedBox(height: 16),
                    ...vm.geminiPromptResults.map(
                      (promptResult) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PromptResultCard(result: promptResult),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
