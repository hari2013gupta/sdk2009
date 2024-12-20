import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sdk2009/plugin/sdk2009_lib.dart';
import 'package:sdk2009/sdk2009.dart';
import 'package:sdk2009_example/src/models/upi_meta.dart';
import 'package:sdk2009_example/src/utils/app_utils.dart';

class UpiView extends StatefulWidget {
  const UpiView({super.key});

  @override
  State<UpiView> createState() => _UpiViewState();
}

class _UpiViewState extends State<UpiView> {
  List<UpiObject> upiAppsListAndroid = [];

  @override
  Widget build(BuildContext context) {
    final sdk2009plugin = Sdk2009();

    // List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
    // final Connectivity _connectivity = Connectivity();
    // late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

    // Platform messages are asynchronous, so we initialize in an async method.
    Future<UpiMeta> getAvailableUpiApps() async {
      try {
        final result = await sdk2009plugin.getAvailableUpiApps();

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
        response = await sdk2009plugin.openUpiIntent(url: upiLink2) ?? '';
        log(response.toString());
      } on Exception catch (e) {
        String error = "OPEN UPI APPS EXCEPTION : $e";
        log(error, time: DateTime.now());
      }
      // Sdk2009Internal().showNativeToast('msg');
      return response;
    }

    Future<String> launchUpiApp() async {
      String? result;
      try {
        result = await sdk2009plugin.launchUpiIntent(
            url: upiLink2, package: googlePackage);
        log(result.toString());
      } catch (e) {
        String error = "OPEN UPI APPS EXCEPTION : $e";
        log(error, name: 'UPI launch');
      }
      return result ?? '';
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(title: const Text('UPI view')),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      // sdk2009plugin.getAvailableUpiApps().then((result) {
                      getAvailableUpiApps().then((result) {
                    log('Length-----> ${result.data.length}');
                    setState(() {
                      upiAppsListAndroid = result.data;
                    });
                    for (UpiObject m in upiAppsListAndroid) {
                      log('-----> ${m.name}');
                    }
                  }).catchError((e) {
                    log('upi_err-----${e.toString()}');
                  }),
                  child: const Text('Get installed upi apps'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => openUpiIntent().then((result) =>
                      debugPrint('------>>>>>>>upi-result>>$result')),
                  child: const Text('Open upi intent'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => launchUpiApp().then((result) =>
                      debugPrint('------>>>>>>>upi-result>>$result')),
                  child: const Text('Launch upi app'),
                ),
              ),
            ],
          ),
          const Divider(),
          ListView(
            shrinkWrap: true,
            children: List.generate(upiAppsListAndroid.length, (index) {
              final item = upiAppsListAndroid[index];
              log('icon--------->  ${item.name}');
              return ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  horizontalTitleGap: 16,
                  leading: Image.memory(base64Decode(item.icon)),
                  title: Text(
                    item.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.white),
                  ));
            }),
          ),

          // ListView(
          //   shrinkWrap: true,
          //   children: List.generate(
          //       _connectionStatus.length,
          //       (index) => Center(
          //             child: Text(
          //               _connectionStatus[index].toString(),
          //               style: Theme.of(context).textTheme.headlineSmall,
          //             ),
          //           )),
          // ),
        ],
      ),
    );
  }
}
// _sdk2009Plugin.init(context);
// final apps =  await getAvailableUpiApps();
// upiAppsListAndroid = apps.data;
// log('--------appslist----->>>> ${upiAppsListAndroid.length}');
// launchApp(package: package, url: url);
