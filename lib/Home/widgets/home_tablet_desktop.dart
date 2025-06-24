import 'package:aiso/Home/widgets/call_to_action.dart';
import 'package:aiso/Home/widgets/centered_view.dart';
import 'package:aiso/Home/widgets/home_details.dart';
import 'package:aiso/NavBar/views/navgation_bar.dart';
import 'package:aiso/reports/view_models/free_report_view_model.dart';
import 'package:aiso/reports/views/free_report_form_view.dart';
import 'package:aiso/locator.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/services/navigation_service.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTabletDesktop extends StatelessWidget {
  const HomeTabletDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FreeReportViewModel>();
    return Row(children: [
                HomeDetails(),
                Expanded(
                  child: Center(
                    child: CallToAction(
                      title: 'Generate free report!',
                      onPressed: () {

                        vm.reset();
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
              ]);
  }
}