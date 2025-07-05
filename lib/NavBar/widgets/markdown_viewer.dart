import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class MarkdownViewer extends StatelessWidget {
  final String markdownText;

  const MarkdownViewer({super.key, required this.markdownText});

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: markdownText,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        h1Padding: const EdgeInsets.only(top: 40, bottom: 16),
        h2Padding: const EdgeInsets.only(top: 32, bottom: 12),
        h3Padding: const EdgeInsets.only(top: 24, bottom: 8),
        // You can also tweak fonts if needed:
        // h1: Theme.of(context).textTheme.headlineLarge,
        // h2: Theme.of(context).textTheme.headlineMedium,
        // h3: Theme.of(context).textTheme.headlineSmall,
      ),
      selectable: true,
      softLineBreak: true,
      extensionSet: md.ExtensionSet.gitHubFlavored,
    );
  }
}
