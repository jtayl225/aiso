import 'package:aiso/Dashboards/views/iframe_view.dart';
import 'package:aiso/Home/widgets/call_to_action.dart';
import 'package:aiso/NavBar/widgets/markdown_viewer.dart';
import 'package:aiso/Widgets/figure.dart';
import 'package:aiso/Widgets/row_col.dart';
import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/reports/view_models/free_report_view_model.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeRowCol extends StatelessWidget {

  final DeviceScreenType deviceType;

  // final RowColType layoutType;
  const HomeRowCol({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FreeReportViewModel>();
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
    
            MarkdownContent(
              markdownText: homeMarkdown1,
              deviceType: deviceType
              ),
    
            Center(
              child: Column(
                children: [
                  CallToAction(
                    title: 'Generate free report!',
                    onPressed: () {
                      // authVM.anonSignInIfUnauth();
                      vm.reset();
                      appRouter.go(freeReportFormRoute);
                    },
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Powered by: ',
                        style: AppTextStyles.body(deviceType)
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                        child: Image.asset(logoChatGPT)
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                        child: Image.asset(logoGemini)
                      ),

                    ],
                  )
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
          crossAxisAlignment: deviceType == DeviceScreenType.desktop ? CrossAxisAlignment.start : null,
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
