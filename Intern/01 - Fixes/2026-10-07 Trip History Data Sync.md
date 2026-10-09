# Trip History Screen - Data Sync Fix

## Tanggal: 2026-10-07

## Masalah

1. **HistoryScreen tidak refresh data**: Trip baru tidak muncul di Riwayat setelah disubmit
2. **HistoryDetailScreen menampilkan trip yang salah**: Fallback `?? myTrips[0]` menampilkan trip acak
3. **Navigasi balik tidak sync data**: Data tidak di-refresh saat kembali ke layar Riwayat

## Root Cause

1. `HistoryScreen` tidak memiliki mekanisme untuk refresh data saat mount atau focus
2. `HistoryDetailScreen` menggunakan fallback `?? myTrips[0]` yang menampilkan trip pertama jika trip target tidak ditemukan
3. Store sudah menyimpan ke localStorage tapi consumers tidak selalu re-render

## Fix Applied

### HistoryScreen.tsx

```typescript
// Tambah state untuk force refresh
const [refreshKey, setRefreshKey] = useState(0)
const refreshTrips = useCallback(() => setRefreshKey(k => k + 1), [])

useEffect(() => {
  refreshTrips()
  
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

// Force re-render dengan key
const tripsKey = `${refreshKey}-${trips.length}-${officer.name}`
<div key={tripsKey}>...</div>
```

### HistoryDetailScreen.tsx

```typescript
// Hapus fallback yang salah
const targetTrip = detailTripId ? trips.find(x => x.id === detailTripId) : null
const t = targetTrip && targetTrip.officer === officer.name ? targetTrip : null

// Handle navigasi balik
const handleBack = () => {
  if (!t && detailTripId) setDetailTripId(null)
  go('history')
}

if (!t) {
  return <div>Trip tidak ditemukan</div>
}
```

## Files Modified

- `src/pages/mobile/HistoryScreen.tsx`
- `src/pages/mobile/HistoryDetailScreen.tsx`

## Verifikasi

- [x] Trip baru langsung muncul di Riwayat setelah disubmit
- [x] Refresh saat navigasi balik dari layar lain
- [x] Detail trip hanya menampilkan trip milik officer yang login
- [x] Tidak ada trip yang "hilang" atau tidak tampil
