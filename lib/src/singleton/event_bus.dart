// event_bus.dart
/**
 *
    // Declare: Listen to the global event bus
    EventBus.getInstance().stream.listen((message) {
    print(message); // Update UI based on the event
    });
    }
    // Uses: emit event
    EventBus.getInstance().emit("Event triggered!"); // Emit an event
 * */
library;

import 'dart:async';

class EventBus {
  // Singleton pattern for the event bus
  static final EventBus _instance = EventBus._internal();

  // Private constructor
  EventBus._internal();

  factory EventBus() {
    return _instance;
  }

  static getInstance() => _instance;

  // StreamController with a broadcast stream
  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  Stream<String> get stream => _controller.stream;

  void emit(String eventMessage) {
    _controller.sink.add(eventMessage); // Emit an event
  }

  void dispose() {
    _controller.close(); // Clean up the stream controller
  }
}

// Create an instance to use as a global stream bus
// final eventBus = EventBus();
