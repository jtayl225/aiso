import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/reports/view_models/prompt_view_model.dart';
import 'package:aiso/reports/widgets/prompt_result_card.dart';
import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PromptDesktop extends StatelessWidget {
  const PromptDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PromptViewModel>();

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
        children: [

          Text(vm.prompt!.prompt,
          style: AppTextStyles.h2(DeviceScreenType.desktop)
          ),

          SizedBox(height: 30),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('ChatGPT'),
                        ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                            child: Image.asset(logoChatGPT)
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...vm.chatGptPromptResults
                        .map((promptResult) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: PromptResultCard(result: promptResult),
                            ))
                        ,
                  ]
                ),
              ),

              SizedBox(width: 10),
          
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Gemini'),
                        ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                            child: Image.asset(logoGemini)
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...vm.geminiPromptResults
                        .map((promptResult) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: PromptResultCard(result: promptResult),
                            ))
                        ,
                  ]
                ),
              ),
          
            ],
          ),
        ],
      ),
    );
  }
}
