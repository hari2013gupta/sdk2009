import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sdk2009/event/callback_interface.dart';
import 'package:sdk2009/sdk2009.dart';
import 'package:sdk2009_example/src/utils/app_utils.dart';

class WebappView extends StatelessWidget implements PluginCallback {
  const WebappView({super.key});

  @override
  Widget build(BuildContext context) {
    final plugin = Sdk2009();

    //Handle Responses

    void handleResponseError(ResponseFailureResponse response) {
      plugin.showNativeAlert('Error response${response.code}',
          '${response.message}${response.error}', 'yes_no');
    }

    void handleResponseSuccess(ResponseSuccessResponse response) {
      plugin.showNativeAlert('Successful response', 'code: SUCCESS', 'yes_no');
    }

    // Register this class as the callback (this is done in plugin side)
    // plugin.setCallback(this);
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            plugin.on(
                pluginCallback: this,
                errorResponse: handleResponseError,
                successResponse: handleResponseSuccess);
            plugin.init(context: context, paymentUrl: sbiCardUrl);
          },
          child: const Text('Pay Now'),
        ),
      ),
    );
  }

  @override
  void onFailed(String eventFailedMessage) {
    // TODO: implement onFailed

    log("Received eventFailedMessage event: $eventFailedMessage");
    // You can now handle the event, update UI, etc.
  }

  @override
  void onSuccess(String eventSuccessMessage) {
    // TODO: implement onSuccess

    log("Received eventSuccessMessage event: $eventSuccessMessage");
    // You can now handle the event, update UI, etc.
  }
}
