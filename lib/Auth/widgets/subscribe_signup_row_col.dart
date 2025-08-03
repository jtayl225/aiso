import 'package:aiso/Auth/widgets/free_report_signup_details.dart';
import 'package:aiso/Auth/widgets/free_report_signup_form.dart';
import 'package:aiso/Store/view_models/store_view_model.dart';
import 'package:aiso/Store/widgets/product_card_small.dart';
import 'package:aiso/widgets/row_col.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SubscribeSignUpRowCol extends StatelessWidget {

  final DeviceScreenType deviceType;

  const SubscribeSignUpRowCol({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {

    final storeVm = context.read<StoreViewModel>();

    final bool isDesktop =
        deviceType == DeviceScreenType.desktop ? true : false;

    final RowColType layoutType =
        isDesktop ? RowColType.row : RowColType.column;

    final BoxConstraints constraints = isDesktop
      ? const BoxConstraints(maxWidth: 1400, minHeight: 600)
      : const BoxConstraints(maxWidth: 600); // mobile/tablet view

    return ConstrainedBox(
      constraints: constraints,
      child: RowCol(
        layoutType: layoutType,
        flexes: [1,1],
        spacing: 16.0,
        rowMainAxisAlignment: MainAxisAlignment.center,
        rowCrossAxisAlignment: CrossAxisAlignment.center,
        colMainAxisAlignment: MainAxisAlignment.center,
        colCrossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProductCardSmall(storeVm.selectedProduct),
          FreeReportSignUpForm()
        ],
      ),
    );
  }
}
