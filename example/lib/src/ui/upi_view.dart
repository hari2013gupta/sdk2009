import 'package:flutter/material.dart';
import 'package:sdk2009/sdk2009lib.dart';
import 'package:sdk2009_example/src/utils/app_utils.dart';

class UpiView extends StatelessWidget {
  const UpiView({super.key});

  @override
  Widget build(BuildContext context) {
    final sdk2009plugin = Sdk2009();
    String upiResult = '';
    // Platform messages are asynchronous, so we initialize in an async method.
    Future<String?> openUpiIntent() async {
      // Upi intent may fail, so we use a try/catch bloc to handle it.
      // We also handle the message potentially returning null.
      try {
        upiResult =
            await sdk2009plugin.openUpiIntent(demoUpiLink) ?? 'upi failed';
      } on Exception {
        upiResult = 'Failed to open.';
      }
      return upiResult;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('UPI view')),
        body: Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => openUpiIntent()
                .then((result) => debugPrint('------upi-result---->$result')),
            child: const Text('open upi intent'),
          ),
          ElevatedButton(
            onPressed: () => sdk2009plugin.getAvailableUpiApps()
                .then((result) => debugPrint('------app-result---->$result')),
            child: const Text('get installed upi apps'),
          ),
        ],
      ),
    ));
  }
}
