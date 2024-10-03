import 'package:flutter/material.dart';
import 'package:sdk2009/src/sdk_view.dart';

class SdkApp extends StatelessWidget {
  final String url;

  const SdkApp({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'SDK2009', debugShowMaterialGrid: true, home: SdkView(url: url));
  }
}
