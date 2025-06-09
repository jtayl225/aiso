import 'package:flutter/material.dart';

class StoreDetails extends StatelessWidget {
  const StoreDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Pricing.',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 45, height: 0.9),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Upgrade to premium to get month reports with personalised recommendations to improve your GEO.',
            style: TextStyle(fontSize: 18, height: 1.7),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}