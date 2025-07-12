import 'package:aiso/Home/widgets/call_to_action.dart';
import 'package:aiso/Home/widgets/home_details.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:flutter/material.dart';

class HomeMobile extends StatelessWidget {
  const HomeMobile({super.key});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          HomeDetails(),
          Center(
            child: CallToAction(
              title: 'Generate free report!',
              onPressed: () {
                appRouter.go(freeReportFormRoute);
                
              },
            ),
          ),
        ],
      ),
    );
  }
}
