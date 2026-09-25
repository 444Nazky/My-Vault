# Functional Requirements

> **Status:** disesuaikan dengan implementasi aktual — 25 September 2026
> Stack nyata: **Ionic + React (mobile)** · **Node.js + Express + SQLite/sql.js (backend)** · **React build → statis, disajikan CodeIgniter `admin-ci/` (dashboard admin)** · **JWT** (bukan Firebase/Flutter).

---

## Mobile App (Ionic + React)

### FR-001: Authentication
- Login layar utama: username/password → `POST /api/auth/member-login` → JWT petugas
- Ganti petugas: PIN 6 digit → `POST /api/auth/login` (ditolak bila akun **Nonaktif** / PIN salah)
- Refresh klaim: `POST /api/auth/refresh` — token baru dari DB terbaru **tanpa PIN**; token lama hanya diganti setelah yang baru terbit
- Fallback offline: PIN demo hanya dipakai saat server **tidak terjangkau** — respons 401 server tetap menutup sesi

### FR-002: Mulai Trip (alur revisi 25 Sep 2026)
- Beranda → **pilih status muatan dulu**: “Kosong / Tidak Ada Muatan” atau “Ada Angkutan”
- **Kosong** → rute **dikunci & difilter hanya SJRE → SBDZ** (badge “Terkunci”, rute lama di-reset)
- **Ada Angkutan** → seluruh rute bebas
- Nomor trip auto-generate `TRP-YYYY-NNNN`
- Tanpa tampilan tarif di seluruh layar mobile

### FR-003: Input Kendaraan (2 langkah)
- **Langkah 1 — Input Kendaraan:** No. Polisi (+ Scan OCR / Cek Status Plat), Jenis Kendaraan (dari master tarif)
- **Langkah 2 — Detail Informasi Tambahan:** baru muncul **setelah** langkah 1 lengkap: Kategori Kendaraan + **Foto Bukti wajib via kamera**
- **Daftar “No. Polisi Sudah Diinput”:** ketuk plat tersimpan → detail (plat, jenis, kategori, status plat, wilayah asal, pos pemeriksaan, **foto dokumentasi**) + “Isi Ulang Form Dari Plat Ini”
- Setiap unit wajib foto sendiri saat menambah kendaraan lain

### FR-004: Submit Trip
- Tombol **“Simpan Data Kendaraan”** dan **“Submit Trip — Mulai Sekarang”** terkunci sampai **foto kamera** ada (tombol unggah galeri dihapus — `capture="environment"`)
- Ringkasan menampilkan status foto + kendaraan (foto, badge status plat)

### FR-005: Sinkronisasi Offline
- Antrian sync (`src/services/sync.ts`) → `POST /api/trips` + `POST /api/trips/:id/vehicles`
- Penanda `synced` per trip; daftar petugas di-refresh paksa saat aplikasi/layar ganti petugas dibuka

### FR-006: Ganti Petugas (sinkron dengan admin)
- Daftar dari `GET /api/officers/my-region` (hanya petugas yang berbagi wilayah)
- Status **Aktif/Nonaktif** dan **akses wilayah** langsung mengikuti admin
- Akun dinonaktifkan admin → refresh token ditolak (401) → **sesi mobile otomatis berakhir**

---

## Admin Dashboard (`admin-ci/`, port 8000)

### FR-101: Manajemen Petugas
- CRUD petugas; **aktif/nonaktif** (`PUT /officers/:id/status`); **pindah akses wilayah many-to-many** (`PUT /officers/:id/regions`, tabel junction `officer_regions`)
- Server adalah sumber kebenaran — setiap aksi re-fetch, tampilan digabung ulang dari data server

### FR-102: Laporan Trip
- Daftar trip + panel detail + baris expandable (kendaraan)
- **Detail tempat & tanggal akurat**: `route_from_name`/`route_to_name` (join region, termasuk alias kode rute `BDAU`↔`BADAU`) + tanggal-jam **WIB**
- **Filter Golongan & Jenis Kendaraan** (`GET /reports/trips/filters`, server-side)
- **Ekspor Excel `.xlsx`** (2 sheet: Laporan Trip + Detail Kendaraan) — `src/services/xlsx.ts`, nol dependency baru

### FR-103: Master Tarif & Konfigurasi Tarif Terpusat
- CRUD master tarif (golongan, jenis, tarif muatan/kosong) — admin-only (`authenticate + requireAdmin`)
- **Tarif region** (`region_tariffs`, kolom `region_id, tariff_type, nominal_tariff, is_active`):
  - **Internal = 0** (plat terdaftar internal tidak dikenakan tarif)
  - **Lokal = cadangan/bisa diubah** (saat ini 0; bisa diubah admin tanpa ubah kode)
  - **Eksternal = tarif region** masing-masing

### FR-104: Registrasi Plat
- CRUD plat: nomor, pemilik, region asal, status (internal/lokal/eksternal)
- `POST /plates/check` → status tarif mengikuti aturan registrasi & region pos

### FR-105: Tema & Tampilan (baru, tab Pengaturan)
- Tema **Terang/Gelap**, **Ukuran Font** 90/100/110/125%, **warna aksen** (Biru/Hijau/Ungu/Kuning), Reset
- Persist di `localStorage` (`src/services/theme.ts`), CSS di-scope `html[data-admin]` — mobile tidak terpengaruh
- Perbaikan pendukung: scroll halaman aktif (override CSS Ionic `body{position:fixed;overflow:hidden}`), favicon Ionic dihapus dari `:8000`

---

## Catatan yang TIDAK diimplementasikan (draft lama)
- Validasi GPS/geofencing, device binding, Firebase Auth/Storage, ekspor PDF/CSV, grafik peta — **tidak ada** dalam versi ini.
- Nomor trip format saat ini `TRP-YYYY-NNNN` (bukan `TRP-DDMMYY-SEQ`).
