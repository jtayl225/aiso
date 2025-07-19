import 'package:flutter/material.dart';

class Figure extends StatelessWidget {
  final String imagePath;
  final String caption;
  final double borderRadius;
  final double imageHeight;
  final double imageWidth;

  const Figure({
    super.key,
    required this.imagePath,
    required this.caption,
    this.borderRadius = 12.0,
    this.imageHeight = 500.0,
    this.imageWidth = 500.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(borderRadius),
        //   child: ConstrainedBox(
        //     constraints: BoxConstraints(
        //       maxHeight: imageHeight,
        //       maxWidth: imageWidth
        //     ),
        //     child: Image.asset(
        //       imagePath,
        //       // height: imageHeight,
        //       // width: imageWidth,
        //       fit: BoxFit.contain,
        //     ),
        //   ),
        // ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: imageHeight,
                maxWidth: imageWidth,
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),


        const SizedBox(height: 8),

        Text(
          caption,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
        ),

        


      ],
    );
  }
}
