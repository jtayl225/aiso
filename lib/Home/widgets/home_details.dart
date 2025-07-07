import 'package:aiso/constants/font_sizes.dart';
import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeDetails extends StatelessWidget {
  const HomeDetails({super.key});

  @override
  Widget build(BuildContext context) {

    final DeviceScreenType device = DeviceScreenType.desktop;

    return SizedBox(
      width: 800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Text(
            'Be Found. Gain Trust. Get Leads.',
            style: AppTextStyles.h1(device),
            // style: TextStyle(
            //     fontWeight: FontWeight.w800, fontSize: fontSizeDesktopLarge, height: 0.9),
          ),

          SizedBox(
            height: ResponsiveSpacing.headingMarginBottom(device),
          ),

          Text(
            'Find out where your business ranks when people ask ChatGPT or Google Gemini who to trust — and unlock a new way to generate leads from AI search.\n\nIt''s the new SEO — smarter, faster, and built for the future.',
            style: TextStyle(fontSize: fontSizeDesktopMedium, height: 1.7),
          ),
        ],
      ),
    );
  }
}