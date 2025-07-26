import 'package:aiso/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'package:aiso/web_interop/view_registry.dart'; // platformViewRegistry wrapper
import 'dart:js_interop';


final Set<String> _registeredIframes = {};

// class IframeView extends StatelessWidget {
//   final String url;
//   final double width;
//   final double height;

//   const IframeView({
//     super.key,
//     required this.url,
//     this.width = double.infinity,
//     this.height = double.infinity,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final viewId = 'iframe-${url.hashCode}';

//     if (kIsWeb && !_registeredIframes.contains(viewId)) {
//       registerViewFactory(viewId, (int _) {
//         final iframe = web.HTMLIFrameElement()
//           ..src = url
//           ..style.border = 'none'
//           ..style.width = '100%'
//           ..style.height = '100%';
//         return iframe;
//       });
//       _registeredIframes.add(viewId);
//     }

//     return kIsWeb
//         ? SizedBox(
//             width: width,
//             height: height,
//             child: HtmlElementView(viewType: viewId),
//           )
//         : const Center(child: Text('This screen is only available on the web.'));
//   }
// }


class IframeView extends StatelessWidget {
  final String url;
  final double width;
  final double height;

  const IframeView({
    super.key,
    required this.url,
    this.width = 640,     // Default size for YouTube embeds
    this.height = 360,
  });

  @override
  Widget build(BuildContext context) {
    final viewId = 'iframe-${url.hashCode}';

    if (kIsWeb && !_registeredIframes.contains(viewId)) {
      registerViewFactory(viewId, (int _) {
        final doc = web.window.document;

        final wrapper = doc.createElement('div') as web.HTMLDivElement;
        wrapper.style
          ..position = 'relative'
          ..width = '100%'
          // ..paddingTop = '56.25%' // 16:9
          ..overflow = 'hidden';

        final iframe = doc.createElement('iframe') as web.HTMLIFrameElement;
        iframe.src = url;
        iframe.style
          ..position = 'absolute'
          ..top = '0'
          // ..left = '-100%'
          ..width = '100%'        // zoom in
          ..height = '100%'
          ..border = '0';
        iframe.allow = 'autoplay; fullscreen';
        iframe.setAttribute('allowfullscreen', '');
        iframe.setAttribute('frameborder', '0');

        wrapper.appendChild(iframe);
        return wrapper;
      });

      _registeredIframes.add(viewId);
    }

    return kIsWeb
    ? ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width,
          maxHeight: height,
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: HtmlElementView(viewType: viewId)
          ),
      )
    : const Center(child: Text('This screen is only available on the web.'));

  }
}






// String convertYouTubeToEmbedUrl(String url) {
//   final uri = Uri.parse(url);
  
//   // Handle youtu.be short links
//   if (uri.host.contains('youtu.be')) {
//     return 'https://www.youtube.com/embed/${uri.pathSegments.first}';
//   }

//   // Handle watch?v= style
//   if (uri.queryParameters.containsKey('v')) {
//     return 'https://www.youtube.com/embed/${uri.queryParameters['v']}';
//   }

//   return url; // fallback, not ideal

// }

String convertYouTubeToEmbedUrl(String url) {
  final uri = Uri.parse(url);
  String? videoId;

  // Handle youtu.be short links
  if (uri.host.contains('youtu.be')) {
    videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
  }

  // Handle watch?v= style
  if (uri.host.contains('youtube.com') && uri.queryParameters.containsKey('v')) {
    videoId = uri.queryParameters['v'];
  }

  printDebug('Video ID: $videoId');

  if (videoId == null) return url; // fallback if parsing failed

  // return 'https://www.youtube.com/embed/$videoId'
  //      '?rel=0'
  //      '&playsinline=1'
  //      '&modestbranding=1'
  //      '&controls=0'        // Hides player controls
  //      '&showinfo=0'        // Deprecated, still safe
  //      '&autohide=1'
  //      '&enablejsapi=1'
  //      '&fs=0'              // Hides fullscreen button
  //      '&iv_load_policy=3'  // Hides annotations
  //      '&disablekb=1'      // Disables keyboard shortcuts
  //     //  '&playlist=$videoId'
  //      ;
  
  return 'https://www.youtube.com/embed/$videoId'
       '?rel=0'
       '&playsinline=1'
       '&modestbranding=1'
       '&controls=0'
       '&fs=0'
       '&iv_load_policy=3'
       '&disablekb=1';


}

