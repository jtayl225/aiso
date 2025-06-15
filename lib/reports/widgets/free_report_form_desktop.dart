import 'package:aiso/Home/widgets/centered_view.dart';
import 'package:aiso/NavBar/views/navgation_bar.dart';
import 'package:aiso/Reports/widgets/free_report_form.dart';
import 'package:aiso/Reports/widgets/free_report_form_details.dart';
import 'package:flutter/material.dart';

class FreeReportDesktop extends StatelessWidget {
  const FreeReportDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyNavigationBar(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FreeReportFormDetails(isCentered: false),
                  FreeReportForm()
              ]),
            )
          ]
          ),
      ),
    );
  }
}