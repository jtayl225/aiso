import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int n;       // total number of steps
  final int nth;     // current step (1-based)
  final Color color; // highlight color

  const StepIndicator({
    super.key,
    required this.n,
    required this.nth,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp nth to range 1..n
    final int step = nth.clamp(1, n);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Step $step of $n',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: List.generate(n, (index) {
            final bool isActive = (index + 1) <= step;
            return Expanded(
              child: Container(
                height: 6,
                margin: EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: isActive ? color : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
