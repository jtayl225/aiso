import 'package:aiso/reports/widgets/upgrade_prompt_card_v2.dart';
import 'package:aiso/widgets/row_col.dart';
import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/reports/view_models/prompt_view_model.dart';
import 'package:aiso/reports/view_models/rank_view_model.dart';
import 'package:aiso/reports/widgets/prompt_result_card.dart';
import 'package:aiso/reports/widgets/upgrade_prompt_card.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RankFreeRowCol extends StatelessWidget {

  final DeviceScreenType deviceType;

  const RankFreeRowCol({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {

    final vm = context.watch<RankViewModel>();
    final bool isDesktop = deviceType == DeviceScreenType.desktop; 

    if (vm.isLoading || vm.prompt == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
    
        Text(vm.prompt!.prompt, style: AppTextStyles.h2(deviceType)),
    
        SizedBox(height: 30),

        // Text(
        //     vm.searchTargetRank != -1
        //         ? 'You are ranked #${vm.searchTargetRank}'
        //         : 'You are not in the top 10.',
        //     // style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        //     style: AppTextStyles.h2(deviceType),
        //     textAlign: TextAlign.center,
        //   ),

        RowCol(
          layoutType:
              isDesktop
                  ? RowColType.row
                  : RowColType.column,
          // layoutType: RowColType.row,
          flexes: [1,1],
          spacing: 16.0,
          rowCrossAxisAlignment: CrossAxisAlignment.start,
          // rowCrossAxisAlignment: CrossAxisAlignment.stretch,
          
          children: [

            if (!isDesktop)
              // UpgradePromptCard(onSubscribe: () => appRouter.go(storeRoute)),
              UpgradePromptCardV2(deviceType: deviceType, onSubscribe: () => appRouter.go(storeRoute)),

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
        
                const SizedBox(height: 16),
        
                ...vm.chatGptPromptResults.map(
                  (promptResult) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PromptResultCard(result: promptResult),
                  ),
                ),

                const SizedBox(height: 32),
        
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
        
                const SizedBox(height: 16),
        
                ...vm.geminiPromptResults.map(
                  (promptResult) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PromptResultCard(result: promptResult),
                  ),
                ),        
        
              ],
            ),
        
            if (isDesktop)
              // UpgradePromptCard(onSubscribe: () => appRouter.go(storeRoute)),
              UpgradePromptCardV2(deviceType: deviceType, onSubscribe: () => appRouter.go(storeRoute)),
        
          ],
        ),
      ],
    );
  }
}
