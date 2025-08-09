import 'package:aiso/constants/app_colors.dart';
import 'package:aiso/themes/typography.dart';
import 'package:aiso/widgets/step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FreeReportFormDetails extends StatelessWidget {

  final DeviceScreenType deviceType;
  final bool isCentered;

  const FreeReportFormDetails({super.key, required this.deviceType, required this.isCentered});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: Column(
        crossAxisAlignment: isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Get your free report.',
            // style: TextStyle(fontWeight: FontWeight.w800, fontSize: fontSizeDesktopLarge, height: 0.9),
            style: AppTextStyles.h1(deviceType),
            textAlign: isCentered ? TextAlign.center : TextAlign.start,
          ),

          SizedBox(height: 30,),

          Text(
            // 'Create your free account with your email and password to generate a complimentary report — and see exactly where your business ranks against your competitors.',
            'Generate a free report on us and see where your business ranks relative to your competitors.',
            // style: TextStyle(fontSize: fontSizeDesktopMedium, height: 1.7),
            style: AppTextStyles.h3(deviceType),
            textAlign: isCentered ? TextAlign.center : TextAlign.start,
          ),

          SizedBox(height: 30,),

          StepIndicator(
          n: 2,      // total steps
          nth: 2,    // current step (step 2)
          color: AppColors.color3,
        ),
        SizedBox(height: 30,),

          // SizedBox(height: 16,),

        ],
      ),
    );
  }
}