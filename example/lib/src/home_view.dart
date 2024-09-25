import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdk2009/sdk2009lib.dart';
import 'package:sdk2009_example/src/upi_meta.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _platformVersion = 'Unknown';
  final _sdk2009Plugin = Sdk2009();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _sdk2009Plugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
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

  final MethodChannel _methodChannel = const MethodChannel('sdk2009');

  Future<UpiMeta> getAvailableUpiApps() async {
    try {
      final version =
          await _methodChannel.invokeMethod<String>('get_available_upi');
      log(version.toString());

      if (version != null) {
        final decode = jsonDecode(version);

        return UpiMeta.fromJson(decode);
      }
    } catch (e) {
      log("GET AVAILABLE UPI APPS EXCEPTION : ${e.toString()}");
    }
    return const UpiMeta(data: []);
  }

  Future<String?> openNativeIntent({required String url}) async {
    String? result;
    try {
      result = await _methodChannel
          .invokeMethod<String>('native_intent', {'url': url});
      log('----------->>>>>>$result');
    } catch (e) {
      log("OPEN UPI APPS EXCEPTION : ${e.toString()}");
    }
    return result ?? '';
  }

  Future<String> launchApp(
      {required String package, required String url}) async {
    String? result;
    try {
      result = await _methodChannel.invokeMethod<String>(
        'open_upi_app',
        {'package': package, 'url': url},
      );
      log(result.toString());
    } catch (e) {
      log("OPEN UPI APPS EXCEPTION : ${e.toString()}");
    }
    return result ?? '';
  }

  List<UpiObject> upiAppsListAndroid = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo app'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Running on: $_platformVersion\n'),
            ElevatedButton(
              onPressed: () async {
                // _sdk2009Plugin.init(context);
                // final apps =  await getAvailableUpiApps();
                // upiAppsListAndroid = apps.data;
                // log('--------appslist----->>>> ${upiAppsListAndroid.length}');
                openNativeIntent(
                    url: 'upi://pay?pa=112233220@ibl&pn=Harry&cu=INR');
                // launchApp(package: package, url: url);
              },
              child: const Text('Button click'),
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text('WebView App'),
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text('UPI App'),
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text('===Razorpay==='),
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text('===Stripe==='),
            ),
            ElevatedButton(
              onPressed: () async {},
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
            StreamBuilder<String>(
              stream: _sdk2009Plugin.getStreamTimerEvent(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    '${snapshot.data}',
                    style: Theme.of(context).textTheme.displayLarge,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
