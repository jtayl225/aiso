import 'package:aiso/constants/font_sizes.dart';
import 'package:flutter/material.dart';

class HomeDetails2 extends StatelessWidget {
  const HomeDetails2({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Text(
            'How GEO MAX helps.',
            style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: fontSizeDesktopLarge, height: 0.9),
          ),

          SizedBox(
            height: 30,
          ),
          
          Text(
            'GEO MAX gives you a personalized report highlighting how your business ranks in AI-generated results, where your competitors show up — and how to improve your visibility so more customers find and choose you. It''s your roadmap to being the business AI recommends.',
            style: TextStyle(fontSize: fontSizeDesktopMedium, height: 1.7),
          ),
        ],
      ),
    );
  }
}