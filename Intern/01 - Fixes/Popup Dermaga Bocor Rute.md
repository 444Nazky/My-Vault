# Fix: Popup Dermaga Saat Mulai Trip — Rute Bocor ke UI

Tanggal: 2026-09-29

## Gejala

Petugas dual-access (contoh: Dewi Kusuma) pilih Dermaga 1 di popup Mulai Trip, tapi semua rute dari D1 DAN D2 tampil di layar Pilih Rute. Seharusnya hanya rute Dermaga 1.

Screenshot: petugas pilih D1 di popup tapi UI tampilkan rute D1+D2.

## Root Cause — Triple Bug

### Bug 1: Popup Dermaga Triggered di Login

`PinVerifyScreen` panggil `onDermagaSelect` saat login dual-access. Popup seharusnya HANYA muncul saat "Mulai Trip" ditekan, BUKAN saat verifikasi PIN.

### Bug 2: `activeDermagaId` Tidak Dipropagate ke RouteSelectScreen

`MobileApp` set `activeDermagaId` via `setActiveDermaga()` tapi RouteSelectScreen baca dari `useApp()` — state baru tidak propagasi ke komponen yang sudah di-render.

### Bug 3: RouteSelectScreen Tampilkan Semua Dock untuk Dual-Access

Filter hanya `allowedDockIds` (Set semua dock) — TIDAK pakai dock yang dipilih di popup Mulai Trip.

```tsx
// MobileApp.tsx — popup di trigger di login
if (result.data.isDualAccess) onDermagaSelect?.(result.data.dermagas)

// RouteSelectScreen — showing ALL docks for dual-access
const allowedDockIds = new Set(accessibleDermagas.map(d => d.id))
const dermagaFiltered = isDual
  ? routes.filter(r => allowedDockIds.has(r.dermagaId || '')) // ❌ semua dock
  : ...
```

## Fix

### 1. `MobileApp.tsx` — Popup Hanya di `handleStartTrip`

```tsx
function handleStartTrip() {
  const accesses = officer.dermagaAccess || []
  if (accesses.length > 1) {
    // Popup pilihan dermaga SAAT MULAI TRIP
    setPendingDermagas(accesses as Dermaga[])
    setSelectedDockId(null) // belum pilih
    return
  }
  setSelectedDockId(accesses[0]?.id ?? null)
  go('trip-condition')
}

function handleDermagaSelected(dermaga: Dermaga) {
  setSelectedDockId(dermaga.id)
  setPendingDermagas(null)
  go('trip-condition')
}
```

### 2. `PinVerifyScreen` — Popup Dermaga Dipindahkan ke `MobileApp`

Popup TIDAK muncul saat login/switch. `PinVerifyScreen` tanpa `onDermagaSelect`. Admin dashboard & mobile terpisah.

### 3. `RouteSelectScreen` — Filter Mutlak `selectedDockId`

```tsx
// selectedDockId dari prop: injected MobileApp SAAT render.
const dockId = selectedDockId ?? null  // null = popup dermaga terbuka = empty state

// Filter mutlak. selectedDockId null = kosong (bukan semua dock).
const dermagaFiltered = dockId
  ? routes.filter(r => r.dermagaId === dockId)
  : []

// Empty state: petugas belum pilih dock
if (!loading && list.length === 0) {
  dockName
    ? 'Tidak ada rute untuk ${dockName}.'
    : 'Pilih dermaga untuk melihat rute.'
}
```

### 4. `MobileApp` Pass `selectedDockId` Prop

```tsx
'route-select': <RouteSelectScreen
  go={go}
  selectedDockId={selectedDockId}
/>
```

## Files Diedit

| File | Perubahan |
|------|-----------|
| `MobileApp.tsx` | Popup trigger di `handleStartTrip` saja, pass `selectedDockId` prop |
| `PinVerifyScreen.tsx` | Rewrite penuh, hapus `onDermagaSelect`, hapus `useApp()` |

## Flow Benar

```
1. Petugas tekan "Mulai Trip"
2. MobileApp.popup dermaga picker (bukan di login)
3. Petugas pilih D1
4. MobileApp setSelectedDockId('uuid-d1') + go('trip-condition')
5. RouteSelectScreen render dengan selectedDockId = 'uuid-d1'
6. Filter mutlak: HANYA rute D1 tampil
7. Petugas lanjut trip-condition → vehicle-form → dll.
```

## Build

```
✓ 0 TypeScript errors
✓ vite build (455.14 kB JS)
```
