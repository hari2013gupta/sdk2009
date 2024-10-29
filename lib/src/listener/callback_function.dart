// In your plugin (plugin.dart)
import 'package:sdk2009/sdk2009.dart';

// Constants used when working with native ports.
// These must match the constants in runtime/bin/dartutils.h class CObject.
// const int _successResponse = 0;
// const int _illegalArgumentResponse = 1;
// const int _osErrorResponse = 2;
// const int _fileClosedResponse = 3;
//
// const int _errorResponseErrorType = 0;
// const int _osErrorResponseErrorCode = 1;
// const int _osErrorResponseMessage = 2;

class CallbackFunction {
  final void Function(ResponseSuccessResponse successResponse)
      onSuccessCallback; // Function as a parameter
  final void Function(ResponseFailureResponse failedResponse)
      onFailedCallback; // Function as a parameter

  // Constructor accepts a callback function
  CallbackFunction(
      {required this.onSuccessCallback, required this.onFailedCallback});

  // Simulate an event trigger
  // void triggerEventFailed() {
  //   String eventMessageFailed = "Plugin event triggered failed!";
  //   Map<String, dynamic> data = {'err': 'hello error'};
  //   ResponseFailureResponse failedResponse = ResponseFailureResponse(
  //       code: 101, message: eventMessageFailed, error: data);
  //   onFailedCallback(failedResponse); // Call the callback function
  // }
}
