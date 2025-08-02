import 'package:aiso/reports/view_models/rank_view_model.dart';
import 'package:aiso/reports/widgets/prompt_desktop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RankPaidView extends StatelessWidget {

  final String reportId;

  const RankPaidView({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RankViewModel(reportId: reportId),
      child: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => PromptDesktop(deviceType: DeviceScreenType.mobile),
        tablet: (BuildContext context) => PromptDesktop(deviceType: DeviceScreenType.mobile),
        desktop: (BuildContext context) => PromptDesktop(deviceType: DeviceScreenType.desktop),
      ),
    );
  }
}