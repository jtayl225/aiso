import 'package:aiso/constants/app_colors.dart';
import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class H1Heading extends StatelessWidget {

  final DeviceScreenType deviceType;
  final String text;

  const H1Heading({super.key, required this.deviceType, required this.text});

  @override
  Widget build(BuildContext context) {

    return Column(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          text,
          style: AppTextStyles.h1(deviceType),
          textAlign: TextAlign.start,
        ),

        const SizedBox(height: 8), // Space between text and line

        Container(
          height: 2, // Line thickness
          width: 80, // You can make this dynamic if needed
          color: AppColors.color3, // Replace with any color you like
        ),
        
      ],
    );
  }
}
