import 'package:aiso/Dashboards/view_models/dash_view_model.dart';
import 'package:aiso/Dashboards/widgets/dash_00_row_col.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Dash00View extends StatelessWidget {

  final String reportId;

  const Dash00View({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashViewModel(reportId: reportId),
      child: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => Dash00RowCol(deviceType: DeviceScreenType.mobile),
        tablet: (BuildContext context) => Dash00RowCol(deviceType: DeviceScreenType.mobile),
        desktop: (BuildContext context) => Dash00RowCol(deviceType: DeviceScreenType.desktop),
      ),
    );
  }
}