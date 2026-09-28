# Status Implementasi

> **Terakhir diperbarui:** 25 September 2026

## ✅ Fitur Selesai

### Mobile
- [x] Login PIN + username/password
- [x] Alur trip: pilih muatan dulu → kosong/SJRE-SBDZ
- [x] Input kendaraan 2 langkah + foto kamera wajib
- [x] OCR pembacaan plat
- [x] Daftar plat sudah diinput + detail
- [x] Ganti petugas sinkron dengan admin
- [x] Sinkronisasi offline queue
- [x] History trip

### Admin
- [x] CRUD master tarif + tarif region
- [x] CRUD registrasi plat
- [x] CRUD petugas + aktif/nonaktif + pindah region
- [x] Laporan dengan filter
- [x] Ekspor Excel (.xlsx)
- [x] Tema: terang/gelap, font, aksen
- [x] Fix scroll Ionic di dashboard

### Backend
- [x] JWT authentication
- [x] CRUD all resources
- [x] Many-to-many officer-regions
- [x] Region tariff configuration

## ⚠️ Masalah Terbuka

| # | Masalah | Catatan |
|---|---------|---------|
| 1 | Race antar-proses | Perlu satu pemilik proses |
| 2 | `restart-all.sh` | Pakai `pkill` → matikan proses sehat |
| 3 | Rute mobile statis | `fetchRoutes()` tidak dipanggil |
| 4 | 3 plat belum diverifikasi | Terhadap aturan Internal=0/Lokal/Eksternal |
| 5 | SQLite → MariaDB | Belum dimigrasikan |
| 6 | Database di-git | Sebaiknya `.gitignore` |

## 🐞 Bug History

| # | Bug | Status | Tanggal |
|---|-----|--------|---------|
| 1 | `POST /trips` → 500 (dermaga_id) | Fixed | 25 Sep 2026 |
| 2 | Nama tempat = null | Fixed | 25 Sep 2026 |
| 3 | Data historis hilang | Fixed | 25 Sep 2026 |
| 4 | Label kategori lama | Fixed | 25 Sep 2026 |

## Catatan Penting

> Perbaikan yang hanya di working tree bisa **hilang** kalau ada proses lain yang checkout/stash. Selalu audit ulang setelah restore.
