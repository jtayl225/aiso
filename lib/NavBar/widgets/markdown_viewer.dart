// import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:markdown/markdown.dart' as md;

// class MarkdownViewer extends StatelessWidget {
//   final String markdownText;

//   const MarkdownViewer({super.key, required this.markdownText});

//   @override
//   Widget build(BuildContext context) {
//     return Markdown(
//       data: markdownText,
//       styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
//         h1Padding: const EdgeInsets.only(top: 40, bottom: 16),
//         h2Padding: const EdgeInsets.only(top: 32, bottom: 12),
//         h3Padding: const EdgeInsets.only(top: 24, bottom: 8),
//         // You can also tweak fonts if needed:
//         // h1: Theme.of(context).textTheme.headlineLarge,
//         // h2: Theme.of(context).textTheme.headlineMedium,
//         // h3: Theme.of(context).textTheme.headlineSmall,
//       ),
//       selectable: true,
//       softLineBreak: true,
//       extensionSet: md.ExtensionSet.gitHubFlavored,
//     );
//   }
// }

import 'package:aiso/themes/h1_heading.dart';
import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:responsive_builder/responsive_builder.dart';

class MarkdownViewer extends StatelessWidget {
  final String markdownText;
  final DeviceScreenType deviceType;

  const MarkdownViewer({
    super.key,
    required this.markdownText,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: markdownText,
      selectable: true,
      softLineBreak: true,
      extensionSet: md.ExtensionSet.gitHubFlavored,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        h1: AppTextStyles.h1(deviceType),
        h2: AppTextStyles.h2(deviceType),
        h3: AppTextStyles.h3(deviceType),
        p: AppTextStyles.body(deviceType),

        h1Padding: EdgeInsets.only(
          top: ResponsiveSpacing.sectionPadding(deviceType),
          bottom: ResponsiveSpacing.headingMarginBottom(deviceType),
        ),
        h2Padding: EdgeInsets.only(
          top: ResponsiveSpacing.headingMarginBottom(deviceType),
          bottom: ResponsiveSpacing.paragraphSpacing(deviceType),
        ),
        h3Padding: EdgeInsets.only(
          top: ResponsiveSpacing.headingMarginBottom(deviceType) / 2,
          bottom: ResponsiveSpacing.paragraphSpacing(deviceType),
        ),
        listBulletPadding: const EdgeInsets.only(left: 12),
      ),
    );
  }
}

class MarkdownContent extends StatelessWidget {
  final String markdownText;
  final DeviceScreenType deviceType;

  const MarkdownContent({
    super.key,
    required this.markdownText,
    required this.deviceType
  });

  @override
  Widget build(BuildContext context) {

    return MarkdownBody(
      data: markdownText,
      extensionSet: md.ExtensionSet.gitHubFlavored,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        h1: AppTextStyles.h1(deviceType),
        h2: AppTextStyles.h2(deviceType),
        h3: AppTextStyles.h3(deviceType),
        p: AppTextStyles.body(deviceType),

        // Padding
        h1Padding: EdgeInsets.only(
          top: 0, //ResponsiveSpacing.sectionPadding(deviceType),
          bottom: ResponsiveSpacing.headingMarginBottom(deviceType),
        ),
        h2Padding: EdgeInsets.only(
          top: 24, // ResponsiveSpacing.headingMarginBottom(deviceType),
          bottom: 0, // ResponsiveSpacing.paragraphSpacing(deviceType),
        ),
        h3Padding: EdgeInsets.only(
          top: 0, //ResponsiveSpacing.headingMarginBottom(deviceType) / 2,
          bottom: ResponsiveSpacing.paragraphSpacing(deviceType),
        ),
        listBulletPadding: const EdgeInsets.only(left: 12),
      ),
    );
  }
}


class H1MarkdownContent extends StatelessWidget {

  final String headingText;
  final String bodyText;
  final DeviceScreenType deviceType;

  const H1MarkdownContent({
    super.key,
    required this.headingText,
    required this.bodyText,
    required this.deviceType
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H1Heading(deviceType: deviceType, text: headingText),
        SizedBox(height: 40),
        MarkdownContent(markdownText: bodyText, deviceType: deviceType)
      ],
    );
  }
}



