import 'package:aiso/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RecommendationCard extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final DeviceScreenType deviceType;

  const RecommendationCard({
    super.key,
    required this.title,
    this.onPressed,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Image.asset(smallLogoImage, width: 20, height: 20),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: false,
                  ),

                  if (deviceType != DeviceScreenType.desktop)
                    const SizedBox(height: 4),

                  if (deviceType != DeviceScreenType.desktop)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: onPressed,
                          child: Text(
                            'Recommendations',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            if (deviceType == DeviceScreenType.desktop)
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: onPressed,
                    child: Text(
                      'Recommendations',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

}
