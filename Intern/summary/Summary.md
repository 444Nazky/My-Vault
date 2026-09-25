# Ringkasan - Sinkronisasi Data Trip Angkutan

Tanggal: 24 September 2026

---

## Update — 25 September 2026 (Revisi Spesifikasi + Patches)

### A. Mobile — revisi alur & tampilan (SEMUA ✅ terverifikasi)

| Revisi | Implementasi | Status |
|--------|-------------|--------|
| Mulai Trip → **pilih status muatan dulu** | `HomeScreen` → `TripConditionScreen` (Kosong / Ada Angkutan) → `RouteSelectScreen` | ✅ |
| Muatan **Kosong → rute dikunci hanya SJRE → SBDZ** | guard di `RouteSelectScreen` (`isEmptyTrip`), badge “Terkunci”, rute lama di-reset | ✅ |
| Muatan **Ada Angkutan → rute bebas** | filter dilepas | ✅ |
| **Sembunyikan seluruh tarif di mobile** | tidak ada satu pun `Rp`/`formatRp` yang dirender; nilai tarif hanya disimpan di objek trip untuk sinkron & laporan admin | ✅ |
| **Detail tambahan muncul SETELAH input kendaraan** | `VehicleFormScreen` 2 langkah (`vehicleInputDone`); kartu placeholder sebelum lengkap | ✅ |
| **Lihat plat yang sudah diinput (diklik)** | kartu “No. Polisi Sudah Diinput” — ketuk untuk detail: plat, jenis, kategori, status plat, wilayah asal, pos, **foto dokumentasi** + tombol “Isi Ulang Form” | ✅ |
| **Wajib jepret kamera sebelum submit** | tombol galeri dihapus (`capture="environment"`), “Simpan Data Kendaraan” & “Submit Trip” terkunci sampai foto ada | ✅ |
| **Switch akun pegawai sinkron** | lihat butir B di bawah | ✅ |

Alur final: `Beranda → Status Muatan → Pilih Rute → (Kendaraan → Detail) → Kamera → Ringkasan → Trip Aktif`.

### B. Sinkron petugas admin ↔ mobile (akar masalah diperbaiki)

1. **Root cause #1 — backend menjalankan kode lama**: proses `node src/index.js` (start 08:40) belum punya route baru → `GET /officers/my-region` & `GET /reports/trips/filters` balas **404**, jadi daftar petugas mobile tidak pernah bisa ditarik → restart backend.
2. **Root cause #2 — sesi bisa mati oleh refresh gagal**: `refreshBackendSession` membuang token lalu login PIN demo (`123456`) → petugas dengan PIN khusus gagal → sesi mati → sync selalu gagal. **Fix:** endpoint baru `POST /api/auth/refresh` (terbitkan ulang JWT dari klaim DB terbaru + cek `is_active`, tanpa PIN); token lama hanya diganti **setelah** yang baru terbit; offline → token lama dipertahankan.
3. **Nonaktifkan akun** → refresh ditolak 401 → sesi mobile petugas otomatis berakhir; login PIN juga 401; tampil Nonaktif di daftar ganti petugas.
4. **Pindah region** → `my-region` langsung berubah; token baru membawa klaim region baru (trip tercatat di wilayah benar).
5. Mobile menarik daftar **paksa** saat aplikasi dibuka & saat layar Ganti Petugas dibuka (lewati cache 5 menit).
6. Admin mount kini **merge data server** ke tampilan (bukan localStorage basi); header grup multi-wilayah dihitung benar.

### C. Admin dashboard

