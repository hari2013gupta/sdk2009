import 'package:flutter/material.dart';
import 'package:sdk2009/src/sdk_view.dart';

class SdkLoader extends StatelessWidget {
  const SdkLoader({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      debugPrint('-----start load');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const SdkView(),
      ));
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
