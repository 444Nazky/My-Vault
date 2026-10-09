# Fix: ReportSheet — Kolom Foto, Lokasi, Reset LocalStorage & Seed Trips Hapus

Tanggal: 2026-09-30

## Fix 1: Kolom Foto & Lokasi di ReportSheet Admin Dashboard

### Gejala

ReportSheet tab "Detail Kendaraan" hanya menampilkan data tabular nomor polisi, jenis, golongan — tidak ada kolom foto kendaraan atau koordinat lokasi, yang membuat verifikasi dokumentasi kendaraan tidak bisa dilakukan dari spreadsheet saja.

### Root Cause

Fitur belum diimplementasi — `ReportVehicle` sudah punya `foto_path`, `latitude`, `longitude`, `foto_captured_at` di tipe datanya tapi tidak dirender di tabel atau spreadsheet export.

### Fix

File: `src/pages/admin/ReportSheet.tsx`

| Komponen | Perubahan |
|----------|-----------|
| `ThumbnailCell` | Komponen React baru — thumbnail 28×28px + tautan ExternalLink, lightbox modal full-size (65vh max) |
| `fotoUrl()` | Helper function untuk konversi path foto ke URL lengkap |
| `fmtCoords()` | Helper function untuk koordinat lat/lng + GMaps URL |
| `vehHeader` | Ditambah kolom `Foto` dan `Lokasi` |
| `vehMatrix` | Kolom foto path + koordinat di-data-kan dari setiap `ReportVehicle` |
| `ThumbnailCell` (render) | Komponen inline untuk cell tabel |
| Build TSV | Flatten foto/lokasi ke URL string untuk TSV safe copy |
| Build XLSX | Kolom Foto URL lengkap, Lokasi tautan GMaps |

Thumbnail click → lightbox modal dengan backdrop blur + auto-reload setelah simpan.

## Fix 2: Typo di AdminDashboard.tsx — Blocking Build

### Gejala

```
error TS1192: Module '...AdminDashboard' has no default export.
error TS17008: JSX element 'div' has no corresponding closing tag.
```

### Root Cause

Dua bug konkuren:
1. `TariffTabass` typo — harus `TariffTab`
2. Missing closing `</div>` di JSX structure

### Fix

- `TariffTabass` → `TariffTab`
- `onSaveTariffs={(t)` → `onSaveTariffs={(t: TariffRow[])`
- Tambah closing `</div>` untuk wrapper utama `<CurrencyProvider>`

## Fix 3: Seed Trips Dummy di localStorage Browser

### Gejala

Meskipun localStorage dibersihkan, trip demo tetap muncul kembali — seed data di-load dari `data.ts`.

### Root Cause

`src/pages/data.ts` memiliki `allTrips = [...]` berisi seed trip (TRP-2026-0086 s/d TRP-2026-0091). Saat localStorage `trip.trips.v1` kosong, `load()` fallback ke seed ini.

### Fix

File: `src/pages/data.ts`

```ts
/** Seed trips — dikosongkan agar data dummy tidak tampil di history. */
export const allTrips = []
```

Seed trip lama di-comment untuk referensi. Trip seed tidak muncul lagi saat localStorage kosong atau di-clear.

## Fix 4: Build Admin Dashboard Production (admin-ci)

### Gejala

Admin dashboard tidak menampilkan perubahan karena build production (`admin-ci/`) tidak diupdate.

### Root Cause

Proses deployment manual — perlu copy file dari `www/` ke `admin-ci/` setiap rebuild, restart PHP server.

### Fix

```bash
# Setiap selesai build production admin:
cp -r www/* admin-ci/
cp archive/admin-ci/index.php admin-ci/
# Restart server:
pkill -f "php -S localhost:8000" && cd admin-ci && php -S localhost:8000
```

Atau gunakan restart script otomatis.

## Files Diedit

| File | Perubahan |
|------|------------|
| `src/pages/admin/ReportSheet.tsx` | Kolom Foto + Lokasi + lightbox |
| `src/pages/admin/AdminDashboard.tsx` | Fix typo, closing tag |
| `src/pages/mobile/SettingsScreen.tsx` | Tombol Reset Data Trip Lokal |
| `src/pages/data.ts` | allTrips = [] |
| `backend/src/db.js` | Tidak ada (hanya dokumentasi) |

## Build Status

```
npm run build: 0 TypeScript errors
Admin production copy: verified
Seed trips: 0 occurrences in bundle
```
