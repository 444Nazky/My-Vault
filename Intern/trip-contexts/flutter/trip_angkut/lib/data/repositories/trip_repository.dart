import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../models/trip_model.dart';
import '../models/vehicle_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/utils/trip_number_generator.dart';

class TripRepository {
  final StorageService _storageService;
  final ConnectivityService _connectivityService;
  final Dio _dio;

  TripRepository(this._storageService, this._connectivityService)
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ));

  // Setup authorization header
  void _setupAuth() {
    final token = _storageService.getToken();
    if (token != null) {
      _dio.options.headers[ApiConstants.authorization] =
          '${ApiConstants.bearerPrefix}$token';
    }
  }

  // Create trip baru
  Future<TripResult> createTrip({
    required String statusMuatan,
    String? keterangan,
    String? fotoKondisiPath,
    required double startLat,
    required double startLng,
    required String regionId,
  }) async {
    final userId = _storageService.getUserId();
    if (userId == null) {
      return TripResult(success: false, error: 'User tidak terdaftar');
    }

    // Generate nomor trip
    final trips = _storageService.getAllTrips();
    final todayTrips = trips.where((t) {
      final tripDate = t.createdAt;
      return tripDate.year == DateTime.now().year &&
          tripDate.month == DateTime.now().month &&
          tripDate.day == DateTime.now().day;
    }).length;

    final noTrip = TripNumberGenerator.generate(todayTrips + 1);

    // Create trip model
    final trip = TripModel(
      id: const Uuid().v4(),
      noTrip: noTrip,
      userId: userId,
      regionId: regionId,
      statusMuatan: statusMuatan,
      keterangan: keterangan,
      fotoKondisiPath: fotoKondisiPath,
      startLat: startLat,
      startLng: startLng,
      status: AppConstants.tripStatusActive,
    );

    // Simpan ke local storage
    await _storageService.saveTrip(trip);

    // Coba sync ke server jika online
    final isConnected = await _connectivityService.checkConnection();
    if (isConnected) {
      try {
        _setupAuth();
        await _dio.post(ApiConstants.trips, data: trip.toJson());
        await _storageService.markTripAsSynced(trip.id);
      } catch (e) {
        // Gagal sync, tapi data sudah tersimpan lokal
        print('Failed to sync trip: $e');
      }
    }

    return TripResult(
      success: true,
      trip: trip,
    );
  }

  // Get all trips
  Future<List<TripModel>> getAllTrips() async {
    final trips = _storageService.getAllTrips();
    trips.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return trips.cast<TripModel>();
  }

  // Get trip by ID
  Future<TripModel?> getTrip(String id) async {
    return _storageService.getTrip(id);
  }

  // Get active trip
  TripModel? getActiveTrip() {
    final trips = _storageService.getAllTrips();
    try {
      return trips.firstWhere((t) => t.status == AppConstants.tripStatusActive);
    } catch (e) {
      return null;
    }
  }

  // Add vehicle to trip
  Future<VehicleResult> addVehicle({
    required String tripId,
    required String noPolisi,
    required String golongan,
    required String jenisKendaraan,
    required String muatan,
    String? fotoSelfiePath,
    required double lat,
    required double lng,
    required int tarif,
  }) async {
    final trip = _storageService.getTrip(tripId);
    if (trip == null) {
      return VehicleResult(success: false, error: 'Trip tidak ditemukan');
    }

    // Create vehicle model
    final vehicle = VehicleModel(
      id: const Uuid().v4(),
      tripId: tripId,
      kendaraanKe: trip.vehicles.length + 1,
      noPolisi: noPolisi,
      golongan: golongan,
      jenisKendaraan: jenisKendaraan,
      muatan: muatan,
      fotoSelfiePath: fotoSelfiePath,
      tarif: tarif,
      lat: lat,
      lng: lng,
    );

    // Tambahkan ke trip
    trip.vehicles.add(vehicle);

    // Simpan ke local storage
    await _storageService.saveVehicle(vehicle);
    await _storageService.saveTrip(trip);

    // Coba sync ke server jika online
    final isConnected = await _connectivityService.checkConnection();
    if (isConnected) {
      try {
        _setupAuth();
        await _dio.post(
          ApiConstants.tripVehicles(tripId),
          data: vehicle.toJson(),
        );
        await _storageService.markVehicleAsSynced(vehicle.id);
      } catch (e) {
        print('Failed to sync vehicle: $e');
      }
    }

    return VehicleResult(
      success: true,
      vehicle: vehicle,
    );
  }

  // Complete trip
  Future<TripResult> completeTrip({
    required String tripId,
    required double endLat,
    required double endLng,
  }) async {
    final trip = _storageService.getTrip(tripId);
    if (trip == null) {
      return TripResult(success: false, error: 'Trip tidak ditemukan');
    }

    // Validasi minimal 1 kendaraan
    if (trip.vehicles.isEmpty) {
      return TripResult(
        success: false,
        error: 'Trip harus memiliki minimal 1 kendaraan',
      );
    }

    // Update trip
    final updatedTrip = trip.copyWith(
      endLat: endLat,
      endLng: endLng,
      completedAt: DateTime.now(),
      status: AppConstants.tripStatusCompleted,
    );

    // Simpan ke local storage
    await _storageService.saveTrip(updatedTrip);

    // Coba sync ke server jika online
    final isConnected = await _connectivityService.checkConnection();
    if (isConnected) {
      try {
        _setupAuth();
        await _dio.put(
          ApiConstants.tripComplete(tripId),
          data: updatedTrip.toJson(),
        );
        await _storageService.markTripAsSynced(updatedTrip.id);
      } catch (e) {
        print('Failed to sync complete trip: $e');
      }
    }

    return TripResult(
      success: true,
      trip: updatedTrip,
    );
  }

  // Get trip statistics
  TripStats getStats() {
    final trips = _storageService.getAllTrips();
    final vehicles = _storageService.getAllVehicles();

    final todayTrips = trips.where((t) {
      final tripDate = t.createdAt;
      return tripDate.year == DateTime.now().year &&
          tripDate.month == DateTime.now().month &&
          tripDate.day == DateTime.now().day;
    }).toList();

    final todayVehicles = vehicles.where((v) {
      final trip = _storageService.getTrip(v.tripId);
      if (trip == null) return false;
      final tripDate = trip.createdAt;
      return tripDate.year == DateTime.now().year &&
          tripDate.month == DateTime.now().month &&
          tripDate.day == DateTime.now().day;
    }).toList();

    final totalTarif = todayVehicles.fold(0, (sum, v) => sum + v.tarif);

    return TripStats(
      totalTrips: trips.length,
      todayTrips: todayTrips.length,
      totalVehicles: vehicles.length,
      todayVehicles: todayVehicles.length,
      totalTarif: totalTarif,
    );
  }
}

class TripResult {
  final bool success;
  final TripModel? trip;
  final String? error;

  TripResult({
    required this.success,
    this.trip,
    this.error,
  });
}

class VehicleResult {
  final bool success;
  final VehicleModel? vehicle;
  final String? error;

  VehicleResult({
    required this.success,
    this.vehicle,
    this.error,
  });
}

class TripStats {
  final int totalTrips;
  final int todayTrips;
  final int totalVehicles;
  final int todayVehicles;
  final int totalTarif;

  TripStats({
    required this.totalTrips,
    required this.todayTrips,
    required this.totalVehicles,
    required this.todayVehicles,
    required this.totalTarif,
  });

  String get totalTarifFormatted {
    return 'Rp ${totalTarif.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}