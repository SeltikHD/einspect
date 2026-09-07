import 'dart:async';

import 'package:einspect/core/network/network_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class NetworkStatusCubit extends Cubit<bool> {
  final NetworkInfo _networkInfo;
  StreamSubscription<bool>? _subscription;

  NetworkStatusCubit({required this._networkInfo}) : super(true) {
    _subscription = _networkInfo.onConnectivityChanged.listen(emit);
    _loadInitialStatus();
  }

  Future<void> _loadInitialStatus() async {
    emit(await _networkInfo.isConnected);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
