# Log Book - Modul Form Trip

## Changelog

### 2025-01-XX
#### Bug Fix: Switch Kosong→Muatan tidak reset foto swafoto

**Issue:** Saat user memilih "Kosong", kemudian switch pilihan ke "Ada Angkutan", state `draft.photo` dari trip kosong tidak di-reset. Ini menyebabkan user bisa submit trip muatan tanpa swafoto baru.

**Root Cause:** `TripConditionScreen.tsx` hanya menjalankan `patchDraft({ condition: 'muatan' })` tanpa field foto saat switch ke muatan.

**Fix Applied:**
```tsx
// TripConditionScreen.tsx - switch ke muatan
onClick={() => {
  const wasEmpty = condition === 'kosong'
  setCondition('muatan')
  patchDraft({
    condition: 'muatan',
    vehicles: [],
    vehicleForm: { plate: '', type: '', category: '' },
    // Reset foto jika sebelumnya kosong
    ...(wasEmpty ? {
      photo: false,
      photoUrl: undefined,
      photoCapturedAt: undefined,
      photoLatitude: undefined,
      photoLongitude: undefined,
    } : {}),
    cameraMode: 'photo',
    ocrResult: undefined,
    ocrError: undefined,
  })
}}
```

**Files Modified:**
- `Aplikasi-Trip-Ionic/src/pages/mobile/TripConditionScreen.tsx`

---

## Catatan Teknis

### Flow Foto
1. **Foto per kendaraan** - disimpan di `VehicleEntry.photoUrl`, per kendaraan
2. **Swafoto wajib** - disimpan di `draft.photo` + `draft.photoUrl`, tunggal per trip

### Guard Swafoto
- `TripSummaryScreen.tsx`: `disabled={!photoTaken}`
- `VehicleFormScreen.tsx`: `disabled={!isFormComplete}` dengan `photoTaken` sebagai salah satu syarat

### Guard Looping Kendaraan
- `VehicleFormScreen`: modal konfirmasi sebelum push vehicle
- `pushVehicle()` - reset `vehicleForm` + `photo` setelah push

---

## Riwayat Trip (History)

### Struktur Data

Trip disimpan di localStorage key `trip.trips.v1` dengan struktur:

```typescript
interface Trip {
  id: string              // Format: TRP-YYYY-NNNN
  route: string            // Format: "Asal → Tujuan"
  status: string          // "Selesai", "Aktif", dll
  time: string            // Format: "HH:mm"
  date: string            // Format: "DD Mon YYYY"
  load: 'Ada Muatan' | 'Kosong'
  vehicle?: string        // Untuk trip kosong/null
  type?: string
  category?: string
  revenue: string        // Format: "Rp N,NNN"
  revenueNum: number
  officer: string         // Nama officer yang membuat trip
  duration: string
  photo: boolean
  photoUrl?: string
  vehicles?: VehicleEntry[]
  synced?: boolean
  startedAt?: string
  completedAt?: string
}
```

### Sinkronisasi ke LocalStorage

Store (`store.tsx`) melakukan:

1. **Inisialisasi:** Baca dari `trip.trips.v1` saat mount
2. **Simpan otomatis:** useEffect dengan dependency `[trips]` menyimpan ke localStorage
3. **Cross-tab sync:** Event listener untuk storage event

### Masalah yang Diperbaiki

#### 1. HistoryScreen tidak refresh data

**Gejala:** Trip baru tidak muncul di Riwayat setelah disubmit.

**Fix:** Tambah focus listener + storage listener + key forcing re-render.

```typescript
useEffect(() => {
  refreshTrips() // Initial refresh
  
  const handleFocus = () => refreshTrips()
  const handleStorage = (e: StorageEvent) => {
    if (e.key === 'trip.trips.v1') refreshTrips()
  }
  
  window.addEventListener('focus', handleFocus)
  window.addEventListener('storage', handleStorage)
  
  return () => {
    window.removeEventListener('focus', handleFocus)
    window.removeEventListener('storage', handleStorage)
  }
}, [refreshTrips])
```

#### 2. HistoryDetailScreen menampilkan trip yang salah

**Gejala:** Detail trip fallback ke trip pertama jika trip target tidak ditemukan.

**Fix:** Hapus fallback `?? myTrips[0]`, tampilkan "Trip tidak ditemukan" jika `detailTripId` invalid atau bukan milik officer.

```typescript
// Cari trip berdasarkan ID
const targetTrip = detailTripId ? trips.find(x => x.id === detailTripId) : null
// Verifikasi kepemilikan
const t = targetTrip && targetTrip.officer === officer.name ? targetTrip : null

if (!t) {
  return <div>Trip tidak ditemukan</div>
}
```

### Alur Pembacaan Data

```
localStorage.getItem('trip.trips.v1')
    ↓
store.tsx useState(() => load(LS.trips, seedTrips))
    ↓
useApp().trips
    ↓
HistoryScreen / HistoryDetailScreen
```

### Refresh Data

1. **Mount:** Store baca dari localStorage
2. **commitTrip():** Store update state → React re-render consumers
3. **Focus:** HistoryScreen refreshTrips() → setRefreshKey() → force re-render
4. **Storage event:** Browser storage sync → HistoryScreen trigger refresh
