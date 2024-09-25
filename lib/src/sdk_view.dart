import 'package:events_emitter/events_emitter.dart';
import 'package:flutter/material.dart';
import 'package:sdk2009/plugin/sdk2009_lib.dart';

class SdkView extends StatefulWidget {
  const SdkView({super.key});

  @override
  State<SdkView> createState() => _SdkViewState();
}

class _SdkViewState extends State<SdkView> {
  final events = EventEmitter();
  final plugin = Sdk2009();

  @override
  void initState() {
    super.initState();
    events.on('message', (String data) => print('String: $data'));
    events.on('message', (int data) => print('Integer: $data'));
    getPlatformVersion();
  }

  void getPlatformVersion() async {
    final pVersion = await plugin.getPlatformVersion();
    print('------>pver==$pVersion');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            StreamBuilder<String>(
              stream: plugin.getStreamTimerEvent(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('${snapshot.data}',
                      style: Theme.of(context).textTheme.headlineMedium);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                events.emit('message', 'Hello World');
                events.emit('message', 42);
              },
              child: const Text('Click me'),
            ),
          ],
        ),
      ),
    );
  }
}
