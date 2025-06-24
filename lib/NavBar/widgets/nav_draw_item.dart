import 'package:flutter/material.dart';

class NavDrawItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const NavDrawItem(this.title, this.icon, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}