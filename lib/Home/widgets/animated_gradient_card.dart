import 'package:flutter/material.dart';

class AnimatedGradientCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final List<Color> colors;
  final Duration duration;

  const AnimatedGradientCard({
    Key? key,
    required this.child,
    this.margin,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius,
    required this.colors,
    this.duration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  State<AnimatedGradientCard> createState() => _AnimatedGradientCardState();
}

class _AnimatedGradientCardState extends State<AnimatedGradientCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Smooth easing for back-and-forth
    ));

    _controller.repeat(reverse: true); // This makes it go back and forth!
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Extend colors to create seamless loop
    final extendedColors = [...widget.colors, widget.colors.first];
    
    return Container(
      margin: widget.margin ?? const EdgeInsets.all(12),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Safety check - show static gradient if animation not ready
          if (_animation == null) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: const Alignment(-1, -1),
                  end: const Alignment(1, 1),
                  colors: extendedColors,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                child: Padding(
                  padding: widget.padding!,
                  child: widget.child,
                ),
              ),
            );
          }
          
          // Smooth back-and-forth sweep from -2 to +2
          final position = -2.0 + (_animation!.value * 4.0);
          
          return Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment(position - 1, -1),
                end: Alignment(position + 1, 1),
                colors: extendedColors,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
              child: Padding(
                padding: widget.padding!,
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}

// // Usage example
// class ExampleUsage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedGradientCard(
//       colors: [
//         Colors.blue,
//         Colors.green,
//         Colors.purple,
//         Colors.orange,
//       ],
//       margin: const EdgeInsets.all(12),
//       padding: const EdgeInsets.all(16.0),
//       borderRadius: BorderRadius.circular(16),
//       duration: const Duration(seconds: 4),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             "The GEOMAX AI visibility tool is for you if you are:",
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             "• The market leader and you want to stay ahead\n"
//             "• An underperforming agent looking for a competitive advantage\n"
//             "• A new real estate agent with big ambitions",
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }