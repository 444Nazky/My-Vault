# Flutter Implementation Overview

## Struktur Proyek

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   ├── services/
│   │   ├── location_service.dart
│   │   ├── camera_service.dart
│   │   ├── storage_service.dart
│   │   └── sync_service.dart
│   └── utils/
├── data/
│   ├── models/
│   │   ├── trip_model.dart
│   │   ├── vehicle_model.dart
│   │   └── tariff_model.dart
│   └── repositories/
├── features/
│   ├── auth/
│   ├── trip/
│   └── vehicle/
└── widgets/
```

## Key Features

### 1. Login dengan PIN
```dart
// 6 digit PIN, hash SHA-256, Firebase Auth
Future<bool> login(String pin) async {
  final pinHash = hashPin(pin);
  final result = await authRepository.login(pinHash, deviceId);
  return result.success;
}
```

### 2. Input Kendaraan
```dart
// Wajib: plat nomor, foto selfie, GPS
// Otomatis: hitung tarif dari kombinasi golongan/jenis/muatan
Future<void> submitVehicle(VehicleModel vehicle) async {
  final position = await locationService.getCurrentPosition();
  final tariff = tariffService.calculate(vehicle);
  final vehicleWithTariff = {...vehicle, tariff, position};
  await offlineStorage.save(vehicleWithTariff);
}
```

### 3. Offline Sync
```dart
// Simpan ke Hive, sync saat online
class SyncService {
  Future<void> processQueue() async {
    final pending = await storage.getPendingItems();
    for (var item in pending) {
      await api.sync(item);
      await storage.markAsSynced(item);
    }
  }
}
```

## State Management (Provider)

```dart
// AuthProvider - login state
// TripProvider - active trip, history
// OfflineProvider - pending sync, queue
```

## Services

| Service | Fungsi |
|---------|--------|
| LocationService | GPS coordinates, geofencing |
| CameraService | Photo capture, compression |
| StorageService | Hive local storage |
| SyncService | Background sync, retry |
