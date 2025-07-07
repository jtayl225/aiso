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

// import 'package:flutter/material.dart';

// class NavBarItem extends StatelessWidget {
//   final String title;
//   final VoidCallback onTap;

//   const NavBarItem(this.title, {super.key, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Focus(
//       canRequestFocus: false,
//       child: Material(
//         type: MaterialType.transparency,
//         child: InkWell(
//           // hoverColor: Colors.transparent,
//           // splashColor: Colors.transparent,
//           // highlightColor: Colors.transparent,
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 18,
//                 // color: Colors.green,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class NavBarItem extends StatelessWidget {
//   final String title;
//   final VoidCallback onTap;
//   final bool isSelected;

//   const NavBarItem(
//     this.title, {
//     super.key,
//     required this.onTap,
//     this.isSelected = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       type: MaterialType.transparency,
//       child: InkWell(
//         onTap: onTap,
//         // hoverColor: Colors.transparent, // disables hover effect
//         // splashColor: Colors.transparent,
//         // highlightColor: Colors.transparent,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//           child: Text(
//             title,
//             style: TextStyle(
//               fontSize: 18,
//               // color: isSelected ? Colors.grey : Colors.black,
//               // fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class NavBarItem extends StatefulWidget {
//   final String title;
//   final VoidCallback onTap;
//   final bool isSelected;

//   const NavBarItem(
//     this.title, {
//     super.key,
//     required this.onTap,
//     this.isSelected = false,
//   });

//   @override
//   State<NavBarItem> createState() => _NavBarItemState();
// }

// class _NavBarItemState extends State<NavBarItem> {
//   bool _isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     final bgColor = widget.isSelected
//         ? Colors.grey.shade300
//         : _isHovered
//             ? Colors.grey.shade100
//             : Colors.transparent;

//     final textColor = widget.isSelected ? Colors.black : Colors.black87;

//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       child: GestureDetector(
//         onTap: widget.onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           curve: Curves.easeOut,
//           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//           decoration: BoxDecoration(
//             color: bgColor,
//             borderRadius: BorderRadius.circular(6),
//           ),
//           child: Text(
//             widget.title,
//             style: TextStyle(
//               fontSize: 18,
//               color: textColor,
//               fontWeight:
//                   widget.isSelected ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class NavBarItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const NavBarItem(
    this.title, {
    super.key,
    required this.onTap,
  });

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