- **Ekspor laporan → Excel `.xlsx`** (2 sheet: Laporan Trip + Detail Kendaraan) oleh `src/services/xlsx.ts` — **nol dependency baru** (ZIP stored + SpreadsheetML); tervalidasi `unzip -t` & dibuka `openpyxl`.
- **Detail tempat & tanggal akurat**: `route_from_name`/`route_to_name` (join region + alias kode rute `BDAU`↔`BADAU`) + tanggal-jam **WIB** (`formatReportDateTime`).
- **Filter laporan Golongan & Jenis Kendaraan** (`GET /reports/trips/filters`, server-side `EXISTS`).
- **Aktif/nonaktif & pindah akses region petugas** → selalu re-fetch; server jadi sumber kebenaran (E2E lulus).
- **Konfigurasi tarif terpusat** (`region_tariffs`): **Internal = 0 · Lokal = cadangan/bisa diubah (saat ini 0) · Eksternal = tarif region** — ubah lewat tab Master Tarif, tanpa ubah kode.
- **FIX scroll**: CSS Ionic memaksa `body{position:fixed;overflow:hidden}` → override `html[data-admin]` di `index.php` (instan) + `src/index.css`.
- **Favicon Ionic dihapus** dari `:8000` (strip di `index.php`, tahan terhadap build ulang).
- **Baru — tab Pengaturan → “Tema & Tampilan”** (`src/services/theme.ts`): tema Terang/Gelap, Ukuran Font 90–125%, warna aksen (Biru/Hijau/Ungu/Kuning), Reset; persist `localStorage`.

### D. Verifikasi (25 Sep 2026)

```
✓ tsc --noEmit · ng lint · ng build — bersih
✓ node --check semua route backend
✓ Endpoint live: /officers, /officers/my-region, /auth/refresh,
  /reports/trips/filters, /region-tariffs, /plates → 200
✓ E2E Chromium (CDP): scroll, kartu Tema&Tampilan, gelap, zoom 1.1,
  aksen ungu, persist reload, reset — 8/8 OK
✓ E2E sync petugas: pindah region & nonaktif → mobile sinkron, DB di-restore
✓ admin-ci disinkronkan dengan build terbaru
```

---

## Arsitektur Sistem

```
┌─────────────────────────────────────────────────────────────┐
│                    MOBILE APP (Ionic)                       │
│  • Capacitor (native features)                              │
│  • Local-first (localStorage)                             │
│  • Sync queue → Backend                                   │
└─────────────────────┬───────────────────────────────────┘
                      │ HTTP/REST
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    BACKEND API (Node.js + Express)          │
│  • JWT Authentication                                     │
│  • SQLite (sql.js)                                       │
│  • Trip CRUD + sync queue                                │
└───────────────────────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│            ADMIN DASHBOARD (React → Static HTML)             │
│  • React build → static files (www/)                      │
│  • CodeIgniter 2.2.4 serve static HTML + API             │
│  • Compatible PHP 5.6+                                   │
└───────────────────────────────────────────────────────────┘
```

## Tech Stack

| Komponen | Teknologi | Port |
|----------|----------|------|
| Mobile App | Ionic + Capacitor | 5173 |
| Admin Dashboard | React → Static HTML + CI 2.2.4 | 4200 / 8000 |
| Backend API | Node.js + Express + SQLite | 3000 |
| Database | SQLite (dev) / MariaDB (prod) | - |

---

## Masalah yang Diperbaiki

### 1. Sync Gap - FIXED
**Masalah:** Login petugas tidak mendapat JWT → sync POST /trips gagal 401

**Solusi:** Endpoint `POST /api/auth/member-login` + call di LoginPage

### 2. SQL.js Bug - FIXED
**Masalah:** `sql.js` tidak bisa bind `undefined` → CREATE TRIP gagal

**Solusi:** db.js wrapper convert `undefined` ke `null`

### 3. Dashboard Admin Empty - FIXED
**Masalah:** Admin tidak bisa lihat trips dari server

**Solusi:** `GET /trips` admin melihat semua trip tanpa filter region

### 4. Laporan Expandable - FIXED
**Fitur:** Klik baris trip untuk melihat detail kendaraan (plat, jenis, kategori, tarif)

### 5. React → CodeIgniter 2.2.4 Migration - DONE
**Solusi:** React build ke static HTML, serve oleh CI 2.2.4 dengan API endpoints

---

## Files yang Dibuat/Diubah

