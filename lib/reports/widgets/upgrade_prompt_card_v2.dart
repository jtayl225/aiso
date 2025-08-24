import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class UpgradePromptCardV2 extends StatelessWidget {
  final DeviceScreenType deviceType;
  final VoidCallback onSubscribe;

  const UpgradePromptCardV2({
    super.key,
    required this.deviceType,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text('JOIN ', style: AppTextStyles.h1(deviceType),),
                  // Image.asset(logoImage)
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 84,
                      minHeight: 84,
                      maxWidth: 168,
                      maxHeight: 168,
                    ),
                    child: Image.asset(
                      logoImage,
                      fit: BoxFit.contain, // keeps aspect ratio within the box
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Text('to', style: AppTextStyles.body(deviceType)),

              // const SizedBox(height: 4),

              Text(
                slogan,
                style: AppTextStyles.h2(deviceType),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text(
                'GEOMAX will help you get ahead of your competition by becoming more visible by AI tools like ChatGPT and Google Gemini.',
                textAlign: TextAlign.center,
              ),

              // Text(
              //   'Upgrade to view',
              //   style: Theme.of(context).textTheme.headlineSmall,
              //   textAlign: TextAlign.center,
              // ),
              const SizedBox(height: 16),

              // const Text(
              //   'Recommendations to become #1',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 16, color: Colors.black54),
              // ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: onSubscribe,
                child: const Text('JOIN NOW'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
