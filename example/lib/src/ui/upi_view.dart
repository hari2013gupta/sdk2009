import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sdk2009/sdk2009.dart';
import 'package:sdk2009_example/src/models/upi_meta.dart';
import 'package:sdk2009_example/src/utils/app_utils.dart';

class UpiView extends StatelessWidget {
  const UpiView({super.key});

  @override
  Widget build(BuildContext context) {
    final sdk2009plugin = Sdk2009();
    List<UpiObject> upiAppsListAndroid = [];
    // Platform messages are asynchronous, so we initialize in an async method.
    Future<UpiMeta> getAvailableUpiApps() async {
      try {
        final result = await sdk2009plugin.getAvailableUpiApps();
        log(result.toString());

        if (result != null) {
          final decode = jsonDecode(result);

          return UpiMeta.fromJson(decode);
        }
      } catch (e) {
        log("GET AVAILABLE UPI APPS EXCEPTION : ${e.toString()}");
      }
      return const UpiMeta(data: []);
    }

    Future<String?> openUpiIntent() async {
      // Upi intent may fail, so we use a try/catch bloc to handle it.
      // We also handle the message potentially returning null.
      String? response;
      try {
        response = await sdk2009plugin.openUpiIntent(url: defaultUpiLink) ?? '';
        log(response.toString());
      } on Exception catch (e) {
        String error = "OPEN UPI APPS EXCEPTION : $e";
        log(error, time: DateTime.now());
      }
      return response;
    }

    Future<String> launchUpiApp() async {
      String? result;
      try {
        result = await sdk2009plugin.launchUpiIntent(
            url: defaultUpiLink, package: amazonPackage);
        log(result.toString());
      } catch (e) {
        String error = "OPEN UPI APPS EXCEPTION : $e";
        log(error, name: 'UPI launch');
      }
      return result ?? '';
    }

    return Scaffold(
        appBar: AppBar(title: const Text('UPI view')),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () =>
                    // sdk2009plugin.getAvailableUpiApps().then((result) {
                    getAvailableUpiApps().then((result) {
                  upiAppsListAndroid = result.data;
                  debugPrint(
                      '------->>>>>>>app-result>>${upiAppsListAndroid.length}');
                }),
                child: const Text('Get installed upi apps'),
              ),
              ElevatedButton(
                onPressed: () => openUpiIntent().then(
                    (result) => debugPrint('------>>>>>>>upi-result>>$result')),
                child: const Text('Open upi intent'),
              ),
              ElevatedButton(
                onPressed: () => launchUpiApp().then(
                    (result) => debugPrint('------>>>>>>>upi-result>>$result')),
                child: const Text('Launch upi app'),
              ),
            ],
          ),
        ));
  }
}
// _sdk2009Plugin.init(context);
// final apps =  await getAvailableUpiApps();
// upiAppsListAndroid = apps.data;
// log('--------appslist----->>>> ${upiAppsListAndroid.length}');
// launchApp(package: package, url: url);
