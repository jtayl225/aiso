import 'package:aiso/Home/widgets/call_to_action.dart';
import 'package:aiso/Home/widgets/home_details.dart';
import 'package:aiso/reports/view_models/free_report_view_model.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMobile extends StatelessWidget {
  const HomeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final vm = context.watch<FreeReportViewModel>();

    return SingleChildScrollView(
      child: Column(
        children: [
          HomeDetails(),
          Center(
            child: CallToAction(
              title: 'Generate free report!',
              onPressed: () {
                
                vm.reset();
                appRouter.go(freeReportFormRoute);
                
              },
            ),
          ),
        ],
      ),
    );
  }
}
