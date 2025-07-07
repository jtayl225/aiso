// import 'package:flutter/widgets.dart';
// import 'package:web/web.dart' as web;
// import 'dart:ui' as ui;
// import 'package:flutter/foundation.dart'; // for kIsWeb

// class YouTubeEmbed extends StatelessWidget {
//   final String videoId;

//   const YouTubeEmbed({super.key, required this.videoId});

//   @override
//   Widget build(BuildContext context) {
//     if (!kIsWeb) return const Text('Only available on Flutter Web');

//     final viewType = 'youtube-iframe-$videoId';

//     // Create the iframe element using package:web
//     final iframe = web.HTMLIFrameElement()
//       ..width = '560'
//       ..height = '315'
//       ..src = 'https://www.youtube.com/embed/$videoId'
//       ..setAttribute('allow', 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share')
//       ..style.border = 'none';

//     // Register the view
//     // ignore: undefined_function
//     ui.platformViewRegistry.registerViewFactory(viewType, (int _) => iframe);

//     return SizedBox(
//       width: 560,
//       height: 315,
//       child: HtmlElementView(viewType: viewType),
//     );
//   }
// }
