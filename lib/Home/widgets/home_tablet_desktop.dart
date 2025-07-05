import 'package:aiso/Home/widgets/call_to_action.dart';
import 'package:aiso/Home/widgets/home_details.dart';
import 'package:aiso/Home/widgets/home_details_2.dart';
import 'package:aiso/Home/widgets/home_details_3.dart';
import 'package:aiso/Home/widgets/home_details_4.dart';
import 'package:aiso/reports/view_models/free_report_view_model.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTabletDesktop extends StatelessWidget {
  const HomeTabletDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final vm = context.watch<FreeReportViewModel>();
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
                      // authVM.anonSignInIfUnauth();
                      vm.reset();
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300.0, maxWidth: 600.0),
                  child: Image.asset('assets/Google_vs_ChatGPT.png'),
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
