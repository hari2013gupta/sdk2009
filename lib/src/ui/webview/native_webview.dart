import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sdk2009/plugin/sdk2009_lib.dart';
import 'package:sdk2009/src/ui/webview/webview_controller.dart';

class NativeWebView extends StatefulWidget {
  const NativeWebView({super.key, required this.url});

  final String url;

  @override
  State<NativeWebView> createState() => _NativeWebViewState();
}

final sdk2009 = Sdk2009();
class _NativeWebViewState extends State<NativeWebView> {
  WebViewController? _controller;
  final MethodChannel _channel = sdk2009.getMethodChannel();
  void _onPlatformViewCreated(int id) {
    // Initialize the WebView with the initial URL
    _channel.invokeMethod('setUrl', widget.url);
  }

  Future<void> reload() async {
    await _channel.invokeMethod('reload');
  }

  Future<void> goBack() async {
    await _channel.invokeMethod('goBack');
  }

  Future<void> setUrl(String url) async {
    await _channel.invokeMethod('setUrl', url);
  }

  Future<String> evaluateJavascript(String script) async {
    final result = await _channel.invokeMethod('evaluateJavascript', script);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _controller?.loadUrl(widget.url);
    if (defaultTargetPlatform == TargetPlatform.android) {
      // return AndroidView(
      //   viewType: 'sdk2009/webview',
      //   onPlatformViewCreated: _onPlatformViewCreated,
      //   layoutDirection: TextDirection.ltr,
      //   creationParams: const {'initialUrl': 'https://flutter.dev'},
      //   creationParamsCodec: const StandardMessageCodec(),
      // );
      return PlatformViewLink(
        viewType: 'sdk2009/webview',
        onCreatePlatformView: (params) {
          _controller = WebViewController(params.id);
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            creationParams: {'initialUrl': 'https://flutter.dev'},
            viewType: 'sdk2009/webview',
            layoutDirection: TextDirection.ltr,
            creationParamsCodec: const StandardMessageCodec(),
          )..create();
        },
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const {},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
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
