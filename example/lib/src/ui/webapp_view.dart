import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sdk2009/sdk2009.dart';
import 'package:sdk2009_example/src/utils/app_utils.dart';

class WebappView extends StatelessWidget implements PluginCallback {
  const WebappView({super.key});

  @override
  Widget build(BuildContext context) {
    final plugin = Sdk2009();

    CallbackFunction cf = CallbackFunction(
      onSuccessCallback: (ResponseSuccessResponse response) {
        log("fn Received eventSuccessMessage event: ${response.paymentId}");
        // plugin.showNativeAlert('Successful response', 'code: SUCCESS', 'yes_no');
      },
      onFailedCallback: (ResponseFailureResponse response) {
        log("fn Received eventSuccessMessage event: ${response.code},${response.message},${response.error}");
        // plugin.showNativeAlert('Error response${response.code}',
        //     '${response.message}${response.error}', 'yes_no');
      },
    );

    // Register this class as the callback (this is done in plugin side)
    // plugin.setCallback(this);
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                plugin.init(
                  context: context,
                  paymentUrl: sbiCardUrl,
                  callbackFunction: cf,
                  pluginCallback: this,
                  hasPlatformWebView: false,
                );
              },
              child: const Text('Pay Now'),
            ),
            ElevatedButton(
              onPressed: () async {
                plugin.init(
                  context: context,
                  paymentUrl: sbiCardUrl,
                  callbackFunction: cf,
                  pluginCallback: this,
                  hasPlatformWebView: true,
                );
              },
              child: const Text('Platform View'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onFailed(ResponseFailureResponse failedResponse) {
    // TODO: implement onFailed

    log("cb Received eventFailedMessage event: ${failedResponse.message}");
    // You can now handle the event, update UI, etc.
  }

  @override
  void onSuccess(ResponseSuccessResponse successResponse) {
    // TODO: implement onSuccess

    log("cb Received eventSuccessMessage event: ${successResponse.paymentId}");
    // You can now handle the event, update UI, etc.
  }
}
