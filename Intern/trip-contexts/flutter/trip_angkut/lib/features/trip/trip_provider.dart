import 'package:flutter/material.dart';
import '../../data/repositories/trip_repository.dart';
import '../../data/repositories/tariff_repository.dart';
import '../../data/models/trip_model.dart';
import '../../data/models/vehicle_model.dart';
import '../../core/services/location_service.dart';

class TripProvider extends ChangeNotifier {
  final TripRepository _tripRepository;
  final TariffRepository _tariffRepository;
  final LocationService _locationService;

  TripProvider(
    this._tripRepository,
    this._tariffRepository,
    this._locationService,
  );

  // State
  bool _isLoading = false;
  bool _isCreatingTrip = false;
  bool _isCompletingTrip = false;
  String? _error;
  TripModel? _activeTrip;
  List<TripModel> _trips = [];
  TripStats? _stats;
  int _selectedVehicleIndex = 0;

  // Getters
  bool get isLoading => _isLoading;
  bool get isCreatingTrip => _isCreatingTrip;
  bool get isCompletingTrip => _isCompletingTrip;
  String? get error => _error;
  TripModel? get activeTrip => _activeTrip;
  List<TripModel> get trips => _trips;
  TripStats? get stats => _stats;
  int get selectedVehicleIndex => _selectedVehicleIndex;

  // Initialize
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _activeTrip = _tripRepository.getActiveTrip();
      _trips = await _tripRepository.getAllTrips();
      _stats = _tripRepository.getStats();
    } catch (e) {
      _error = 'Gagal memuat data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create trip baru
  Future<bool> createTrip({
    required String statusMuatan,
    String? keterangan,
    String? fotoKondisiPath,
  }) async {
    _isCreatingTrip = true;
    _error = null;
    notifyListeners();

    try {
      // Dapatkan lokasi GPS
      final position = await _locationService.getCurrentPosition();

      // Dapatkan region ID dari user
      final regionId = _tripRepository._storageService.getUserId();
      if (regionId == null) {
        throw Exception('User tidak terdaftar');
      }

      // Create trip
      final result = await _tripRepository.createTrip(
        statusMuatan: statusMuatan,
        keterangan: keterangan,
        fotoKondisiPath: fotoKondisiPath,
        startLat: position.latitude,
        startLng: position.longitude,
        regionId: regionId,
      );

      if (result.success && result.trip != null) {
        _activeTrip = result.trip;
        _trips.insert(0, result.trip!);
        _stats = _tripRepository.getStats();
        _isCreatingTrip = false;
        notifyListeners();
        return true;
      } else {
        _error = result.error;
        _isCreatingTrip = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Gagal membuat trip: $e';
      _isCreatingTrip = false;
      notifyListeners();
      return false;
    }
  }

  // Add vehicle to active trip
  Future<bool> addVehicle({
    required String noPolisi,
    required String golongan,
    required String jenisKendaraan,
    required String muatan,
    String? fotoSelfiePath,
  }) async {
    if (_activeTrip == null) {
      _error = 'Tidak ada trip aktif';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Dapatkan lokasi GPS
      final position = await _locationService.getCurrentPosition();

      // Hitung tarif
      final tarif = _tariffRepository.calculateTarif(
        golongan: golongan,
        jenisKendaraan: jenisKendaraan,
        denganMuatan: muatan == 'dengan_muatan',
      );

      // Tambah vehicle
      final result = await _tripRepository.addVehicle(
        tripId: _activeTrip!.id,
        noPolisi: noPolisi,
        golongan: golongan,
        jenisKendaraan: jenisKendaraan,
        muatan: muatan,
        fotoSelfiePath: fotoSelfiePath,
        lat: position.latitude,
        lng: position.longitude,
        tarif: tarif,
      );

      if (result.success && result.vehicle != null) {
        // Update active trip
        _activeTrip!.vehicles.add(result.vehicle!);
        _stats = _tripRepository.getStats();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result.error;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Gagal menambahkan kendaraan: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Complete trip
  Future<bool> completeTrip() async {
    if (_activeTrip == null) {
      _error = 'Tidak ada trip aktif';
      notifyListeners();
      return false;
    }

    // Validasi minimal 1 kendaraan
    if (_activeTrip!.vehicles.isEmpty) {
      _error = 'Trip harus memiliki minimal 1 kendaraan';
      notifyListeners();
      return false;
    }

    _isCompletingTrip = true;
    _error = null;
    notifyListeners();

    try {
      // Dapatkan lokasi GPS
      final position = await _locationService.getCurrentPosition();

      // Complete trip
      final result = await _tripRepository.completeTrip(
        tripId: _activeTrip!.id,
        endLat: position.latitude,
        endLng: position.longitude,
      );

      if (result.success && result.trip != null) {
        _activeTrip = null;
        _trips = await _tripRepository.getAllTrips();
        _stats = _tripRepository.getStats();
        _isCompletingTrip = false;
        notifyListeners();
        return true;
      } else {
        _error = result.error;
        _isCompletingTrip = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Gagal menyelesaikan trip: $e';
      _isCompletingTrip = false;
      notifyListeners();
      return false;
    }
  }

  // Select vehicle for detail
  void selectVehicle(int index) {
    _selectedVehicleIndex = index;
    notifyListeners();
  }

  // Get selected vehicle
  VehicleModel? get selectedVehicle {
    if (_activeTrip == null) return null;
    if (_selectedVehicleIndex >= _activeTrip!.vehicles.length) return null;
    return _activeTrip!.vehicles[_selectedVehicleIndex];
  }

  // Refresh stats
  Future<void> refreshStats() async {
    _stats = _tripRepository.getStats();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get today's trips count
  int get todayTripsCount => _stats?.todayTrips ?? 0;

  // Get today's vehicles count
  int get todayVehiclesCount => _stats?.todayVehicles ?? 0;

  // Get total tarif today
  String get todayTarif => _stats?.totalTarifFormatted ?? 'Rp 0';
}