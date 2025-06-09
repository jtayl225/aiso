// import 'package:flutter/material.dart';

// class NavBarItem extends StatelessWidget {
//   final String title;
//   const NavBarItem(this.title, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: TextStyle(fontSize: 18),
//     );
//   }
// }

import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const NavBarItem(this.title, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
