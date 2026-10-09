# Form Trip - Modul Input Kendaraan

## Overview
Modul form trip mengelola input kendaraan untuk trip dengan muatan, termasuk foto bukti dokumentasi per kendaraan dan swafoto wajib untuk mengakhiri trip.

## Screens

### 1. TripConditionScreen
**Path:** `Aplikasi-Trip-Ionic/src/pages/mobile/TripConditionScreen.tsx`

Pemilihan kondisi trip:
- **Kosong** → Reset semua data (kendaraan, foto)
- **Ada Angkutan (Muatan)** → Jika sebelumnya kosong, reset foto untuk mencegah selfie trip lama memenuhi syarat swafoto wajib

### 2. VehicleFormScreen
**Path:** `Aplikasi-Trip-Ionic/src/pages/mobile/VehicleFormScreen.tsx`

Form input kendaraan:
- Foto dokumentasi kendaraan (wajib)
- Nomor plat (dengan OCR scan)
- Jenis kendaraan
- Kategori (Internal/Eksternal/Lokal)

Setiap kendaraan disimpan dengan foto sendiri. Loop input kendaraan dimungkinkan dengan modal konfirmasi.

### 3. CameraScreen
**Path:** `Aplikasi-Trip-Ionic/src/pages/mobile/CameraScreen.tsx`

Sumber foto tunggal:
- Kamera native (Android/iOS)
- getUserMedia fallback (web)
- **Tidak ada import dari galeri**

### 4. TripSummaryScreen
**Path:** `Aplikasi-Trip-Ionic/src/pages/mobile/TripSummaryScreen.tsx`

Ringkasan sebelum trip dimulai:
- Swafoto (selfie) **WAJIB** - tombol disabled jika `!photoTaken`
- Tidak bisa submit tanpa foto kamera

### 5. TripActiveScreen
**Path:** `Aplikasi-Trip-Ionic/src/pages/mobile/TripActiveScreen.tsx`

Trip berlangsung:
- Tombol **Selesaikan Trip** → commit dengan semua data kendaraan + foto

### 6. TripCompleteScreen
**Path:** `Aplikasi-Trip-Ionic/src/pages/mobile/TripCompleteScreen.tsx`

Trip selesai - memicu sinkronisasi background.

## Alur Data

```
TripConditionScreen
       ↓
VehicleFormScreen ←→ CameraScreen (foto per kendaraan)
       ↓
TripSummaryScreen ←→ CameraScreen (swafoto wajib)
       ↓
TripActiveScreen (Selesaikan Trip)
       ↓
TripCompleteScreen (sync)
```

## Perbaikan Terbaru

### Bug Fix: Switch Kosong→Muatan
**Masalah:** Jika user memilih "Kosong", lalu switch ke "Ada Angkutan", foto dari trip kosong bisa memenuhi syarat swafoto wajib untuk trip muatan.

**Solusi:** Saat switch dari `condition === 'kosong'` ke `'muatan'`, reset semua field foto:
```tsx
...(wasEmpty ? {
  photo: false,
  photoUrl: undefined,
  photoCapturedAt: undefined,
  photoLatitude: undefined,
  photoLongitude: undefined,
} : {})
```

## Data Types

### VehicleEntry (store.tsx)
```typescript
interface VehicleEntry {
  plate: string
  type: string
  category: string
  tariff: number
  photoUrl?: string
  photoCapturedAt?: string
  photoLatitude?: number | null
  photoLongitude?: number | null
  plateStatus?: string
  originRegion?: string
  checkpointRegion?: string
}
```

### Draft (store.tsx)
```typescript
interface Draft {
  routeCode: string | null
  condition: 'kosong' | 'muatan' | null
  vehicles: VehicleEntry[]
  vehicleForm: { plate: string; type: string; category: string }
  photo: boolean          // swafoto wajib
  photoUrl?: string
  photoCapturedAt?: string
  photoLatitude?: number | null
  photoLongitude?: number | null
  cameraFrom: MobileScreen
  cameraMode: 'photo' | 'ocr'
  ocrResult?: string
  ocrError?: string
  startedAt: number | null
}
```
