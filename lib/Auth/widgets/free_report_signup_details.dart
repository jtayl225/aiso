import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FreeReportSignUpDetails extends StatelessWidget {
  
  final DeviceScreenType deviceType;

  const FreeReportSignUpDetails({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {

    // final bool isDesktop =
    //     deviceType == DeviceScreenType.desktop ? true : false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
          // isDesktop ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Get your free report.',
          style: AppTextStyles.h1(deviceType),
          textAlign: TextAlign.center,
          // textAlign: isDesktop ? TextAlign.center : TextAlign.start,
        ),

        SizedBox(height: 30),

        Text(
          'Generate a free report on us and see where your business ranks relative to your competitors.',
          // style: TextStyle(fontSize: fontSizeDesktopMedium, height: 1.7),
          style: AppTextStyles.h3(deviceType),
          textAlign: TextAlign.center,
          // textAlign: isDesktop ? TextAlign.center : TextAlign.start,
        ),

        SizedBox(height: 30),

       
      ],
    );
  }
}
