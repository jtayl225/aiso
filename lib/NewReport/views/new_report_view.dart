import 'package:aiso/NewReport/view_models/new_report_view_model.dart';
import 'package:aiso/NewReport/widgets/new_report_form.dart';
import 'package:aiso/Widgets/row_col.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class NewReportView extends StatelessWidget {
  const NewReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewReportViewModel(),
      child: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => NewReportForm(rowColType: RowColType.column),
        tablet: (BuildContext context) => NewReportForm(rowColType: RowColType.column),
        desktop: (BuildContext context) => NewReportForm(rowColType: RowColType.row),
      ),
    );
  }
}