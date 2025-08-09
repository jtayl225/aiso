import 'package:aiso/Dashboards/views/iframe_view.dart';
import 'package:aiso/Home/widgets/call_to_action.dart';
import 'package:aiso/NavBar/widgets/markdown_viewer.dart';
import 'package:aiso/widgets/figure.dart';
import 'package:aiso/widgets/row_col.dart';
import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/free_reports/widgets/powered_by_logos.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/themes/h1_heading.dart';
import 'package:aiso/themes/typography.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:aiso/widgets/supabase_video_player.dart';

class HomeRowCol extends StatelessWidget {
  final DeviceScreenType deviceType;

  // final RowColType layoutType;
  const HomeRowCol({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();

    final RowColType layoutType =
        deviceType == DeviceScreenType.desktop
            ? RowColType.row
            : RowColType.column;
    final double spacing = deviceType == DeviceScreenType.desktop ? 32.0 : 16.0;

    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: spacing),

        RowCol(
          layoutType: layoutType,
          flexes: [3, 2],
          spacing: 16.0,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // H1Heading(deviceType: deviceType, text: 'Be Found. Gain Trust. Get Leads.'),
                Text(
                  'Be Found. Gain Trust. Get Leads.',
                  style: AppTextStyles.h1(deviceType),
                  textAlign: TextAlign.start,
                ),

                SizedBox(height: 32),

                MarkdownContent(
                  markdownText: homeMarkdown1,
                  deviceType: deviceType,
                ),
              ],
            ),

            Center(
              child: Column(
                children: [
                  CallToAction(
                    title:  authVm.isAuthenticated ? 'My reports!' : 'Generate free report!',
                    onPressed: () {
                      // appRouter.go(freeReportSignUpRoute);
                      authVm.isAuthenticated
                          ? appRouter.go(reportsRoute)
                          : appRouter.go(freeReportSignUpRoute);
                    },
                  ),
                  SizedBox(height: 10),
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
          layoutType: RowColType.column, //layoutType,
          flexes: [1, 1],
          spacing: spacing,
          colCrossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // IframeView(
            //   url: convertYouTubeToEmbedUrl(youTubeLink),
            //   width: 500,
            //   height: 500,
            // ),

            // IframeView(
            //   url: convertYouTubeToEmbedUrl(youTubeLink),
            //   width: 750,
            //   height: 750,
            // ),

            // SupabaseVideoPlayer(
            //   videoUrl: supabaseVideoUrl,
            // ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: SupabaseVideoPlayer(videoUrl: supabaseVideoUrl),
                ),
              ),
            ),

            SizedBox(height: 16),
          ],
        ),

        RowCol(
          layoutType: layoutType,
          flexes: [2, 3],
          spacing: spacing,
          rowCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (layoutType == RowColType.row)
            //   SizedBox(width: 100, height: 100),
            MarkdownContent(
              markdownText: homeMarkdown2,
              deviceType: deviceType,
            ),
          ],
        ),

        // SizedBox(height: 80),
        SizedBox(height: spacing),

        RowCol(
          layoutType: layoutType,
          flexes: [3, 2],
          children: [
            MarkdownContent(
              markdownText: homeMarkdown3,
              deviceType: deviceType,
            ),

            // if (layoutType == RowColType.row)
            //   SizedBox(width: 100, height: 100),
          ],
        ),

        // SizedBox(height: 80),
        SizedBox(height: spacing),

        RowCol(
          layoutType: layoutType,
          flexes: [1, 1],
          spacing: 16.0,
          children: [

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

        RowCol(
          layoutType: layoutType,
          flexes: [1, 1],
          spacing: 16.0,
          children: [
            MarkdownContent(
              markdownText: homeMarkdown4,
              deviceType: deviceType,
            ),
          ],
        ),

        SizedBox(height: spacing),

      ],
    );
  }
}
