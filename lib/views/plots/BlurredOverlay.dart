// import 'dart:ui';
// import 'package:aiso/constants/app_colors.dart';
// import 'package:flutter/material.dart';

// class BlurredOverlay extends StatelessWidget {
//   final Widget child;
//   final bool isBlurred;

//   const BlurredOverlay({
//     super.key,
//     required this.child,
//     required this.isBlurred,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final sigmaXY = 16.0;
//     return SizedBox(
//       width: 120,
//       height: 120,
//       child: Stack(
//         children: [
//           // Underlying content
//           child,
      
//           // Blur + overlay if user is free
//           if (isBlurred)
//             // Positioned.fill(
//             //   child: ClipOval(
//             //     child: BackdropFilter(
//             //       filter: ImageFilter.blur(sigmaX: sigmaXY, sigmaY: sigmaXY),
//             //       child: Container(
//             //         width: double.infinity,
//             //         color: AppColors.color4.withValues(alpha: 0.3),
//             //         alignment: Alignment.center,
//             //         child: Text("Upgrade to unlock"),
//             //       ),
//             //     ),
//             //   ),
//             // ),

//             Center(
//               child: ClipOval(
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                   child: Container(
//                     width: 120, // same as your chart
//                     height: 120,
//                     alignment: Alignment.center,
//                     color: AppColors.color4.withAlpha((255 * 0.3).round()),
//                     child: const Text(
//                       "Upgrade to unlock",
//                       textAlign: TextAlign.center,
//                       // style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ),
//             )




//         ],
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:aiso/constants/app_colors.dart';
import 'package:flutter/material.dart';

class BlurredOverlay extends StatelessWidget {
  final Widget child;
  final bool isBlurred;
  final VoidCallback? onTap; // <-- Added

  const BlurredOverlay({
    super.key,
    required this.child,
    required this.isBlurred,
    this.onTap, // <-- Added
  });

  @override
  Widget build(BuildContext context) {
    final sigmaXY = 16.0;
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          // Underlying content
          child,

          // Blur + overlay if user is free
          if (isBlurred)
            RepaintBoundary(
              child: Center(
                child: ClipOval(
                  child: GestureDetector( // <-- Added
                    onTap: onTap,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: sigmaXY, sigmaY: sigmaXY),
                      child: Container(
                        width: 120,
                        height: 120,
                        alignment: Alignment.center,
                        color: AppColors.color4.withValues(alpha: 0.3),
                        child: const Text(
                          "Upgrade to unlock",
                          textAlign: TextAlign.center,
                          // style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
