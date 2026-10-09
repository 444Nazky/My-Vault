# 01 - Fixes

## 2026-09-30

### Sync Status Notification di Mobile History (d0f7e8a)

**Masalah:** Petugas tidak bisa melihat apakah data trip mereka sudah terkirim ke admin dashboard atau masih tersimpan di lokal.

**Fix:** Menambahkan indikator sync status di `HistoryScreen.tsx` dan `HistoryDetailScreen.tsx`:
- **ConnectionIndicator** - badge online/offline di header halaman
- **SyncBadge** - badge per item trip:
  - `Cloud` + "Terkirim" → data sudah di admin dashboard
  - `CloudOff` + "Antri" → masih dalam antrian sinkronisasi  
  - `CloudOff` + "Lokal" → tersimpan lokal
- **Summary Stats** - jumlah trip terkirim vs lokal di header
- **Connection Info Card** - info detail koneksi di halaman detail

**Files:**
- `src/pages/mobile/HistoryScreen.tsx` - add SyncBadge, ConnectionIndicator, summary stats
- `src/pages/mobile/HistoryDetailScreen.tsx` - enhance sync status card, add connection info

---

### Admin Dashboard Blank (PHP Router Issue)

**Masalah:** Halaman admin blank padahal server berjalan dan semua file ada.

**Fix:** Server PHP harus dijalankan dengan router `index.php`:
```bash
php -S localhost:8000 admin-ci/index.php
```
Bukan `-t admin-ci` yang tidak menggunakan PHP router.

---

## 2026-09-29

### ReportSheet Kolom Foto Lokasi & Seed Trips

Lihat file: `ReportSheet Kolom Foto Lokasi & Seed Trips.md`

---

## Older Fixes

- Bug Officers Tab Grup Wilayah & Dermaga Kosong
- Form Input Kendaraan Wajib Total dan Laporan Spreadsheet
- Foto Dokumentasi Admin Dashboard Tidak Muncul
- Input PIN Keypad Login
- Login Stuck Memverifikasi
- Master Rute Wilayah dan Login Region
- Pemecahan AdminDashboard dan Pindah Konfigurasi Tarif
- Petugas Master Akses Dermaga dan Rute
- Popup Dermaga Bocor Rute
- Region Select Screen Untuk Petugas Multi-Akses
- Route Filter Semua Rute Bocor
- TripConditionScreen JSX Error & Emoji Replacement
