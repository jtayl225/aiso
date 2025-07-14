import 'package:aiso/Home/widgets/centered_view.dart';
import 'package:aiso/NavBar/views/nav_bar.dart';
import 'package:aiso/NavBar/views/nav_footer.dart';
import 'package:aiso/NavBar/widgets/nav_draw.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LayoutTemplate extends StatelessWidget {

  final Widget child;

  const LayoutTemplate({required this.child, super.key});

  @override
  Widget build(BuildContext context) {

    final double _maxWidth = 1100.0;

    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        drawer: sizingInformation.isDesktop ? null : MyNavigationDrawer(),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[

            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: _maxWidth,),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
                child: MyNavigationBar(),
              )
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: _maxWidth,),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
                      child: child,
                    ),
                    ),
                ),
              ),
              ),

            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: _maxWidth,),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
                child: FooterView(),
              )
              ),

          ],
        ),
      ),
    );
  }
}