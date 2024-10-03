import 'dart:developer';

import 'package:events_emitter/events_emitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdk2009/plugin/sdk2009_lib.dart';
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

  void initiateWebViewController() {
    String finalUrl = widget.url;

    wController.addJavaScriptChannel(
      'Payment',
      onMessageReceived: (JavaScriptMessage message) {
        //This is where you receive message from
        //javascript code and handle in Flutter/Dart
        //like here, the message is just being printed
        //in Run/LogCat window of android studio
        //handle close button, success and failed response accordingly
        debugPrint('---------addJavaScriptChannel------>${message.message}');
        switch (message.message) {
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
        const script = "var appToken =\"$token \"";
        wController.runJavaScript(script);
      },
    );
    wController.setOnConsoleMessage((consoleMessage) {
      debugPrint(
          '== JS Console == ${consoleMessage.level.name}: ${consoleMessage.message}');
    });
    wController
    // ..loadFile(absoluteFilePath)
      ..loadRequest(
        Uri.parse(finalUrl),
        // headers: {
        //   "referer": "https://transaction.jsp",
        //   "origin": "https://",
        //   // "referer": "https:transaction.jsp"
        // },
      )
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
            if (request.url.startsWith('https://google.gov.in/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  void getPlatformVersion() async {
    final pVersion = await plugin.getPlatformInfo();
    debugPrint('------>pVer==>$pVersion');
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

          wController
              .runJavaScriptReturningResult(
              'window.function1()')
              .then((onValue) => log('runJsFunctionResponse :: $onValue'))
              .catchError((onError) => log('runJsFunctionError :: $onError'));
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
