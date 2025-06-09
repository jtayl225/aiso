import 'package:aiso/Home/widgets/call_to_action.dart';
import 'package:aiso/Home/widgets/centered_view.dart';
import 'package:aiso/Home/widgets/home_details.dart';
import 'package:aiso/NavBar/views/navgation_bar.dart';
import 'package:flutter/material.dart';

class HomeTabletDesktop extends StatelessWidget {
  const HomeTabletDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          children: <Widget>[
            MyNavigationBar(),
            Expanded(
              child: Row(children: [
                HomeDetails(),
                Expanded(
                  child: Center(
                    child: CallToAction(
                      title: 'Generate free report!',
                      onPressed: () {
                            // Your action here
                            debugPrint("DEBUG: Call to action pressed!");
                          },
                      ),
                  ),
                )
              ]),
            )
          ]
          ),
      ),
    );
  }
}