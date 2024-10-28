import 'package:flutter/foundation.dart';

class EventNotifier extends ChangeNotifier {
  String _eventMessage = "Waiting for event...";

  String get eventMessage => _eventMessage;

  void updateEvent(String message) {
    _eventMessage = message;
    notifyListeners();
  }
}