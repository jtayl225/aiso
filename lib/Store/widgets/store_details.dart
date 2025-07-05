import 'package:aiso/constants/font_sizes.dart';
import 'package:flutter/material.dart';

class StoreDetails extends StatelessWidget {
  const StoreDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Pricing.',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: fontSizeDesktopLarge, height: 0.9),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Text(
            'Up grade to a monthly or yearly plan to receive monthly ranking reports with personalised recommendations to improve your visibility on AI tools.',
            style: TextStyle(fontSize: fontSizeDesktopMedium, height: 1.7),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}