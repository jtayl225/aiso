import 'package:aiso/Home/widgets/call_to_action.dart';
import 'package:aiso/Home/widgets/centered_view.dart';
import 'package:aiso/Home/widgets/home_details.dart';
import 'package:aiso/NavBar/views/navgation_bar.dart';
import 'package:aiso/Reports/views/free_report_form_view.dart';
import 'package:aiso/locator.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/services/navigation_service.dart';
import 'package:flutter/material.dart';

class HomeMobile extends StatelessWidget {
  const HomeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
                children: [
                  HomeDetails(),
                  Expanded(
                    child: Center(
                      child: CallToAction(
                        title: 'Generate free report!',
                        onPressed: () {

                          locator<NavigationService>().navigateTo(freeReportFormRoute);
                          
                            // // Your action here
                            // debugPrint("DEBUG: Call to action pressed!");

                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (_) => FreeReportWrapper(),
                            //   ),
                            // );
                          },
                        ),
                    ),
                  )
                ]
              );
  }
}