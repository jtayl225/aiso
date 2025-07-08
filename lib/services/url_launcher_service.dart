import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;

class UrlLauncherService {
  /// Launch a URL in the best way for the platform:
  /// - Web: opens in new tab (even mobile web)
  /// - Native: opens in external browser
  static Future<void> launch(String url) async {
    final uri = Uri.parse(url);

    if (kIsWeb) {
      web.window.open(url, '_blank');
    } else {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('❌ Could not launch $url');
      }
    }
  }

  /// For async-generated URLs on Web (e.g. after an API call),
  /// pre-opens a blank tab to prevent mobile popup blockers.
  static void launchFromAsyncSource(Future<String?> Function() generateUrl) {
    if (kIsWeb) {
      final tab = web.window.open('', '_blank'); // pre-open immediately

      generateUrl().then((url) {
        if (url == null) {
          debugPrint('❌ URL is null');
          tab?.close();
          return;
        }
        tab?.location.href = url;
      }).catchError((e) {
        debugPrint('❌ launchFromAsyncSource error: $e');
        tab?.close();
      });
    } else {
      generateUrl().then((url) async {
        if (url == null) {
          debugPrint('❌ URL is null');
          return;
        }
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint('❌ Could not launch $url');
        }
      }).catchError((e) {
        debugPrint('❌ launchFromAsyncSource error: $e');
      });
    }
  }
}
