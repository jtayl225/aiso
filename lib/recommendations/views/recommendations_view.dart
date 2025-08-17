import 'package:aiso/recommendations/view_models/recommendation_v2_view_model.dart';
import 'package:aiso/recommendations/widgets/recommendations_row_col.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RecommendationsView extends StatelessWidget {

  const RecommendationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecommendationV2ViewModel(),
      child: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => RecommendationsRowCol(deviceType: DeviceScreenType.mobile),
        tablet: (BuildContext context) => RecommendationsRowCol(deviceType: DeviceScreenType.mobile),
        desktop: (BuildContext context) => RecommendationsRowCol(deviceType: DeviceScreenType.desktop),
      ),
    );
  }
}