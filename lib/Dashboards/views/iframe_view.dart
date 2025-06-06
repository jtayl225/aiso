import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import 'package:aiso/web_interop/view_registry.dart'; // platformViewRegistry wrapper

final Set<String> _registeredIframes = {};

class IframeView extends StatelessWidget {
  final String url;
  final double width;
  final double height;

  const IframeView({
    super.key,
    required this.url,
    this.width = double.infinity,
    this.height = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final viewId = 'iframe-${url.hashCode}';

    if (kIsWeb && !_registeredIframes.contains(viewId)) {
      registerViewFactory(viewId, (int _) {
        final iframe = web.HTMLIFrameElement()
          ..src = url
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
        return iframe;
      });
      _registeredIframes.add(viewId);
    }

    return kIsWeb
        ? SizedBox(
            width: width,
            height: height,
            child: HtmlElementView(viewType: viewId),
          )
        : const Center(child: Text('This screen is only available on the web.'));
  }
}
