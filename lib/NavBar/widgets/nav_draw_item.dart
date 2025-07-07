import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
              // style: const TextStyle(fontSize: 18),
              style: AppTextStyles.h3(DeviceScreenType.mobile),
            ),
          ],
        ),
      ),
    );
  }
}