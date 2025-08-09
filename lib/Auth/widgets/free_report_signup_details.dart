import 'package:aiso/constants/app_colors.dart';
import 'package:aiso/themes/typography.dart';
import 'package:aiso/widgets/step_indicator.dart';
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
          'Create your free account with your email and password to generate a complimentary report — and see exactly where your business ranks against your competitors.',
          // 'Generate a free report on us and see where your business ranks relative to your competitors.',
          // style: TextStyle(fontSize: fontSizeDesktopMedium, height: 1.7),
          style: AppTextStyles.h3(deviceType),
          textAlign: TextAlign.center,
          // textAlign: isDesktop ? TextAlign.center : TextAlign.start,
        ),

        SizedBox(height: 30),

        StepIndicator(
          n: 2,      // total steps
          nth: 1,    // current step (step 2)
          color: AppColors.color3,
        ),

        SizedBox(height: 30),


       
      ],
    );
  }
}
