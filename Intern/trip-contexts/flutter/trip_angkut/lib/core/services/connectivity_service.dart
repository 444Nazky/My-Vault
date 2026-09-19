import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  // Initialize connectivity monitoring
  Future<void> init() async {
    // Cek status awal
    final result = await _connectivity.checkConnectivity();
    _isConnected = result != ConnectivityResult.none;
    _connectionStatusController.add(_isConnected);

    // Listen untuk perubahan koneksi
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      final wasConnected = _isConnected;
      _isConnected = result != ConnectivityResult.none;

      // Notify hanya jika status berubah
      if (wasConnected != _isConnected) {
        _connectionStatusController.add(_isConnected);
      }
    });
  }

  // Cek koneksi saat ini
  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    _isConnected = result != ConnectivityResult.none;
    return _isConnected;
  }

  // Get connection type
  Future<ConnectivityType> getConnectionType() async {
    final result = await _connectivity.checkConnectivity();

    switch (result) {
      case ConnectivityResult.wifi:
        return ConnectivityType.wifi;
      case ConnectivityResult.mobile:
        return ConnectivityType.mobile;
      case ConnectivityResult.ethernet:
        return ConnectivityType.ethernet;
      case ConnectivityResult.bluetooth:
        return ConnectivityType.bluetooth;
      case ConnectivityResult.vpn:
        return ConnectivityType.vpn;
      case ConnectivityResult.other:
        return ConnectivityType.other;
      case ConnectivityResult.none:
      default:
        return ConnectivityType.none;
    }
  }

  // Dispose
  void dispose() {
    _subscription?.cancel();
    _connectionStatusController.close();
  }
}

enum ConnectivityType {
  wifi,
  mobile,
  ethernet,
  bluetooth,
  vpn,
  other,
  none,
}