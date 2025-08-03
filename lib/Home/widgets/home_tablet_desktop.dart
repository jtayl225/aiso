import 'package:aiso/Home/widgets/call_to_action.dart';
import 'package:aiso/Home/widgets/home_details.dart';
import 'package:aiso/Home/widgets/home_details_2.dart';
import 'package:aiso/Home/widgets/home_details_3.dart';
import 'package:aiso/Home/widgets/home_details_4.dart';
import 'package:aiso/widgets/figure.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:flutter/material.dart';

class HomeTabletDesktop extends StatelessWidget {
  const HomeTabletDesktop({super.key});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 80),
          Row(
            children: [
              HomeDetails(),
              Expanded(
                child: Center(
                  child: CallToAction(
                    title: 'Generate free report!',
                    onPressed: () {
                      appRouter.go(freeReportFormRoute);
                    },
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 80),

          Row(
            children: [
              HomeDetails4(),
              Expanded(child: SizedBox(width: 100, height: 100)),
            ],
          ),

          SizedBox(height: 80),

          Row(
            children: [
              HomeDetails2(),
              Expanded(child: SizedBox(width: 100, height: 100)),
            ],
          ),

          SizedBox(height: 80),

          Row(
            children: [
              Expanded(
                child: Figure(
                  imagePath: 'assets/Google_vs_ChatGPT.png',
                  caption: 'Figure 1: Interest in Google vs ChatGPT over time.',
                  imageHeight: 600,
                  imageWidth: 600,
                ),
              ),
              HomeDetails3(),
            ],
          ),
        ],
      ),
    );
  }
}
