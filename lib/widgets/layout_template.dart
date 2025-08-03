// import 'package:aiso/Home/widgets/centered_view.dart';
import 'package:aiso/NavBar/views/nav_bar.dart';
import 'package:aiso/NavBar/views/nav_footer.dart';
import 'package:aiso/NavBar/widgets/nav_draw.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LayoutTemplate extends StatelessWidget {

  final Widget child;

  const LayoutTemplate({required this.child, super.key});

//   @override
//   Widget build(BuildContext context) {
//

//     final double _maxWidth = 1100.0;

//     return ResponsiveBuilder(
//       builder: (context, sizingInformation) => Scaffold(
//         drawer: sizingInformation.isDesktop ? null : MyNavigationDrawer(),
//         backgroundColor: Colors.white,
//         body: Column(
//           children: <Widget>[

//             ConstrainedBox(
//               constraints: BoxConstraints(maxWidth: _maxWidth,),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
//                 child: MyNavigationBar(),
//               )
//             ),

//             Expanded(
//               child: SingleChildScrollView(
//                 child: Align(
//                   alignment: Alignment.topCenter,
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(maxWidth: _maxWidth,),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
//                       child: child,
//                     ),
//                     ),
//                 ),
//               ),
//               ),

//             ConstrainedBox(
//               constraints: BoxConstraints(maxWidth: _maxWidth,),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                 child: FooterView(),
//               )
//               ),

//           ],
//         ),
//       ),
//     );
//   }
// }

@override
Widget build(BuildContext context) {

  const double maxWidth = 1100.0;
  const double navBarHeight = 150.0; // Estimate or measure
  const double footerHeight = 120.0; // Estimate or measure

  return ResponsiveBuilder(
    builder: (context, sizingInformation) => Scaffold(
      drawer: sizingInformation.isDesktop ? null : MyNavigationDrawer(),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {

          final availableHeight = constraints.maxHeight;
          final bodyHeight = availableHeight - navBarHeight - footerHeight;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
          
                    // Header
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
                        child: MyNavigationBar(),
                      ),
                    ),
                
                    // Body
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth, minHeight: bodyHeight),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
                        child: child,
                      ),
                    ),
                
                    // Spacer pushes footer to bottom if content is short
                    // const Spacer(),
                
                    // Flexible Spacer that takes remaining space only if available
                    // const Expanded(child: SizedBox()),
                
                    // Push footer to bottom if content is short
                    // SizedBox(height: 20), // optional visual spacing
                
                    // Footer
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: FooterView(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}


}
