import 'package:flutter/services.dart';

class WebViewController {
  final MethodChannel _channel;

  WebViewController(int viewId)
      : _channel = MethodChannel('sdk2009/webview_$viewId');

  Future<void> reload() async => _channel.invokeMethod('reload');

  Future<bool> canGoBack() async =>
      await _channel.invokeMethod('canGoBack') ?? false;

  Future<void> goBack() async => _channel.invokeMethod('goBack');

  Future<void> loadUrl(String url) async =>
      _channel.invokeMethod('loadUrl', {'url': url});

  Future<String> evaluateJavascript(String script) async =>
      await _channel.invokeMethod('evaluateJavascript', {'script': script}) ??
      '';

  Future<void> loadHtmlAsset(String assetPath) async =>
      _channel.invokeMethod('loadHtmlAsset', {'assetPath': assetPath});

  Future<void> loadHtmlString(String htmlString) async =>
      _channel.invokeMethod('loadHtmlString', {'htmlString': htmlString});

  Future<void> clearCache() async => _channel.invokeMethod('clearCache');

  Future<void> clearLocalStorage() async =>
      _channel.invokeMethod('clearLocalStorage');

  Future<String> getUserAgent() async =>
      await _channel.invokeMethod('getUserAgent') ?? '';

  Future<void> setUserAgent(String userAgent) async =>
      _channel.invokeMethod('setUserAgent', {'userAgent': userAgent});

  Future<String> runJavaScript(String script) async =>
      await _channel.invokeMethod('runJavaScript', {'script': script}) ?? '';
}
