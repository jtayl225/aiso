// // import 'package:flutter/material.dart';
// // import 'package:web/web.dart' as web; // New web interop package

// // // ignore: avoid_web_libraries_in_flutter
// // import 'dart:ui' as ui;

// // // void registerWebViewFactory(String viewId, dynamic Function(int) factory) {
// // //   ui.platformViewRegistry.registerViewFactory(viewId, factory);
// // // }

// // class DashboardScreen extends StatelessWidget {
// //   final String url;

// //   const DashboardScreen({super.key, required this.url});

// //   @override
// //   Widget build(BuildContext context) {
// //     final viewID = 'iframe-${url.hashCode}';

// //     // Avoid double registration
// //     if (!_registeredViews.contains(viewID)) {
// //       // ignore: undefined_prefixed_name
// //       ui.platformViewRegistry.registerViewFactory(viewID, (int viewId) {
// //         final iframe = web.HTMLIFrameElement()
// //           ..src = url
// //           ..style.border = ''
// //           ..style.width = '100%'
// //           ..style.height = '100%';

// //         return iframe;
// //       });
// //       _registeredViews.add(viewID);
// //     }

// //     return Scaffold(
// //       backgroundColor: Colors.grey[900],
// //       appBar: AppBar(
// //         title: const Text('Dashboard'),
// //         backgroundColor: Colors.grey[850],
// //       ),
// //       body: HtmlElementView(viewType: viewID),
// //     );
// //   }
// // }

// // final Set<String> _registeredViews = {};

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class DashboardScreen extends StatelessWidget {
//   final String url;

//   const DashboardScreen({super.key, required this.url});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//         backgroundColor: Colors.black,
//       ),
//       body: Center(
//         child: ElevatedButton.icon(
//           icon: const Icon(Icons.open_in_new),
//           label: const Text('Open Dashboard'),
//           onPressed: () async {
//             final uri = Uri.parse(url);
//             if (await canLaunchUrl(uri)) {
//               await launchUrl(
//                 uri,
//                 mode: LaunchMode.externalApplication, // For desktop/mobile
//               );
//             } else {
//               throw 'Could not launch $url';
//             }
//           },
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'iframe_view.dart';

class DashboardScreen extends StatelessWidget {
  final String url;

  const DashboardScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.grey[850],
      ),
      body: Center(
        child: IframeView(
          url: url,
          width: 1200,
          height: 800,
        ),
      ),
    );
  }
}
