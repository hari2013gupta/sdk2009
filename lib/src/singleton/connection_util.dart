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

  Future<bool> checkInternetConnection() async {
    var connectionList = await _connectivity.checkConnectivity();
    for (var connection in connectionList) {
      switch (connection) {
        case ConnectivityResult.mobile:
          return true;
        case ConnectivityResult.wifi:
          return true;
        case ConnectivityResult.none:
          log('=======No internet connection');
          return false;
        default:
          break;
      }
    }
      // this is the different
      if (connectionList.isNotEmpty) {
        log('=======Internet is connected with any of connection method');
      }
    return false;
  }

  Future<bool> _hasInternetConnection() async {
    bool previousConnection = hasConnection;
    var connectionList = await _connectivity.checkConnectivity();
    hasConnection = await checkInternetConnection();
    if (hasConnection) {
      // this is the different
      if (connectionList.isNotEmpty) {
        log('=======Internet is connected with any of connection method');
      }
    }
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }
    return hasConnection;
  }
}
