import 'dart:developer';
import 'dart:io';

import 'package:events_emitter/events_emitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdk2009/plugin/sdk2009_lib.dart';
import 'package:sdk2009/src/utils/app_assets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SdkView extends StatefulWidget {
  final String url;

  const SdkView({super.key, required this.url});

  @override
  State<SdkView> createState() => _SdkViewState();
}

class _SdkViewState extends State<SdkView> {
  late final WebViewController wController;
  final events = EventEmitter();
  final plugin = Sdk2009();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    wController = WebViewController();
    events.on('message', (String data) => print('String: $data'));
    events.on('message', (int data) => print('Integer: $data'));
    getPlatformVersion();

    initiateWebViewController();
  }

  void initiateWebViewController() async {
    // String finalUrl = widget.url;
    // debugPrint('===============>indexHtml<===========');
    // final indexHtml = await loadIndexHtml();
    // debugPrint(indexHtml);

    wController.addJavaScriptChannel(
      'Print',
      onMessageReceived: (JavaScriptMessage jsMessage) {
        //This is where you receive message from
        //javascript code and handle in Flutter/Dart
        //like here, the message is just being printed
        //in Run/LogCat window of android studio
        //handle close button, success and failed response accordingly
        debugPrint('---------addJavaScriptChannel------>${jsMessage.message}');
        plugin.showNativeToast(jsMessage.message.toString());
        switch (jsMessage.message) {
          case 'cancel':
            break;
          case 'close':
            break;
          case 'success':
            break;
          case 'fail':
            break;
          default:
        }

        const token = 'my_token';
        const script = "var appToken = \"$token \"";
        wController.runJavaScript(script);
      },
    );
    wController.setOnConsoleMessage((consoleMessage) {
      debugPrint(
          '== JS Console == ${consoleMessage.level.name}: ${consoleMessage.message}');
    });
    // File myAssetFile = File("assets/web/index.html");
    const String kLogExamplePage = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HTML string</title>
<script>
        function postSomeMessage(message) {
            window.webkit.messageHandlers.headerInfo.postMessage(message)
        }
        </script>
</head>
<body onload="console.log('Logging that the page is loading.')">

<h1>Local demo page</h1>
<p>
  This page is used to test the forwarding of console logs to Dart.
</p>

<style>
    .btn-group button {
      padding: 24px; 24px;
      display: block;
      width: 25%;
      margin: 5px 0px 0px 0px;
    }
</style>

<div class="btn-group">
    <button onclick="Print.postMessage('Hello JS being called from Javascript code')">Call flutter</button>

    <button onclick="console.error('This is an error message.')">Error</button>
    <p/>
    <button onclick="console.warn('This is a warning message.')">Warning</button>
    <button onclick="console.info('This is a info message.')">Info</button>
    <button onclick="console.debug('This is a debug message.')">Debug</button>
    <button onclick="console.log('This is a log message.')">Log</button>
</div>

<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
<!-- ---------------------- -->
    <script type="text/javascript">

        const functionAlert = (message) => alert(message);
        window.fAlert = functionAlert;
        
        const mLogs = (msg) => console.info(msg);
        window.fLog = mLogs;
        
//-------experimental-----------
        // fromFlutter(newTitle) {
        //     document.getElementById("title").innerHTML = newTitle;
        //     sendBack();
        // }
        // window.function = fff;
        function postSomeMessage(message) {
            window.webkit.messageHandlers.headerInfo.postMessage(message)
        }
        function sendBack() {
            window.webkit.messageHandler.headerInfo.postMessage("Hello from JS");
        }
    </script>
</body>
</html>
''';
String finalUrl = 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf';
    wController
      // ..loadFile(myAssetFile.path)
      // ..loadFile(indexHtml)
      ..loadHtmlString(kLogExamplePage)
      // ..loadFlutterAsset('assets/web/index.html')
      // ..loadRequest(
      //   Uri.parse(finalUrl),
      //   headers: {
      //     "referer": "https://transaction.jsp",
      //     "origin": "https://",
      //     // "referer": "https:transaction.jsp"
      //   },
      // )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String s) {
            debugPrint('onPageFinished :: $s');
            if (s.endsWith('success.jsp')) {
              pageFinishedCallback(s);
            }
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('HttpResponseError :: ${error.response.toString()}');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebResourceError :: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('NavigationRequest :: ${request.url}');
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('Preventing Navigation :: ${request.url}');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  void getPlatformVersion() async {
    final pVersion = await plugin.getPlatformInfo();
    debugPrint('Platform Info :: $pVersion');
  }

  @override
  void dispose() {
    super.dispose();
    wController.clearCache();
    wController.clearLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    // initiateWebViewController();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          events.emit('message', 'Hello World');
          events.emit('message', 42);

          log('-------::==JS Function Test==::--------');
          wController
          .runJavaScriptReturningResult('window.fLog("---->JS-Log Printing")');
          wController
              // .runJavaScriptReturningResult('window.fromFlutter("fffffff")')
              .runJavaScriptReturningResult('window.fAlert("Loss and found greeting from JS")')
              // .runJavaScriptReturningResult('window.postSomeMessage("fffffff")')
              .then((onValue) => log('runJsFunctionResponse :: $onValue'))
              .catchError((onError) => log('runJsFunctionError :: $onError'));
          log('-------::==JS Function Test End==::--------');
        },
        child: const Icon(Icons.download),
      ),
      body: SafeArea(
        child: Center(
          child:
              // SingleChildScrollView(
              //       Stack(children: [
              WebViewWidget(controller: wController),
          // ]),
          // StreamBuilder<String>(
          //   stream: plugin.getStreamTimerEvent(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return Text('${snapshot.data}',
          //           style: Theme.of(context).textTheme.headlineMedium);
          //     } else {
          //       return const CircularProgressIndicator();
          //     }
          //   },
          // ),
          // ),
        ),
      ),
    );
  }

  Future<void> pageFinishedCallback(s) async {
    isLoading = false;
    Future.delayed(Duration.zero, () => Navigator.of(context).pop(s));
  }

  void listenVerificationCodeFromNative() {
    try {
      plugin.getMethodChannel().setMethodCallHandler((call) async {
        // Get hear method and passed arguments with method
        debugPrint('Listener :: MethodInvoked: ${call.method}');
        switch (call.method) {
          case "android_sms_consent":
            // smsCTR.text = call.arguments;
            break;
          default:
            break;
        }
      });
    } on PlatformException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  void showToast({required String msg}) {
    plugin.showNativeToast(msg);
  }
}
