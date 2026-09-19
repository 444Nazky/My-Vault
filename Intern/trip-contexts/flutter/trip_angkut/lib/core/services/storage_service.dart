import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../../data/models/adapters.dart';

class StorageService {
  late Box _box;
  late Box _userBox;
  late Box _tripBox;
  late Box _vehicleBox;
  late Box _tariffBox;
  late Box _regionBox;
  late Box _syncQueueBox;

  // Initialize Hive
  Future<void> init() async {
    await Hive.initFlutter();
    HiveAdapters.registerAdapters();

    _box = await Hive.openBox(AppConstants.boxName);
    _userBox = await Hive.openBox(AppConstants.userBox);
    _tripBox = await Hive.openBox(AppConstants.tripBox);
    _vehicleBox = await Hive.openBox(AppConstants.vehicleBox);
    _tariffBox = await Hive.openBox(AppConstants.tariffBox);
    _regionBox = await Hive.openBox(AppConstants.regionBox);
    _syncQueueBox = await Hive.openBox(AppConstants.syncQueueBox);
  }

  // ==================== User Storage ====================

  // Simpan user
  Future<void> saveUser(dynamic user) async {
    await _userBox.put(user.id, user);
  }

  // Ambil user
  dynamic getUser(String id) {
    return _userBox.get(id);
  }

  // Ambil semua user
  List<dynamic> getAllUsers() {
    return _userBox.values.toList();
  }

  // Hapus user
  Future<void> deleteUser(String id) async {
    await _userBox.delete(id);
  }

  // ==================== Trip Storage ====================

  // Simpan trip
  Future<void> saveTrip(dynamic trip) async {
    await _tripBox.put(trip.id, trip);
  }

  // Ambil trip
  dynamic getTrip(String id) {
    return _tripBox.get(id);
  }

  // Ambil semua trip
  List<dynamic> getAllTrips() {
    return _tripBox.values.toList();
  }

  // Ambil trip belum sync
  List<dynamic> getPendingTrips() {
    return _tripBox.values
        .where((trip) => !trip.isSynced)
        .toList();
  }

  // Update sync status
  Future<void> markTripAsSynced(String id) async {
    final trip = _tripBox.get(id);
    if (trip != null) {
      trip.isSynced = true;
      await _tripBox.put(id, trip);
    }
  }

  // Increment retry count
  Future<void> incrementTripRetryCount(String id) async {
    final trip = _tripBox.get(id);
    if (trip != null) {
      trip.syncRetryCount++;
      await _tripBox.put(id, trip);
    }
  }

  // Hapus trip
  Future<void> deleteTrip(String id) async {
    await _tripBox.delete(id);
  }

  // ==================== Vehicle Storage ====================

  // Simpan vehicle
  Future<void> saveVehicle(dynamic vehicle) async {
    await _vehicleBox.put(vehicle.id, vehicle);
  }

  // Ambil vehicle
  dynamic getVehicle(String id) {
    return _vehicleBox.get(id);
  }

  // Ambil semua vehicle
  List<dynamic> getAllVehicles() {
    return _vehicleBox.values.toList();
  }

  // Ambil vehicle berdasarkan trip
  List<dynamic> getVehiclesByTrip(String tripId) {
    return _vehicleBox.values
        .where((vehicle) => vehicle.tripId == tripId)
        .toList();
  }

  // Update sync status
  Future<void> markVehicleAsSynced(String id) async {
    final vehicle = _vehicleBox.get(id);
    if (vehicle != null) {
      vehicle.isSynced = true;
      await _vehicleBox.put(id, vehicle);
    }
  }

  // Hapus vehicle
  Future<void> deleteVehicle(String id) async {
    await _vehicleBox.delete(id);
  }

  // ==================== Tariff Storage ====================

  // Simpan tarif
  Future<void> saveTariff(dynamic tariff) async {
    await _tariffBox.put(tariff.id, tariff);
  }

  // Simpan semua tarif
  Future<void> saveAllTariffs(List<dynamic> tariffs) async {
    for (var tariff in tariffs) {
      await _tariffBox.put(tariff.id, tariff);
    }
  }

