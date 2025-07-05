import 'package:aiso/constants/font_sizes.dart';
import 'package:flutter/material.dart';

class HomeDetails4 extends StatelessWidget {
  const HomeDetails4({super.key});

  @override
  Widget build(BuildContext context) {
    final message = '''
When people search “Which real estate agent should I use to sell my home in Bondi”, GEO is the way you make sure that it's you who's recommended.

GEO isn't just for real estate agents — it's for any business people ask AI tools like ChatGPT or Google Gemini about.

Whether you're a plumber, dentist, accountant, or hairdresser, more and more people are turning to AI to help them decide who to trust.
''';

    return SizedBox(
      width: 800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'What is Generative Engine Optimisation (GOE)?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: fontSizeDesktopML,
              height: 0.9,
            ),
          ),

          SizedBox(height: 30),

          Text(
            message,
            style: TextStyle(fontSize: fontSizeDesktopMedium, height: 1.7),
          ),
        ],
      ),
    );
  }
}
