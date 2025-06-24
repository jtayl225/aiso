import 'package:flutter/material.dart';

class FreeReportFormDetails extends StatelessWidget {
  final bool isCentered;

  const FreeReportFormDetails({super.key, required this.isCentered});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: Column(
        crossAxisAlignment: isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Free report.',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 45, height: 0.9),
            textAlign: isCentered ? TextAlign.center : TextAlign.start,
          ),
          SizedBox(height: 30,),
          Text(
            'Generate a free report on us and see where your business ranks relative to your competitors.',
            style: TextStyle(fontSize: 21, height: 1.7),
            textAlign: isCentered ? TextAlign.center : TextAlign.start,
          ),

          SizedBox(height: 30,),

        ],
      ),
    );
  }
}