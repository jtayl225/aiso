import 'package:aiso/Auth/widgets/signup_details.dart';
import 'package:aiso/Auth/widgets/signup_form.dart';
import 'package:aiso/Widgets/row_col.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignUpRowCol extends StatelessWidget {

  final DeviceScreenType deviceType;

  const SignUpRowCol({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {

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
        layoutType: RowColType.column, // layoutType,
        flexes: [1,1],
        spacing: 16.0,
        rowMainAxisAlignment: MainAxisAlignment.center,
        rowCrossAxisAlignment: CrossAxisAlignment.center,
        colMainAxisAlignment: MainAxisAlignment.center,
        colCrossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SignUpDetails(deviceType: deviceType),
          SignUpForm()
        ],
      ),
    );
  }
}
