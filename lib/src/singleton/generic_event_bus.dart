// global_event_bus.dart
import 'dart:async';

typedef EventCallback<T> = void Function(T event);

class GenericEventBus {
  // Singleton instance
  static final GenericEventBus _instance = GenericEventBus._internal();

  // Private constructor for singleton
  GenericEventBus._internal();

  factory GenericEventBus() => _instance;

  // access Generic event bus instance
  static getInstance() => _instance;

  // Map to hold StreamControllers for each type
  final Map<Type, StreamController> _controllers = {};

  // Get or create a StreamController of the specified type
  StreamController<T> _getController<T>() {
    if (_controllers[T] == null) {
      _controllers[T] = StreamController<T>.broadcast();
    }
    return _controllers[T] as StreamController<T>;
  }

  // Emit an event of type T
  void emit<T>(T event) {
    _getController<T>().sink.add(event);
  }

  // Register a listener of type T
  void registerListener<T>(EventCallback<T> callback) {
    _getController<T>().stream.listen(callback);
  }

  // Dispose all controllers when done
  void dispose() {
    for (var controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
}
