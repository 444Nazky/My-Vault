# Offline Sync Strategy - Ionic

> **Status — 25 September 2026:** konsep di bawah (antrian sync → kirim saat online) **masih berlaku** dan sudah diimplementasikan di `src/services/sync.ts` dengan **localStorage** (bukan Ionic Storage/SQLite) dan **tanpa Background Mode Plugin**. Foto disimpan lokal (data-URL), bukan Firebase Storage. Retry memakai antrian lokal saat aplikasi dibuka/sinkron manual.

## Problem Statement

Area perkebunan sering memiliki sinyal internet yang buruk atau tidak ada sama sekali. Aplikasi Ionic harus tetap bisa digunakan secara offline dan melakukan sync ketika koneksi tersedia.

## Architecture

```
[Ionic App]
     |
     v
[Ionic Storage / SQLite]
     |
     v (when online)
[Sync Queue]
     |
     v
[Background Mode Plugin]
     |
     v
[Server API]
```

## Data Flow

### Offline Mode
1. User membuat trip / input kendaraan
2. Data disimpan ke SQLite/Ionic Storage
3. Data ditandai sebagai `isSynced: false`
4. UI tetap berjalan normal dengan indicator "Offline"

### Sync Trigger
1. Periodic: setiap 15 menit jika online
2. On-demand: User tekan tombol sync manual
3. On-connectivity: Network listener mendeteksi koneksi tersedia

## Implementation

### Ionic Storage Service

```typescript
import { Storage } from '@ionic/storage-angular';

@Injectable({ providedIn: 'root' })
export class StorageService {
  private storage: Storage | null = null;

  async init(): Promise<void> {
    this.storage = await Storage.create({
      name: 'tripangkut_db',
      storeName: 'trips'
    });
  }

  async saveTrip(trip: Trip): Promise<void> {
    const trips = await this.storage?.get('pending_trips') || [];
    trips.push({ ...trip, isSynced: false });
    await this.storage?.set('pending_trips', trips);
  }
}
```

### Network Detection

```typescript
import { Network } from '@ionic-native/network/ngx';

constructor(private network: Network) {
  this.network.onConnect().subscribe(() => {
    this.syncPendingData();
  });
}

isOnline(): boolean {
  return this.network.type !== 'none';
}
```

### Sync Service

```typescript
@Injectable({ providedIn: 'root' })
export class SyncService {
  async processQueue(): Promise<void> {
    const pending = await this.storage.getPendingTrips();

    for (const trip of pending) {
      try {
        await this.uploadPhotos(trip.vehicles);
        await this.api.createTrip(trip);
        await this.storage.markAsSynced(trip.id);
      } catch (error) {
        await this.incrementRetryCount(trip.id);
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

After 5 failures:
  - Mark as "Failed - Manual intervention needed"
  - User notified
  - Can retry manually
```

## Conflict Resolution

| Data Type | Strategy | Alasan |
|-----------|----------|---------|
| Trip header | Server wins | Supervisor mungkin akses |
| Vehicle data | Last-write-wins | Tidak ada konflik logis |
| Master data (tariff) | Server wins | Single source of truth |

## UI Indicators

```html
<!-- Offline Banner -->
<div *ngIf="!isOnline" class="offline-banner">
  Mode Offline - Data akan disinkronkan saat online
</div>

<!-- Sync Status Badge -->
<ion-badge *ngIf="pendingCount > 0" color="warning">
  {{ pendingCount }} pending
</ion-badge>
```

## Background Sync (Optional)

```typescript
import { BackgroundMode } from '@ionic-native/background-mode/ngx';

// Enable background mode
this.backgroundMode.enable();

// Listen for background sync
this.backgroundMode.on('activate').subscribe(() => {
  this.syncService.processQueue();
});
```
