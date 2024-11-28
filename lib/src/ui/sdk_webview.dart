import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SdkWebView extends StatelessWidget {
  const SdkWebView({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return const AndroidView(
        viewType: 'sdk2009/webview',
        creationParams: {'initialUrl': 'https://flutter.dev'},
        creationParamsCodec: StandardMessageCodec(),
      );
    } else {
      return const Center(
        child: Text(
          'WebView is not supported on this platform.',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }
}
