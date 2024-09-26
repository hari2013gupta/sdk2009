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
