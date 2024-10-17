import 'package:flutter/material.dart';
import 'package:sdk2009/sdk2009.dart';
import 'package:sdk2009_example/src/utils/app_utils.dart';

class WebappView extends StatelessWidget {
  const WebappView({super.key});

  @override
  Widget build(BuildContext context) {
    final plugin = Sdk2009();

    //Handle Responses

    void handleResponseError(ResponseFailureResponse response) {
      plugin.showNativeAlert('Error response', 'failed', 'yes_no');
    }

    void handleResponseSuccess(ResponseSuccessResponse response) {
      plugin.showNativeAlert('Successful response', 'ID: SUCCESS', 'yes_no');
    }

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            plugin.on(
                context: context,
                errorResponse: handleResponseError,
                successResponse: handleResponseSuccess);
            plugin.init(context: context, paymentUrl: sbiCardUrl);
          },
          child: const Text('Pay Now'),
        ),
      ),
    );
  }
}
