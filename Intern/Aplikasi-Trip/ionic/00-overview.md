# Ionic Implementation Overview

## Struktur Proyek

```
src/
├── app/
│   ├── app.component.ts
│   ├── app.module.ts
│   └── app-routing.module.ts
├── core/
│   ├── constants/
│   ├── services/
│   │   ├── location.service.ts
│   │   ├── camera.service.ts
│   │   ├── storage.service.ts
│   │   └── sync.service.ts
│   └── utils/
├── data/
│   ├── models/
│   │   ├── trip.model.ts
│   │   ├── vehicle.model.ts
│   │   └── tariff.model.ts
│   └── repositories/
├── features/
│   ├── auth/
│   ├── trip/
│   └── vehicle/
└── pages/
```

## Key Features

### 1. Login dengan PIN
```typescript
// 6 digit PIN, hash SHA-256, Firebase Auth
async login(pin: string): Promise<boolean> {
  const pinHash = this.hashPin(pin);
  const result = await this.authRepository.login(pinHash, this.deviceId);
  return result.success;
}
```

### 2. Input Kendaraan
```typescript
// Wajib: plat nomor, foto selfie, GPS
// Otomatis: hitung tarif dari kombinasi golongan/jenis/muatan
async submitVehicle(vehicle: VehicleModel): Promise<void> {
  const position = await this.locationService.getCurrentPosition();
  const tariff = this.tariffService.calculate(vehicle);
  const vehicleWithTariff = {...vehicle, tariff, position};
  await this.offlineStorage.save(vehicleWithTariff);
}
```

### 3. Offline Sync
```typescript
// Simpan ke SQLite/Ionic Storage, sync saat online
@Injectable()
export class SyncService {
  async processQueue(): Promise<void> {
    const pending = await this.storage.getPendingItems();
    for (const item of pending) {
      await this.api.sync(item);
      await this.storage.markAsSynced(item);
    }
  }
}
```

## State Management (Ionic Native + Services)

```typescript
// AuthService - login state
// TripService - active trip, history
// OfflineService - pending sync, queue
```

## Services

| Service | Fungsi |
|---------|--------|
| LocationService | GPS coordinates, geofencing |
| CameraService | Photo capture, compression |
| StorageService | Ionic Storage / SQLite |
| SyncService | Background sync dengan @ionic-native/background-mode |
| NetworkService | Connectivity detection |

## Ionic Native Plugins

| Plugin | Fungsi |
|--------|--------|
| @ionic-native/geolocation | GPS coordinates |
| @ionic-native/camera | Photo capture |
| @ionic-native/sqlite | Local database |
| @ionic-native/network | Connectivity detection |
| @ionic-native/background-mode | Background sync |
| @ionic-native/firebase-authentication | Auth |
