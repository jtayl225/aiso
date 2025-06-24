import 'package:aiso/Home/widgets/home_tablet_desktop.dart';
import 'package:aiso/locator.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/services/navigation_service.dart';
import 'package:flutter/material.dart';

class ReportsDetails extends StatelessWidget {
  final bool isCentered;

  const ReportsDetails({super.key, required this.isCentered});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: Column(
        crossAxisAlignment: isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Reports.',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 45, height: 0.9),
            textAlign: isCentered ? TextAlign.center : TextAlign.start,
          ),
          SizedBox(height: 30,),
          Text(
            'All of your reports can be found here. You can have up to 10 reports.',
            style: TextStyle(fontSize: 21, height: 1.7),
            textAlign: isCentered ? TextAlign.center : TextAlign.start,
          ),

          SizedBox(height: 30,),

          ElevatedButton(
          onPressed: () {

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (_) => const HomeTabletDesktop()),
            // );

            locator<NavigationService>().navigateTo(newReportRoute);

          },
          child: Text('New Report'),
        ),

        SizedBox(height: 30,),

        ],
      ),
    );
  }
}