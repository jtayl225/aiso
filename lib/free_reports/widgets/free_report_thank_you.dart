import 'package:aiso/reports/widgets/upgrade_prompt_card.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FreeReportThankYou extends StatelessWidget {

  final DeviceScreenType deviceType;
  
  const FreeReportThankYou({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Text(
          'Your free report is being processed and will be emailed to you shortly.',
          style: AppTextStyles.h2(deviceType),
          textAlign: TextAlign.center,
        ),
    
        SizedBox(height: 16.0),

        Text(
          'This can take up to 10 minutes.',
          style: AppTextStyles.h3(deviceType),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 32.0),

        UpgradePromptCard(onSubscribe: () => appRouter.go(storeRoute)),
    
      ],
    );
  }
}
