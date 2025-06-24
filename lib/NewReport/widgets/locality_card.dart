import 'package:flutter/material.dart';
import 'package:aiso/models/location_models.dart'; // adjust as needed

class LocalityCard extends StatelessWidget {
  final Locality locality;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const LocalityCard({
    super.key,
    required this.locality,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(locality.name),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(icon),
              tooltip: tooltip,
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