### Backend (Node.js)
| File | Change |
|------|--------|
| `backend/src/routes/auth.js` | +member-login, +admin-login, role di JWT |
| `backend/src/db.js` | Fix undefined→null binding |

### Frontend (Ionic)
| File | Change |
|------|--------|
| `src/services/api.ts` | HTTP client + JWT auth |
| `src/services/auth.ts` | Login + token management |
| `src/services/sync.ts` | Queue-based background sync |
| `src/services/trips.ts` | Fetch trips dari backend |
| `src/pages/LoginPage.tsx` | Call memberLogin() |
| `src/environments/*.ts` | Dev & Staging URLs |

### Admin Dashboard (CodeIgniter 2.2.4)
| File | Purpose |
|------|---------|
| `admin-ci/index.php` | Entry point - serve static React |
| `admin-ci/index.html.htaccess` | Client-side routing (SPA) |
| `admin-ci/application/controllers/Admin.php` | Load dashboard |
| `admin-ci/application/controllers/Api.php` | REST API dengan CORS + JSON |

---

## API Endpoints

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/auth/member-login` | Login petugas → JWT |
| POST | `/api/auth/admin-login` | Login admin → JWT |
| POST | `/api/auth/login` | Login PIN (ganti petugas) |
| POST | `/api/auth/refresh` | Terbit ulang JWT dari klaim DB terbaru *(baru 25 Sep)* |
| GET | `/api/health` | Health check |
| GET/POST | `/api/trips` | CRUD trips |
| GET | `/api/trips/:id` | Trip detail |
| POST | `/api/trips/:id/vehicles` | Tambah kendaraan |
| GET | `/api/tariffs` | Master tarif (admin) |
| GET/POST/PUT | `/api/region-tariffs` | Tarif region: lokal/eksternal *(konfigurasi terpusat)* |
| GET/POST | `/api/plates` | Registrasi plat (internal/lokal/eksternal) |
| POST | `/api/plates/check` | Cek status plat (OCR input) |
| GET/POST/PUT/DELETE | `/api/officers` | CRUD petugas (admin) |
| PUT | `/api/officers/:id/regions` | Pindah akses wilayah (many-to-many) |
| PUT | `/api/officers/:id/status` | Aktif/nonaktif petugas |
| GET | `/api/officers/my-region` | Daftar petugas 1 wilayah (token petugas) *(baru 25 Sep)* |
| GET | `/api/regions` | Daftar region |
| GET | `/api/reports/trips` | Laporan rinci dengan vehicles |
| GET | `/api/reports/trips/filters` | Opsi filter golongan & jenis *(baru 25 Sep)* |
| GET | `/api/reports/summary` | Statistik ringkas (admin) |

---

## Test Results

```
✓ Backend :3000 running
✓ POST /api/auth/member-login → JWT + officer
✓ POST /api/auth/admin-login → JWT role admin
✓ POST /api/trips → 201 Created
✓ GET /api/reports/trips → Detail trips dengan vehicles
✓ Admin PHP dashboard serves React static build
✓ Admin dashboard connects to backend API
✓ Laporan expandable dengan detail kendaraan
```

---

## Build & Deploy

### Build Mobile + Backend
```bash
npm run build
cd backend && npm start
```

### Deploy Admin Dashboard
Lihat: [Deploy-Admin-CodeIgniter.md](./Deploy-Admin-CodeIgniter.md)

Quick deploy:
```bash
# 1. Build React
npm run build

# 2. Copy admin-ci folder ke server
scp -r admin-ci/ server@IP:/var/www/html/

# 3. Symlink assets
ssh server "cd /var/www/html/admin-ci && ln -sf ../www assets"

# 4. Konfigurasi database di CI config
# 5. Konfigurasi API token di Api.php
```

---

## Dokumentasi

| File | Purpose |
|------|---------|
| Summary.md | Ini - ringkasan proyek |
| Tutorial.md | Penjelasan teknis sync flow |
| Setup.md | Setup dari awal |
| Deploy-Admin-CodeIgniter.md | Deploy admin dashboard |
