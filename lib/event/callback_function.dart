// In your plugin (plugin.dart)
class CallbackFunction {
  final void Function(String eventMessageSuccess)
      onSuccessCallback; // Function as a parameter
  final void Function(String eventMessageFailed)
      onFailedCallback; // Function as a parameter

  // Constructor accepts a callback function
  CallbackFunction(
      {required this.onSuccessCallback, required this.onFailedCallback});

  // Simulate an event trigger
  void triggerEventSuccess() {
    String eventMessageSuccess = "Plugin event triggered success!";
    onSuccessCallback(eventMessageSuccess); // Call the callback function
  }

  // Simulate an event trigger
  void triggerEventFailed() {
    String eventMessageFailed = "Plugin event triggered failed!";
    onFailedCallback(eventMessageFailed); // Call the callback function
  }
}
