// global_event_bus.dart
import 'dart:async';

typedef EventCallback<T> = void Function(T event);
typedef MultiTypeCallback = void Function(dynamic event);

class MultiEventBus {
  // Singleton instance
  static final MultiEventBus _instance = MultiEventBus._internal();

  // Private constructor for singleton
  MultiEventBus._internal();

  factory MultiEventBus() => _instance;

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

  // Register a single listener that listens to multiple types
  void registerMultiTypeListener(List<Type> types, MultiTypeCallback callback) {
    for (var type in types) {
      _getController<dynamic>()
          .stream
          .where((event) => event.runtimeType == type)
          .listen(callback);
    }
  }

  // Dispose all controllers when done
  void dispose() {
    for (var controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
}
