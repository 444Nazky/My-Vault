import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:workmanager/workmanager.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import 'storage_service.dart';
import 'connectivity_service.dart';

class SyncService {
  final StorageService _storageService;
  final ConnectivityService _connectivityService;
  final Dio _dio;
  final StreamController<SyncStatus> _statusController = StreamController<SyncStatus>.broadcast();

  Stream<SyncStatus> get syncStatus => _statusController.stream;
  bool _isSyncing = false;

  bool get isSyncing => _isSyncing;

  SyncService(this._storageService, this._connectivityService)
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        )) {
    // Listen untuk perubahan koneksi
    _connectivityService.connectionStatus.listen((isConnected) {
      if (isConnected && !_isSyncing) {
        // Auto sync saat koneksi tersedia
        processSyncQueue();
      }
    });
  }

  // Initialize Workmanager untuk background sync
  Future<void> initBackgroundSync() async {
    await Workmanager().initialize(
      _callbackDispatcher,
      isInDebugMode: false,
    );

    // Periodic sync setiap 15 menit
    await Workmanager().registerPeriodicTask(
      'sync-trip-angkut',
      'syncTask',
      frequency: const Duration(minutes: AppConstants.syncIntervalMinutes),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }

  // Process sync queue
  Future<void> processSyncQueue() async {
    if (_isSyncing) return;

    final isConnected = await _connectivityService.checkConnection();
    if (!isConnected) {
      _statusController.add(SyncStatus(
        status: SyncStatusCode.offline,
        message: 'Tidak ada koneksi internet',
      ));
      return;
    }

    _isSyncing = true;
    _statusController.add(SyncStatus(
      status: SyncStatusCode.syncing,
      message: 'Menyinkronkan data...',
    ));

    try {
      // Ambil token
      final token = _storageService.getToken();
      if (token == null) {
        _statusController.add(SyncStatus(
          status: SyncStatusCode.error,
          message: 'Tidak ada token autentikasi',
        ));
        return;
      }

      // Set authorization header
      _dio.options.headers[ApiConstants.authorization] =
          '${ApiConstants.bearerPrefix}$token';

      // Sync trips
      await _syncTrips();

      // Sync vehicles
      await _syncVehicles();

      // Process sync queue
      await _processQueue();

      _statusController.add(SyncStatus(
        status: SyncStatusCode.success,
        message: 'Sinkronisasi berhasil',
      ));
    } catch (e) {
      _statusController.add(SyncStatus(
        status: SyncStatusCode.error,
        message: 'Sinkronisasi gagal: $e',
      ));
    } finally {
      _isSyncing = false;
    }
  }

  // Sync trips
  Future<void> _syncTrips() async {
    final pendingTrips = _storageService.getPendingTrips();

    for (var trip in pendingTrips) {
      if (trip.syncRetryCount >= AppConstants.maxRetryCount) {
        // Tandai sebagai gagal
        _statusController.add(SyncStatus(
          status: SyncStatusCode.error,
          message: 'Trip ${trip.noTrip} gagal disinkronkan setelah ${AppConstants.maxRetryCount} percobaan',
        ));
        continue;
      }

      try {
        await _dio.post(
          ApiConstants.trips,
          data: trip.toJson(),
        );

        // Tandai sebagai synced
        await _storageService.markTripAsSynced(trip.id);
      } on DioException catch (e) {
        // Increment retry count
        await _storageService.incrementTripRetryCount(trip.id);

        // Exponential backoff
        final delay = _calculateBackoff(trip.syncRetryCount);
        await Future.delayed(Duration(seconds: delay));

        print('Retry sync trip ${trip.noTrip} after ${delay}s: $e');
      }
    }
  }

  // Sync vehicles
  Future<void> _syncVehicles() async {
    final allVehicles = _storageService.getAllVehicles();

    for (var vehicle in allVehicles) {
      if (vehicle.isSynced) continue;

      if (vehicle.syncRetryCount >= AppConstants.maxRetryCount) {
        continue;
      }

      try {
        await _dio.post(
          ApiConstants.tripVehicles(vehicle.tripId),
          data: vehicle.toJson(),
        );

        await _storageService.markVehicleAsSynced(vehicle.id);
      } on DioException catch (e) {
        // Increment retry count
        await _storageService.markVehicleAsSynced(vehicle.id);

        // Exponential backoff
        final delay = _calculateBackoff(vehicle.syncRetryCount);
        await Future.delayed(Duration(seconds: delay));

        print('Retry sync vehicle ${vehicle.id} after ${delay}s: $e');
      }
    }
  }

  // Process sync queue
  Future<void> _processQueue() async {
    final queue = _storageService.getSyncQueue();

    for (var item in queue) {
      try {
        final endpoint = item['endpoint'] as String?;
        final method = item['method'] as String? ?? 'POST';
        final data = item['data'] as Map<String, dynamic>?;

        if (endpoint != null && data != null) {
          if (method == 'POST') {
            await _dio.post(endpoint, data: data);
          } else if (method == 'PUT') {
            await _dio.put(endpoint, data: data);
          }
        }

        // Hapus dari queue
        await _storageService.removeFromSyncQueue(item['id']);
      } catch (e) {
        print('Error processing sync queue item: $e');
      }
    }
  }

  // Calculate exponential backoff
  int _calculateBackoff(int retryCount) {
    // Attempt 1: 1s, Attempt 2: 2s, Attempt 3: 4s, Attempt 4: 8s, Attempt 5: 16s
    return pow(2, retryCount).toInt();
  }

  // Manual sync
  Future<void> manualSync() async {
    await processSyncQueue();
  }

  // Get sync statistics
  SyncStats getSyncStats() {
    final pendingTrips = _storageService.getPendingTrips();
    final allVehicles = _storageService.getAllVehicles();
    final unsyncedVehicles = allVehicles.where((v) => !v.isSynced).toList();

    return SyncStats(
      pendingTrips: pendingTrips.length,
      pendingVehicles: unsyncedVehicles.length,
      isSyncing: _isSyncing,
    );
  }

  // Dispose
  void dispose() {
    _statusController.close();
  }
}

// Callback dispatcher untuk Workmanager
@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize services
    final storageService = StorageService();
    await storageService.init();

    final connectivityService = ConnectivityService();
    await connectivityService.init();

    final syncService = SyncService(storageService, connectivityService);
    await syncService.processSyncQueue();

    return true;
  });
}

class SyncStatus {
  final SyncStatusCode status;
  final String message;

  SyncStatus({
    required this.status,
    required this.message,
  });
}

enum SyncStatusCode {
  idle,
  syncing,
  success,
  error,
  offline,
}

class SyncStats {
  final int pendingTrips;
  final int pendingVehicles;
  final bool isSyncing;

  SyncStats({
    required this.pendingTrips,
    required this.pendingVehicles,
    required this.isSyncing,
  });

  bool get hasPendingData => pendingTrips > 0 || pendingVehicles > 0;
}