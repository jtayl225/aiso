import 'package:flutter/material.dart';

class ProportionCircle extends StatelessWidget {
  final double proportion; // value between 0.0 and 1.0

  const ProportionCircle({super.key, required this.proportion});

  @override
  Widget build(BuildContext context) {
    final percent = (proportion * 100).toStringAsFixed(1);

    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: proportion,
            strokeWidth: 8,
            backgroundColor: Colors.grey.shade300,
            color: Colors.blue,
          ),
          Text(
            '$percent%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}





class RadialPainter extends CustomPainter {
  final double proportion;
  final Color backgroundColor;
  final Color progressColor;

  RadialPainter({
    required this.proportion,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final strokeWidth = 12.0;
    final radius = (size.width / 2) - (strokeWidth / 2);

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final foregroundPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw full circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw arc
    final sweepAngle = 2 * 3.1415926 * proportion;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.1415926 / 2, // start at top
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
