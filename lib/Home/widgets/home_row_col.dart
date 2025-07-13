import 'package:aiso/Dashboards/views/iframe_view.dart';
import 'package:aiso/Home/widgets/call_to_action.dart';
import 'package:aiso/NavBar/widgets/markdown_viewer.dart';
import 'package:aiso/Widgets/figure.dart';
import 'package:aiso/Widgets/row_col.dart';
import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/free_reports/widgets/powered_by_logos.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/themes/h1_heading.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeRowCol extends StatelessWidget {

  final DeviceScreenType deviceType;

  // final RowColType layoutType;
  const HomeRowCol({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    final RowColType layoutType = deviceType == DeviceScreenType.desktop ? RowColType.row : RowColType.column;
    final double spacing = deviceType == DeviceScreenType.desktop ? 100.0 : 50.0;
    
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
    
        SizedBox(height: spacing),

        
    
        RowCol(
          layoutType: layoutType,
          flexes: [1,1],
          spacing: 16.0,
          children: [
    
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                H1Heading(deviceType: deviceType, text: 'Be Found. Gain Trust. Get Leads.'),

                SizedBox(height: 32),

                MarkdownContent(
                  markdownText: homeMarkdown1,
                  deviceType: deviceType
                  ),
              ],
            ),
    
            Center(
              child: Column(
                children: [
                  CallToAction(
                    title: 'Generate free report!',
                    onPressed: () {
                      appRouter.go(freeReportFormRoute);
                    },
                  ),
                  SizedBox(height: 10,),
                  PoweredByLogos(deviceType: deviceType),
                ],
              ),
            ),
          ],
        ),
    
        SizedBox(height: spacing),

        // Divider(),
    
        // SizedBox(height: 80),
    
        RowCol(
          layoutType: layoutType,
          flexes: [1,1],
          spacing: spacing,
          rowCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
    
            MarkdownContent(
              markdownText: homeMarkdown2,
              deviceType: deviceType
              ),
    
            // SizedBox(width: 50, height: 50),
            
            IframeView(
              url: convertYouTubeToEmbedUrl(youTubeLink),
              width: 400,
              height: 400,),
            
          ],
        ),
    
        // SizedBox(height: 80),

        SizedBox(height: spacing),
    
        RowCol(
          layoutType: layoutType,
          flexes: [1,1],
          children: [
            
            MarkdownContent(
              markdownText: homeMarkdown3,
              deviceType: deviceType
              ),
    
            SizedBox(width: 100, height: 100),
            
          ],
        ),
    
        // SizedBox(height: 80),

        SizedBox(height: spacing),    

        RowCol(
          layoutType: layoutType,
          flexes: [1,1],
          spacing: 16.0,
          children: [
            
            MarkdownContent(
              markdownText: homeMarkdown4,
              deviceType: deviceType
              ),
    
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Figure(
                  imagePath: 'assets/Google_vs_ChatGPT.png',
                  caption: 'Figure 1: Interest in Google vs ChatGPT over time.',
                  imageHeight: 600,
                  imageWidth: 600,
                ),
              ),
            ),
    
          ],
        ),
    
        SizedBox(height: spacing),
      ],
    );
  }
}
