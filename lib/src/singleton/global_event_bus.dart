import 'dart:async';

// Define a typedef for a generic event callback
typedef EventCallback<T> = void Function(T event);

class GlobalEventBus<T> {
  // Singleton pattern with instances for each type
  static final Map<Type, GlobalEventBus> _instances = {};

  // Factory constructor to return a singleton instance for the specific type
  factory GlobalEventBus() {
    if (_instances[T] == null) {
      _instances[T] = GlobalEventBus<T>._internal();
    }
    return _instances[T] as GlobalEventBus<T>;
  }

  static getInstances() => _instances;

  // Private constructor for singleton
  GlobalEventBus._internal();

  // StreamController with a broadcast stream
  final StreamController<T> _controller = StreamController<T>.broadcast();

  Stream<T> get stream => _controller.stream;

  void emit(T event) {
    _controller.sink.add(event); // Emit an event of type T
  }

  // Register a listener using the typedef callback
  void registerListener(EventCallback<T> callback) {
    _controller.stream.listen(callback);
  }

// Remember to call dispose on eventController to avoid memory leaks when it’s no longer needed.
  void dispose() {
    _controller.close(); // Clean up the stream controller
  }
}
