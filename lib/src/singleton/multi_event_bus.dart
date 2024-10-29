// multi_event_bus.dart
/**
 *  // Example-
    // Declare: Register a single listener for multiple types
    MultiEventBus().registerMultiTypeListener(
    [String, ResponseSuccessResponse, ResponseFailureResponse], (event) {
    log('event received ----------:');
    if (event is ResponseSuccessResponse) {
    log('-----MultiEventBus----event received :: ${event.paymentId}');
    _callback?.onSuccess(event);
    _callbackFunction?.onSuccessCallback(event);
    } else if (event is ResponseFailureResponse) {
    log('------MultiEventBus-----event received :: ${event.message}');
    _callback?.onFailed(event);
    _callbackFunction?.onFailedCallback(event);
    } else if (event is String) {
    log('------String-----event received :: $event');
    } else {
    log('event received :: Unknown event: $event');
    }
    });
    // Uses:
    dynamic successEvent = ResponseSuccessResponse(
    'paymentIdu111', 'orderId3333', 'signature2222');
    MultiEventBus().emit<ResponseSuccessResponse>(successEvent);
 * */

library;

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

  // Register a single listener for multiple types
  // void registerMultiTypeListener(List<Type> types, MultiTypeCallback callback) {
  //   for (var type in types) {
  //     // Listen to each specified type's stream and pass events to callback
  //     _getController<dynamic>().stream.listen((event) {
  //       if (types.contains(event.runtimeType)) {
  //         callback(event);
  //       }
  //     });
  //   }
  // }

  // Dispose all controllers when done
  void dispose() {
    for (var controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
}
