// import 'package:flutter/material.dart';

// class CallToAction extends StatelessWidget {
//   final String title;
//   const CallToAction({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
//       decoration: BoxDecoration(
//           color: Color.fromARGB(255, 31, 229, 146),
//           borderRadius: BorderRadius.circular(5)
//         ),
//       child: Text(
//       title,
//       style: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.w800,
//         color: Colors.white,
//       ),
//     ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class CallToAction extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CallToAction({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
      //   backgroundColor: const Color.fromARGB(255, 31, 229, 146),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(5),
      //   ),
      //   elevation: 2,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          // fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}
