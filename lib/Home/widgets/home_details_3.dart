import 'package:aiso/constants/font_sizes.dart';
import 'package:flutter/material.dart';

class HomeDetails3 extends StatelessWidget {
  const HomeDetails3({super.key});

  @override
  Widget build(BuildContext context) {
    final message = '''
GEO is important because millions of potential customers are bypassing Google, preferring instead to get instant answers from AI tools.

As more customers turn to AI to ask, “Who should I hire near me?”, businesses that understand how to show up in those answers will win.

Statistics on the decline of Google search and the rise of AI tools include:
• 25% projected decline in traditional search by 2026 (Gartner)
• 60% of Google searches now end without a click
• 180M+ monthly users on ChatGPT

Also, being featured in AI responses builds unprecedented trust. When ChatGPT or Google Gemini mentions your business, it is viewed as an unbiased recommendation.
''';

    return SizedBox(
      width: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Why it matters NOW.',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: fontSizeDesktopLarge,
              height: 0.9,
            ),
          ),

          SizedBox(height: 30),

          Text(
            message,
            style: TextStyle(fontSize: fontSizeDesktopSM, height: 1.7),
          ),
        ],
      ),
    );
  }
}
