import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdk2009/sdk2009.dart';
import 'package:sdk2009_example/src/ui/upi_view.dart';
import 'package:sdk2009_example/src/ui/webapp_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _platformInfo = 'Unknown';
  final _sdk2009Plugin = Sdk2009();
  late final TextEditingController smsCTR;

  @override
  void initState() {
    super.initState();
    smsCTR = TextEditingController();
    getPlatformInfo();
    listenVerificationCodeFromNative();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getPlatformInfo() async {
    String platformInfo;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformInfo =
          await _sdk2009Plugin.getPlatformInfo() ?? 'Unknown platform info';
    } on PlatformException {
      platformInfo = 'Failed to get platform info.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformInfo = platformInfo;
    });
  }

  void listenVerificationCodeFromNative() {
    try {
      _sdk2009Plugin.getMethodChannel().setMethodCallHandler((call) async {
        // Get hear method and passed arguments with method
        debugPrint('Listener :: MethodInvoked: ${call.method}');
        switch (call.method) {
          case "android_sms_consent":
            smsCTR.text = call.arguments;
            break;
          default:
            break;
        }
      });
    } on PlatformException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  // void _handleLocationChanges() {
  //   const EventChannel _stream = EventChannel('locationHandlerEvent');
  //
  //   bool? _locationStatusChanged;
  //   _stream.receiveBroadcastStream().listen((onData) {
  //     _locationStatusChanged = onData;
  //     print("LOCATION ACCESS IS NOW ${onData ? 'On' : 'Off'}");
  //     if (onData == false) {
  //       // Request Permission Access
  //     }
  //   });
  // }

  // void _handleAnyEventListener() {
  //   const EventChannel _stream = EventChannel('anyHandlerEvent');
  //
  //   bool? _locationStatusChanged;
  //   _stream.receiveBroadcastStream().listen((onData) {
  //     _locationStatusChanged = onData;
  //     print("LOCATION ACCESS IS NOW ${onData ? 'On' : 'Off'}");
  //     if (onData == false) {
  //       // Request Permission Access
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo app'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(_platformInfo),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const WebappView())),
              child: const Text('WebView App'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UpiView())),
              child: const Text('UPI View'),
            ),
            ElevatedButton(
              onPressed: () async {
                final boomerang = await _sdk2009Plugin.getBoomerang();
                debugPrint(boomerang);
              },
              child: const Text('===Razorpay==='),
            ),
            ElevatedButton(
              onPressed: () async {
                _sdk2009Plugin.showNativeAlert(
                    'text_title', 'text_message', 'yes_no');
              },
              child: const Text('===Stripe==='),
            ),
            ElevatedButton(
              onPressed: () async {
                _sdk2009Plugin.playNativeSound();
              },
              child: const Text('===Pay-U==='),
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text('===Google-Pay==='),
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text('===Phone-Pe==='),
            ),
            const Spacer(),
            const Divider(),
            TextField(controller: smsCTR),
            // StreamBuilder<String>(
            //   stream: _sdk2009Plugin.getStreamTimerEvent(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return Text(
            //         '${snapshot.data}',
            //         style: Theme.of(context).textTheme.displayLarge,
            //       );
            //     } else {
            //       return const CircularProgressIndicator();
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
