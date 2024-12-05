import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sdk2009/sdk2009.dart';
import 'package:sdk2009/src/singleton/generic_event_bus.dart';
import 'package:sdk2009/src/users.g.dart';
import 'package:sdk2009/src/utils/app_assets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SdkView extends StatefulWidget {
  final String url;

  const SdkView({super.key, required this.url});

  @override
  State<SdkView> createState() => _SdkViewState();
}

class _SdkViewState extends State<SdkView> {
  late final WebViewController wController;
  final plugin = Sdk2009();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    wController = WebViewController();
    getPlatformVersion();

    initiateWebViewController();
    listenVerificationCodeFromNative();
  }

  void initiateWebViewController() async {
    // String finalUrl = widget.url;
    // debugPrint('===============>indexHtml<===========');
    // final indexHtml = await loadIndexHtml();
    // debugPrint(indexHtml);

    final dotenvValue = dotenv.env["API_KEY"];
    log('dotenvValue----->$dotenvValue');

    wController.addJavaScriptChannel(
      'Flutter',
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
          case 'js_close':
            pageFinishedCallback('success_response');
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
    <button onclick="Flutter.postMessage('js_close')">Call flutter</button>

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
    String finalUrl = 'https://flutter.dev';
    wController
      // ..loadFile(myAssetFile.path)
      // ..loadFile(indexHtml)
      // ..loadHtmlString(kLogExamplePage)
      // ..loadFlutterAsset('assets/web/index.html')
      ..loadRequest(
        Uri.parse(finalUrl),
        headers: {
          "referer": "https://transaction.jsp",
          "origin": "https://",
          // "referer": "https:transaction.jsp"
        },
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
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('Preventing Navigation :: ${request.url}');
              return NavigationDecision.prevent;
            }
            if (request.url.contains('upi://') ||
                request.url.contains('upi:/')) {
              launchUrl(Uri.parse(request.url));
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
    plugin.nativeUnregisterReceiver();

    wController.clearCache();
    wController.clearLocalStorage();
  }

  final UserHostApi userApi = UserHostApi();
  final MessageHostApi messageApi = MessageHostApi();

  userOperation() async {
    User user = User(name: 'name777', mobileNo: 9999999);
    final b = await userApi.saveUser(user);
    log('----b----->$b');
    Message m = Message(content: 'content2222');
    await messageApi.sendMessage(m);
    log('----okk----->');

    User k = await userApi.getUser();
    log('----k----->$k');
    List<User> kk = await userApi.getAllUser();
    for (User u in kk) {
      log('----list----->$u');
    }
  }

  @override
  Widget build(BuildContext context) {
    userOperation();
    // initiateWebViewController();
    // Future.delayed(Duration.zero, () async {
    //   final htmlValue = await loadIndexHtml();
    //   log('htmlValue===============>$htmlValue');
    // });
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          log('-------::==JS Function Test==::--------');
          wController.runJavaScriptReturningResult(
              'window.fLog("---->JS-Log Printing")');
          wController
              // .runJavaScriptReturningResult('window.fromFlutter("ok")')
              .runJavaScriptReturningResult(
                  'window.fAlert("Loss and found greeting from JS")')
              // .runJavaScriptReturningResult('window.postSomeMessage("ok1")')
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
    dynamic p2 = ResponseSuccessResponse(
        'paymentIdu111', 'orderId3333', 'signature2222');
    GenericEventBus.getInstance().emit<ResponseSuccessResponse>(p2);

    if (context.mounted) {
      Navigator.pop(context, s);
      // Future.delayed(Duration.zero, () => Navigator.pop(context, s));
    }
  }

  void listenVerificationCodeFromNative() {
    try {
      plugin.nativeRegisterReceiver();
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
