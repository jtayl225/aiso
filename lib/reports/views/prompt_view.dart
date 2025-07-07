import 'package:aiso/reports/view_models/prompt_view_model.dart';
import 'package:aiso/reports/widgets/prompt_desktop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MyPromptView extends StatelessWidget {

  final String reportId;
  final String reportRunId;
  final String promptId;

  const MyPromptView({super.key, required this.reportId, required this.reportRunId, required this.promptId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PromptViewModel(reportId: reportId, reportRunId: reportRunId, promptId: promptId),
      child: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => PromptDesktop(),
        tablet: (BuildContext context) => PromptDesktop(),
        desktop: (BuildContext context) => PromptDesktop(),
      ),
    );
  }
}