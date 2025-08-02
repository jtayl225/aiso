import 'package:aiso/free_reports/widgets/rank_free_row_col.dart';
import 'package:aiso/reports/view_models/rank_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RankFreeView extends StatelessWidget {

  final String reportId;

  const RankFreeView({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RankViewModel(reportId: reportId),
      child: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => RankFreeRowCol(deviceType: DeviceScreenType.mobile),
        tablet: (BuildContext context) => RankFreeRowCol(deviceType: DeviceScreenType.mobile),
        desktop: (BuildContext context) => RankFreeRowCol(deviceType: DeviceScreenType.desktop),
      ),
    );
  }
}