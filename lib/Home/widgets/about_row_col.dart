import 'package:aiso/NavBar/widgets/markdown_viewer.dart';
import 'package:aiso/Widgets/row_col.dart';
import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/themes/h1_heading.dart';
import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AboutRowCol extends StatelessWidget {

  final DeviceScreenType deviceType;

  const AboutRowCol({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {

    final RowColType layoutType = deviceType == DeviceScreenType.desktop ? RowColType.row : RowColType.column;
    final double spacing = deviceType == DeviceScreenType.desktop ? 100.0 : 50.0;

    final double minImageDimensions = 125.0;
    final double maxImageDimensions = 150.0;
    
    return Column(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: withSpacing([

        H1Heading(deviceType: deviceType, text: 'About GEOMAX.'),

        MarkdownContent(
              markdownText: aboutMarkdown,
              deviceType: deviceType
              ),

        H1Heading(deviceType: deviceType, text: 'Meet the Founders.'),

        RowCol(
          layoutType:  RowColType.row,// layoutType,,
          flexes: [1,5],
          spacing: spacing,
          children: [

            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: minImageDimensions, 
                maxHeight: maxImageDimensions, 
                minWidth: minImageDimensions, 
                maxWidth: maxImageDimensions),
              child: Image.asset(aboutJustinImage),
            ),
    
            MarkdownContent(
              markdownText: aboutJustin,
              deviceType: deviceType
              ),

          ]
        ),

        RowCol(
          layoutType:  RowColType.row,// layoutType,,
          flexes: [1,5],
          spacing: spacing,
          children: [

            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: minImageDimensions, 
                maxHeight: maxImageDimensions, 
                minWidth: minImageDimensions, 
                maxWidth: maxImageDimensions),
              child: Image.asset(aboutBlairImage),
            ),
    
            MarkdownContent(
              markdownText: aboutBlair,
              deviceType: deviceType
              ),

          ]
        ),

        RowCol(
          layoutType: RowColType.row,// layoutType,
          flexes: [1,5],
          spacing: spacing,
          children: [

            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: minImageDimensions, 
                maxHeight: maxImageDimensions, 
                minWidth: minImageDimensions, 
                maxWidth: maxImageDimensions),
              child: Image.asset(aboutJesseImage),
            ),
    
            MarkdownContent(
              markdownText: aboutJesse,
              deviceType: deviceType
              ),

          ]
        ),

      ], 16.0)
    );
  }
}

List<Widget> withSpacing(List<Widget> children, double verticalPadding) {
  return children.map((child) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: child,
    );
  }).toList();
}

