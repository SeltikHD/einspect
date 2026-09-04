import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

final class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final status = await _connectivity.checkConnectivity();
    return _hasConnection(status);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_hasConnection);
  }

  /// Evaluates connection status supporting both legacy and list-based connectivity returns
  bool _hasConnection(dynamic status) {
    if (status is List<ConnectivityResult>) {
      return status.any((result) => result != ConnectivityResult.none);
    }
    return status != ConnectivityResult.none;
  }
}
