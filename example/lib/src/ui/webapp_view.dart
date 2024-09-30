import 'package:flutter/material.dart';
import 'package:sdk2009/plugin/sdk2009_lib.dart';
import 'package:sdk2009_example/src/utils/app_utils.dart';

class WebappView extends StatelessWidget {
  const WebappView({super.key});

  @override
  Widget build(BuildContext context) {
    final plugin = Sdk2009();
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () =>
              plugin.init(context: context, paymentUrl: pmCaresUrl),
          child: const Text('Pay Now'),
        ),
      ),
    );
  }
}
