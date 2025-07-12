import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PoweredByLogos extends StatelessWidget {
  
  final DeviceScreenType deviceType;

  const PoweredByLogos({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Powered by: ', style: AppTextStyles.body(deviceType)),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
          child: Image.asset(logoChatGPT),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
          child: Image.asset(logoGemini),
        ),
      ],
    );
  }
}
