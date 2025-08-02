import 'package:aiso/reports/view_models/recommendation_view_model.dart';
import 'package:aiso/reports/widgets/recommendations_paid_rowcol.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RecommendationsPaidView extends StatelessWidget {

  final String reportId;

  const RecommendationsPaidView({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecommendationViewModel(reportId: reportId),
      child: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => RecommendationsPaidRowCol(deviceType: DeviceScreenType.mobile),
        tablet: (BuildContext context) => RecommendationsPaidRowCol(deviceType: DeviceScreenType.mobile),
        desktop: (BuildContext context) => RecommendationsPaidRowCol(deviceType: DeviceScreenType.desktop),
      ),
    );
  }
}