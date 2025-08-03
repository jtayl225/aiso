import 'package:aiso/Auth/widgets/signin_details.dart';
import 'package:aiso/Auth/widgets/signin_form.dart';
import 'package:aiso/widgets/row_col.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignInRowCol extends StatelessWidget {

  final DeviceScreenType deviceType;

  const SignInRowCol({super.key, required this.deviceType});

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
          SignInDetails(deviceType: deviceType), 
          SignInForm(),
        ],
      ),
    );
  }
}
