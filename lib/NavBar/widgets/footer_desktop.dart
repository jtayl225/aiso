import 'package:aiso/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:aiso/routing/app_router.dart';

class FooterDesktop extends StatelessWidget {
  const FooterDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

          InkWell(
            onTap: () => appRouter.go(termsRoute),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Text('Terms & Conditions'),
            ),
          ),

          const SizedBox(width: 8),

          const Text('|'),

          const SizedBox(width: 8),

          InkWell(
            onTap: () => appRouter.go(privacyRoute),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Text('Privacy Policy'),
            ),
          ),

        ],
      ),
    );
  }
}
