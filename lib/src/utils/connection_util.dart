import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionUtil {
  static final ConnectionUtil _instance = ConnectionUtil._singleton();
  ConnectionUtil._singleton();

  static ConnectionUtil getInstance() => _instance;

  bool hasConnection = false;

  StreamController connectionChangeController = StreamController();
  Stream get connectionChange => connectionChangeController.stream;

  final Connectivity _connectivity = Connectivity();

  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
  }

  void _connectionChange(List<ConnectivityResult> event) {
    _hasInternetConnection();
  }

  Future<bool> _hasInternetConnection() async {
    bool previousConnection = hasConnection;
    var connectiionList = await _connectivity.checkConnectivity();
    for (var connection in connectiionList) {
      switch (connection) {
        case ConnectivityResult.mobile:
          hasConnection = true;
          break;
        case ConnectivityResult.wifi:
          hasConnection = true;
        default:
          hasConnection = false;
      }
    }
    if (hasConnection) {
      // this is the different
      if (connectiionList.isNotEmpty) {
        log('=======Internet is connected with any of connection medium');
      }
    }
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }
    return hasConnection;
  }
}