  // Ambil tarif berdasarkan golongan dan jenis
  dynamic getTariff(String golongan, String jenisKendaraan, {String? regionId}) {
    try {
      return _tariffBox.values.firstWhere((t) {
        bool match = t.golongan == golongan && t.jenisKendaraan == jenisKendaraan;
        if (regionId != null) {
          match = match && t.regionId == regionId;
        } else {
          match = match && t.regionId == null;
        }
        return match;
      });
    } catch (e) {
      return null;
    }
  }

  // Ambil semua tarif
  List<dynamic> getAllTariffs() {
    return _tariffBox.values.toList();
  }

  // Hapus tarif
  Future<void> deleteTariff(String id) async {
    await _tariffBox.delete(id);
  }

  // ==================== Region Storage ====================

  // Simpan region
  Future<void> saveRegion(dynamic region) async {
    await _regionBox.put(region.id, region);
  }

  // Simpan semua region
  Future<void> saveAllRegions(List<dynamic> regions) async {
    for (var region in regions) {
      await _regionBox.put(region.id, region);
    }
  }

  // Ambil region
  dynamic getRegion(String id) {
    return _regionBox.get(id);
  }

  // Ambil semua region
  List<dynamic> getAllRegions() {
    return _regionBox.values.toList();
  }

  // Hapus region
  Future<void> deleteRegion(String id) async {
    await _regionBox.delete(id);
  }

  // ==================== Sync Queue ====================

  // Tambah ke sync queue
  Future<void> addToSyncQueue(Map<String, dynamic> item) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _syncQueueBox.put(id, {
      ...item,
      'id': id,
      'createdAt': DateTime.now().toIso8601String(),
      'retryCount': 0,
    });
  }

  // Ambil item sync queue
  List<Map<String, dynamic>> getSyncQueue() {
    return _syncQueueBox.values
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  // Hapus dari sync queue
  Future<void> removeFromSyncQueue(String id) async {
    await _syncQueueBox.delete(id);
  }

  // ==================== Auth Storage ====================

  // Simpan token
  Future<void> saveToken(String token) async {
    await _box.put(AppConstants.tokenKey, token);
  }

  // Ambil token
  String? getToken() {
    return _box.get(AppConstants.tokenKey) as String?;
  }

  // Hapus token
  Future<void> clearToken() async {
    await _box.delete(AppConstants.tokenKey);
  }

  // Simpan user ID
  Future<void> saveUserId(String userId) async {
    await _box.put(AppConstants.userIdKey, userId);
  }

  // Ambil user ID
  String? getUserId() {
    return _box.get(AppConstants.userIdKey) as String?;
  }

  // Simpan device ID
  Future<void> saveDeviceId(String deviceId) async {
    await _box.put(AppConstants.deviceIdKey, deviceId);
  }

  // Ambil device ID
  String? getDeviceId() {
    return _box.get(AppConstants.deviceIdKey) as String?;
  }

  // Cek login status
  bool isLoggedIn() {
    return _box.get(AppConstants.isLoggedInKey, defaultValue: false) as bool;
  }

  // Set login status
  Future<void> setLoggedIn(bool value) async {
    await _box.put(AppConstants.isLoggedInKey, value);
  }

  // Logout - clear all auth data
  Future<void> logout() async {
    await clearToken();
    await _box.delete(AppConstants.userIdKey);
    await _box.put(AppConstants.isLoggedInKey, false);
  }

  // ==================== Utility ====================

  // Clear all data
  Future<void> clearAll() async {
    await _box.clear();
    await _userBox.clear();
    await _tripBox.clear();
    await _vehicleBox.clear();
    await _tariffBox.clear();
    await _regionBox.clear();
    await _syncQueueBox.clear();
  }

  // Get storage stats
  Map<String, int> getStorageStats() {
    return {
      'users': _userBox.length,
      'trips': _tripBox.length,
      'vehicles': _vehicleBox.length,
      'tariffs': _tariffBox.length,
      'regions': _regionBox.length,
      'syncQueue': _syncQueueBox.length,
    };
  }
}