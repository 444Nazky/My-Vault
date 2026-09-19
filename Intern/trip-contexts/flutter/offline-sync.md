# Offline Sync Strategy

## Problem Statement

Area perkebunan sering memiliki sinyal internet yang buruk atau tidak ada sama sekali. Aplikasi harus tetap bisa digunakan secara offline dan melakukan sync ketika koneksi tersedia.

## Architecture

```
[Flutter App]
     |
     v
[Local Storage (Hive)]
     |
     v (when online)
[Sync Queue]
     |
     v
[Background Worker (Workmanager)]
     |
     v
[Server API]
```

## Data Flow

### Offline Mode
1. User membuat trip / input kendaraan
2. Data disimpan ke local storage
3. Data ditandai sebagai `isSynced: false`
4. UI tetap berjalan normal

### Sync Trigger
1. Periodic: Workmanager setiap 15 menit jika online
2. On-demand: User tekan tombol sync manual
3. On-connectivity: Listener mendeteksi koneksi tersedia

## Implementation

### Local Storage Schema

```dart
class OfflineTrip {
  String noTrip;
  String statusMuatan;
  String? keterangan;
  double lat;
  double lng;
  List<OfflineVehicle> vehicles;
  bool isSynced;
  int syncRetryCount;
}
```

### Sync Service

```dart
class SyncService {
  Future<void> processQueue() async {
    final pending = await storage.getPendingTrips();

    for (var trip in pending) {
      try {
        await api.createTrip(trip.toJson());
        await storage.markTripAsSynced(trip.id);
      } catch (e) {
        await storage.incrementRetryCount(trip.id);
      }
    }
  }
}
```

## Retry Strategy

```
Attempt 1: Immediate
Attempt 2: After 1 minute
Attempt 3: After 5 minutes
Attempt 4: After 15 minutes
Attempt 5: After 30 minutes
After 5 failures: Mark as failed, manual intervention
```

## Conflict Resolution

| Data Type | Strategy |
|-----------|----------|
| Trip header | Server wins |
| Vehicle data | Last-write-wins |
| Master data (tariff) | Server wins |
