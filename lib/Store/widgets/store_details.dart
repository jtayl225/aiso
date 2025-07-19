import 'package:aiso/NavBar/widgets/markdown_viewer.dart';
import 'package:aiso/constants/font_sizes.dart';
import 'package:aiso/themes/h1_heading.dart';
import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class StoreDetails extends StatelessWidget {

   final DeviceScreenType deviceType;

  const StoreDetails({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {
//     final String storeText = '''
// # Pricing.

// Up grade to a monthly or yearly plan to receive monthly ranking reports with personalised recommendations to improve your visibility on AI tools.
// ''';
//     return MarkdownContent(
//             markdownText: storeText,
//             deviceType: DeviceScreenType.desktop,
//           );
    
    return SizedBox(
      width: 900,
      child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          H1Heading(deviceType: deviceType, text: 'Pricing.'),
          

          // Text(
          //   'Pricing.',
          //   // style: TextStyle(fontWeight: FontWeight.w800, fontSize: fontSizeDesktopLarge, height: 0.9),
          //   style: AppTextStyles.h1(DeviceScreenType.desktop),
          //   textAlign: TextAlign.center,
          // ),
          SizedBox(height: 30),
          Text(
            'Up grade to a monthly or yearly plan to receive monthly ranking reports with personalised recommendations to improve your visibility on AI tools.',
            // style: TextStyle(fontSize: fontSizeDesktopMedium, height: 1.7),
            style: AppTextStyles.h3(deviceType),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
