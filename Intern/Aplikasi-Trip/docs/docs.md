> _Digabungkan khusus untuk Obsidian.md — Berisi ringkasan proyek, tutorial teknis, dan catatan audit/perbaikan lengkap._
> 
>   

## 1. Ringkasan & Catatan Perubahan (Summary.md)

# Ringkasan - Sinkronisasi Data Trip Angkutan

Tanggal: 24 September 2026

  

## Update — 25 September 2026 (Audit Error & Perbaikan Data)

> Audit kedua: seluruh endpoint di-smoke-test, log backend dibaca, dan data DB
> 
> diverifikasi terhadap dokumen spesifikasi. **Empat bug nyata ditemukan & diperbaiki.**
> 
>   

### 🔴 Bug 1 — `POST /trips` selalu gagal 500 (kritis)

|||
|---|---|
|**Gejala**|`Create trip error: NOT NULL constraint failed: trips.dermaga_id` (4x di `backend.log`); `POST /api/trips` → **500**|
|**Dampak**|**Tidak ada trip tersinkron sama sekali** — `trips=0`, `vehicles=0`, laporan admin kosong, semua fitur laporan & ekspor percuma|
|**Akar masalah**|Commit **`a2e8b88` “revisi akses”** (25 Sep 14:12) menambah kolom `dermaga_id TEXT NOT NULL` ke skema `trips`, tapi **tidak pernah mengubah INSERT** di `backend/src/routes/trips.js`. Klien mobile juga tidak pernah mengirim `dermaga` (layar mobile tak memilih dermaga)|
|**Perbaikan**|1) `trips.js` — derive `dermaga_id` server-side: `req.body.dermagaId` → dermaga penugasan petugas (`officer_dermagas`) → dermaga pertama region → `null`<br><br>  <br>  <br><br>2) `db.js` — migrasi `relaxTripsDermagaNotNull()`: rebuild tabel agar `dermaga_id` **nullable** (SQLite tak mendukung ALTER COLUMN; FK tak di-enforce & kolom tak dipakai query laporan mana pun → aman)|
|**Status**|✅ `POST /trips` → **201**, kendaraan tersambung (`vehicle_count:1`), dermaga terisi otomatis|

### 🔴 Bug 2 — Region jadi placeholder `R1–R4` (nama tempat laporan kosong)

|||
|---|---|
|**Gejala**|`route_from_name`/`route_to_name` = **`null`** di semua laporan; daftar region admin menampilkan “Region 1..4”|
|**Dampak**|Spesifikasi “detail tempat akurat” **tidak terpenuhi** — laporan cuma menampilkan kode (`SJRE → SBDZ`) tanpa nama wilayah|
|**Akar masalah**|Commit **`a2e8b88`** yang sama mengubah seed `seedData()` dari wilayah asli (`BADAU`/`SJRE`/`SBDZ`/`ENTIKONG`) menjadi placeholder (`R1`–`R4`). Kode rute mobile `SJRE`/`SBDZ`/`BDAU` tidak ada di tabel `regions` → join nama gagal|
|**Perbaikan**|1) **Rename di DB**: `R1→BADAU (Badau)`, `R2→SJRE (Sijangkung)`, `R3→SBDZ (Sabadi)`, `R4→ENTIKONG (Entikong)` — nama mengikuti label rute di aplikasi mobile<br><br>  <br>  <br><br>2) **Seed `db.js` dikembalikan** ke kode wilayah asli + seed rute memakai kode `SJRE`/`SBDZ`/`BDAU` (bukan placeholder `A→B`) — DB baru tak mengulang regresi<br><br>  <br>  <br><br>3) Relasi `officer_regions`/`region_tariffs`/`officer_dermagas` ikut terbawa (rename by id, bukan hapus-tambah)|
|**Status**|✅ **0 dari 16 trip** dengan nama tempat kosong — `Sijangkung (SJRE) → Sabadi (SBDZ)` dst.|

### 🔴 Bug 3 — Data historis hilang + istilah lama muncul lagi

|||
|---|---|
|**Gejala**|DB utama cuma punya 3 trip (2 di antaranya data uji) & **0 plat**; `golongan` berisi `Eksternal (Berganji)` / `Eksternal (Tanpa Garansi)`; ada trip **yatim** (`officer_id="1"` — ID legacy, `region_id` menunjuk worktree)|
|**Dampak**|Laporan mendekati kosong; istilah birokratis yang sudah dibersihkan **kembali terekam di DB**; trip yatim tak tampil (JOIN gagal)|
|**Akar masalah**|DB asli (13 trip, 3 plat, petugas ber-wilayah) hanya bertahan di worktree `.kilo/worktrees/admitted-steel/`; DB utama ikut ter-reset saat seed berubah. Normalisasi istilah sebelumnya hanya menyentuh 1 baris|
|**Perbaikan**|Skrip migrasi (`/tmp/migrate-data.js`, backend dimatikan dulu): **salin 13 trip + 26 kendaraan + 3 plat** dari worktree (petakan `officer_id` legacy → UUID via nama, `region_id` asing → kode wilayah), **perbaiki trip yatim** (0 tersisa), **normalisasi istilah** (`Berganji→Eksternal`, `Tanpa Garansi→Eksternal Bebas`) di `vehicles.golongan` + `trip.keterangan`|
|**Status**|✅ **16 trip · 32 kendaraan · 3 plat · 0 yatim · 0 istilah lama**. Backup: `data/trip.db.bak-20260925-160737`|

### 🔴 Bug 4 — Regresi: label kategori mobile kembali ke istilah lama

|||
|---|---|
|**Gejala**|Picker “Kategori Kendaraan” di `VehicleFormScreen.tsx` kembali menampilkan `Eksternal (Berganji)` / `Eksternal (Tanpa Garansi)`|
|**Akar masalah**|File dipulihkan dari stash yang berasal **sebelum** perbaikan istilah (commit terakhir file `7d9911d` 11:25; perbaikan istilah ~13:00) — perbaikan tertimpa oleh proses lain yang melakukan checkout/restore|
|**Perbaikan**|Kembalikan label ke `Internal · Eksternal · Eksternal Bebas` (warna badge disamakan dengan AdminDashboard: slate/amber/rose) + komentar penanda|
|**Status**|✅ 0 istilah lama di source & bundle|

> **Pelajaran:** perbaikan yang hanya hidup di working tree bisa hilang diam-diam saat ada proses lain `checkout`/`stash pop`/`reset`. Setelah merge/restore → **audit ulang** dengan `grep`, jangan asumsi perbaikan masih ada.
> 
>   

### ✅ Yang ternyata TIDAK rusak (diverifikasi, bukan asumsi)

- **Filter golongan & jenis kendaraan** — bekerja benar: `golongan=I`→1 trip (Motor), `II`→0, `IV`→1 (Truck Sedang), `vehicleType=Motor`→1. Opsi filter dari `tariffs` (I..V) sengaja dipetakan lewat `LEFT JOIN tariffs ON vehicle_type` sehingga cocok juga dengan `v.golongan` kategori (Internal/Eksternal).
    
      
    
- **Semua endpoint lain** — 24 endpoint di-smoke-test (admin & officer): **200/201 semua**, satu-satunya kegagalan `POST /trips` (Bug 1). `GET /officers/my-region` dengan token admin → 401 _by design_ (khusus petugas).
    
      
    
- **Ekspor Spreadsheet (baru, utama)** — tombol **Ekspor Spreadsheet** di Laporan me-`redirect` ke `#/sheet`: halaman **Spreadsheet Live** (`src/pages/admin/ReportSheet.tsx`) yang menarik data langsung dari `GET /reports/trips` dan **sinkron ulang tiap 15 detik** — tanpa unduh/impor berkas, tanpa file sementara di server. Isi: 2 lembar tab (Laporan Trip / Detail Kendaraan), filter tanggal+golongan+jenis, total baris, aksi **Salin (TSV)** siap tempel ke Google Sheets/Excel, dan segarkan manual. Ikon tab baru (`ExternalLink`) tetap tersedia sebagai opsional.
- **Ekspor xlsx (opsional, cara lama)** — tombol `.xlsx` di Laporan tetap ada memakai `downloadXlsx` **client-side** (2 sheet, ZIP valid). Endpoint `/reports/trips/export` memang sengaja CSV (cadangan) — bukan bug.
    
      
    
- **Sinkron petugas** (aktif/nonaktif/pindah region) — masih lulus uji dari sesi sebelumnya.
    
      
    

### Verifikasi akhir (25 Sep 2026)

|**Check**|**Hasil**|
|---|---|
|Smoke-test 24 endpoint|✅ 200/201 (kini tanpa kegagalan)|
|`POST /trips` + `/vehicles`|✅ 201 + 201|
|Nama tempat di laporan|✅ 0 kosong dari 16 trip|
|Detail trip di UI (E2E Chromium)|✅ Sijangkung/Sabadi/Badau + tanggal-jam WIB|
|Ekspor Excel (E2E)|✅ `laporan-trip-2026-09-25.xlsx`, 42.763 bytes, ZIP valid|
|Istilah lama / placeholder `Region 1` di UI|✅ 0|
|`tsc --noEmit`|✅ 0 error|
|`ng lint`|✅ All files pass|
|`ng build`|✅ sukses; `admin-ci` sinkron identik|
|`node --check` semua file backend|✅|
|`:3000` / `:8000` / `:5173`|✅ 200 / 200 / 200|

### ⚠️ Masalah yang MASIH TERBUKA (belum disentuh)

1. **Race antar-proses** — sesi ini beberapa kali layanan mati mendadak (`:8000`, `:5173`, `:3000`) dan `admin-ci/` sempat hilang/regenerasi, karena ada proses lain menjalankan `restart-all.sh` (yang memakai `pkill`) + proses sync yang meng-commit sendiri. Gejala: `EADDRINUSE`, log backend bersih tapi proses hilang. **Perlu satu pemilik proses** — jangan jalankan `restart-all.sh` bersamaan dengan server yang sudah hidup.
    
      
    
2. **`restart-all.sh` membunuh semua layanan** termasuk yang sehat (`pkill -f "php -S"`, `pkill -f "ng serve"`) — kalau dipakai untuk restart backend saja, ia ikut mematikan admin & mobile.
    
      
    
3. **Rute mobile masih statis** (`ROUTES` di `src/pages/data.ts`), bukan dari `GET /routes`. `fetchRoutes()` di `dermagas.ts` **tak pernah dipanggil**. DB sudah berisi rute dengan kode benar, tinggal dialihkan bila memang diinginkan.
    
      
    
4. **`vehicle_plates` kini terisi 3 plat**, tapi statusnya berasal dari worktree (`internal`/`lokal`) — belum diverifikasi ulang terhadap aturan penarifan (Internal=0 · Lokal=cadangan · Eksternal=region).
    
      
    
5. **DB masih SQLite** (`data/trip.db`), MariaDB belum — sesuai catatan lama.
    
      
    
6. **Ada 3 salinan DB** berisi data berbeda (utama / `admitted-steel` / `foggy-process`) — `data/trip.db` **di-track git**, jadi perubahan data ikut ter-commit dan mudah tertimpa. Pertimbangkan `.gitignore` + backup terpisah.
    
      
    

## Update — 25 September 2026 (Revisi Spesifikasi + Patches)

### A. Mobile — revisi alur & tampilan (SEMUA ✅ terverifikasi)

|**Revisi**|**Implementasi**|**Status**|
|---|---|---|
|Mulai Trip → **pilih status muatan dulu**|`HomeScreen` → `TripConditionScreen` (Kosong / Ada Angkutan) → `RouteSelectScreen`|✅|
|Muatan **Kosong → rute dikunci hanya SJRE → SBDZ**|guard di `RouteSelectScreen` (`isEmptyTrip`), badge “Terkunci”, rute lama di-reset|✅|
|Muatan **Ada Angkutan → rute bebas**|filter dilepas|✅|
|**Sembunyikan seluruh tarif di mobile**|tidak ada satu pun `Rp`/`formatRp` yang dirender; nilai tarif hanya disimpan di objek trip untuk sinkron & laporan admin|✅|
|**Detail tambahan muncul SETELAH input kendaraan**|`VehicleFormScreen` 2 langkah (`vehicleInputDone`); kartu placeholder sebelum lengkap|✅|
|**Lihat plat yang sudah diinput (diklik)**|kartu “No. Polisi Sudah Diinput” — ketuk untuk detail: plat, jenis, kategori, status plat, wilayah asal, pos, **foto dokumentasi** + tombol “Isi Ulang Form”|✅|
|**Wajib jepret kamera sebelum submit**|tombol galeri dihapus (`capture="environment"`), “Simpan Data Kendaraan” & “Submit Trip” terkunci sampai foto ada|✅|
|**Switch akun pegawai sinkron**|lihat butir B di bawah|✅|

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
    
      
    
- **Baru — tab Pengaturan → “Tema & Tampilan”** (`src/services/theme.ts`): tema Terang/Gelap, Ukuran Font 90–125%, warna aksen (**Biru**/Hitam/Hijau/Ungu/Kuning — Biru default), Reset; persist `localStorage`. Tema diterapkan otomatis saat dashboard dibuka (`applyTheme` di `AdminDashboard`), bukan hanya saat tab Pengaturan dikunjungi.
- **Kelas aksen:** tombol/tab aktif memakai utility `bg-blue-600` / `text-blue-600` / `bg-blue-50` yang di-remap CSS ke `var(--admin-accent)` oleh `html[data-admin][data-accent="…"]` — ganti aksen = seluruh dashboard ikut, tanpa ubah kode.
- **Ikon, bukan emoji:** semua emoji admin diganti lucide (☀️/🌙 → `Sun`/`Moon`, ✓/✕ toast → `Check`/`X`, 📷 → `Camera`).
- **Hierarki visual:** latar halaman admin `bg-slate-50` (off-white), semua kartu/panel `bg-white` + `border-slate-200` + `shadow-sm` — batas antar elemen jelas tanpa kehilangan tampilan minimalis.
    
      
    

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
└─────────────────────────────────────────────────────────────┘
```

## Tech Stack

|**Komponen**|**Teknologi**|**Port**|
|---|---|---|
|Mobile App|Ionic + Capacitor|5173|
|Admin Dashboard|React → Static HTML + CI 2.2.4|4200 / 8000|
|Backend API|Node.js + Express + SQLite|3000|
|Database|SQLite (dev) / MariaDB (prod)|-|

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

  

## Files yang Dibuat/Diubah

### Backend (Node.js)

|**File**|**Change**|
|---|---|
|`backend/src/routes/auth.js`|+member-login, +admin-login, role di JWT|
|`backend/src/db.js`|Fix undefined→null binding|

### Frontend (Ionic)

|**File**|**Change**|
|---|---|
|`src/services/api.ts`|HTTP client + JWT auth|
|`src/services/auth.ts`|Login + token management|
|`src/services/sync.ts`|Queue-based background sync|
|`src/services/trips.ts`|Fetch trips dari backend|
|`src/pages/LoginPage.tsx`|Call memberLogin()|
|`src/environments/*.ts`|Dev & Staging URLs|

### Admin Dashboard (CodeIgniter 2.2.4)

|**File**|**Purpose**|
|---|---|
|`admin-ci/index.php`|Entry point - serve static React|
|`admin-ci/index.html.htaccess`|Client-side routing (SPA)|
|`admin-ci/application/controllers/Admin.php`|Load dashboard|
|`admin-ci/application/controllers/Api.php`|REST API dengan CORS + JSON|

## API Endpoints

|**Method**|**Endpoint**|**Deskripsi**|
|---|---|---|
|POST|`/api/auth/member-login`|Login petugas → JWT|
|POST|`/api/auth/admin-login`|Login admin → JWT|
|POST|`/api/auth/login`|Login PIN (ganti petugas)|
|POST|`/api/auth/refresh`|Terbit ulang JWT dari klaim DB terbaru _(baru 25 Sep)_|
|GET|`/api/health`|Health check|
|GET/POST|`/api/trips`|CRUD trips|
|GET|`/api/trips/:id`|Trip detail|
|POST|`/api/trips/:id/vehicles`|Tambah kendaraan|
|GET|`/api/tariffs`|Master tarif (admin)|
|GET/POST/PUT|`/api/region-tariffs`|Tarif region: lokal/eksternal _(konfigurasi terpusat)_|
|GET/POST|`/api/plates`|Registrasi plat (internal/lokal/eksternal)|
|POST|`/api/plates/check`|Cek status plat (OCR input)|
|GET/POST/PUT/DELETE|`/api/officers`|CRUD petugas (admin)|
|PUT|`/api/officers/:id/regions`|Pindah akses wilayah (many-to-many)|
|PUT|`/api/officers/:id/status`|Aktif/nonaktif petugas|
|GET|`/api/officers/my-region`|Daftar petugas 1 wilayah (token petugas) + `username` _(baru 25 Sep, username 30 Sep)_|
|GET|`/api/regions`|Daftar region|
|GET|`/api/reports/trips`|Laporan rinci dengan vehicles|
|GET|`/api/reports/trips/filters`|Opsi filter golongan & jenis _(baru 25 Sep)_|
|GET|`/api/reports/summary`|Statistik ringkas (admin)|
|GET|`/api/reports/recap`|**Rekap wilayah**: trip lintas petugas digabung per region+dermaga (petugas sbg metadata) _(baru 30 Sep)_|

## 2. Tutorial Teknis Sinkronisasi (Tutorial.md)

# Tutorial Sinkronisasi Data - Penjelasan Teknis

## Arsitektur Sistem

```
┌─────────────────────────────────────────────────────────────┐
│                    MOBILE APP (Ionic)                        │
│  Ionic Framework + Capacitor                               │
│  - Local-first (localStorage)                             │
│  - Sync queue → Backend                                   │
└─────────────────────┬─────────────────────────────────────┘
                      │ HTTP/REST
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    BACKEND API (Node.js)                    │
│  Node.js + Express + SQLite (sql.js)                        │
│  - JWT Authentication                                     │
│  - Trip CRUD                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│               ADMIN DASHBOARD (CodeIgniter 2.2.4)          │
│  PHP + MySQL/MariaDB                                      │
│  - CRUD Tariff                                            │
│  - CRUD Officer                                          │
│  - Laporan                                               │
└─────────────────────────────────────────────────────────────┘
```

## Gambaran Umum

Aplikasi Trip Angkutan bersifat **local-first**: data trip disimpan dulu ke localStorage di perangkat petugas, lalu di-sync ke backend saat ada koneksi internet.

  

## Masalah Awal

```
Login (budi/budi123) → localStorage only → No JWT
                                           ↓
Buat Trip → commitTrip() → addToSyncQueue()
                                           ↓
processSyncQueue() → POST /api/trips → ❌ 401 (no token)
```

### Kenapa Sync Gagal?

1. Login page menggunakan auth lokal (hardcoded username/password)
    
      
    
2. Tidak ada request ke backend untuk dapat JWT token
    
      
    
3. Endpoint POST /trips memerlukan JWT (middleware `authenticate`)
    
      
    
4. Tanpa token → 401 Unauthorized → sync gagal permanen
    
      
    

## Masalah: sql.js undefined binding

sql.js tidak bisa bind `undefined` - harus `null`. Fix di db.js wrapper:

  

JavaScript

```
const safeParams = params.map(p => p === undefined ? null : p);
db.run(sql, safeParams);
```

Tanpa fix ini, CREATE TRIP gagal dengan error:

  

```
Wrong API use: tried to bind a value of an unknown type (undefined)
```

## Solusi: Backend Login Endpoint

### 1. Tambah Endpoint di Backend

**File:** `backend/src/routes/auth.js`

  

JavaScript

```
// Member/officer login dengan username/password
// Maps ke seeded officer: budi=1, andi=2, siti=3, rizky=4, dewi=5
const OFFICER_USERNAME_MAP = {
  'budi': 1,
  'andi': 2,
  'siti': 3,
  'rizky': 4,
  'dewi': 5
};

router.post('/member-login', (req, res) => {
  const { username, password } = req.body;
  // Validasi credentials...
  // Return JWT token + officer data
});
```

### 2. Update Frontend Auth Service

**File:** `src/services/auth.ts`

  

TypeScript

```
// Login petugas ke backend, dapat JWT
export async function memberLogin(username: string, password: string) {
  const result = await api.post<LoginResponse>('/auth/member-login', {
    username, password
  });

  if (result.ok && result.data) {
    api.setToken(result.data.token);  // Simpan JWT
    saveOfficer(result.data.officer);
    return { success: true };
  }
  return { success: false };
}

// Auto-refresh JWT sebelum sync
export async function ensureBackendSession(): Promise<boolean> {
  if (api.isAuthenticated) return true;
  const stored = getStoredOfficer();
  if (!stored) return false;
  const result = await loginWithPin(stored.id, DEMO_PIN);
  return result.success;
}
```

### 3. Integrate dengan Login Page

**File:** `src/pages/LoginPage.tsx`

  

TypeScript

```
const handleLogin = async () => {
  // 1. Validasi credentials lokal
  if (username === creds.username && password === creds.password) {
    setLoading(true);

    // 2. Untuk member, juga dapat JWT dari backend
    if (userType === 'member') {
      await memberLogin(username, password);
    }

    // 3. Masuk app
    onLogin(userType);
  }
};
```

## Alur Sinkronisasi Lengkap

```
┌─────────────────────────────────────────────────────────────┐
│ 1. LOGIN                                                  │
│    LoginPage → memberLogin() → POST /auth/member-login     │
│    ← JWT token + officer data                              │
│    JWT disimpan di api.token + localStorage               │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. BUAT TRIP                                              │
│    Route Select → Vehicle Form → Camera → Trip Summary      │
│    → commitTrip() → addToSyncQueue(trip)                  │
│    Trip tersimpan di localStorage + queue                 │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. SELESAI TRIP                                           │
│    TripCompleteScreen mount → processSyncQueue()          │
│    → POST /api/trips (Authorization: Bearer <JWT>)        │
│    ← 201 Created                                         │
│    → hapus dari queue                                    │
└─────────────────────────────────────────────────────────────┘
```

## File Services

### src/services/api.ts

- HTTP client wrapper dengan fetch
    
      
    
- Auto-set Authorization header
    
      
    
- Error handling
    
      
    

### src/services/auth.ts

- `memberLogin()` - Login petugas
    
      
    
- `loginWithPin()` - Login dengan PIN
    
      
    
- `ensureBackendSession()` - Auto JWT refresh
    
      
    
- Token persistence di localStorage
    
      
    

### src/services/sync.ts

- `addToSyncQueue()` - Tambah trip ke queue
    
      
    
- `processSyncQueue()` - Proses semua pending trips
    
      
    
- `getPendingCount()` - Hitung trip belum sync- Auto-retry max 3x
    
      
    - **Auto-push saat kembali online** — `handleReconnect()` (event `online`, listener native Capacitor Network, polling pengaman 15 dtk) memberi jatah percobaan baru lalu flush seluruh antrean tanpa intervensi user
    
      
    - Online/offline detection
    
      
    - **Prefetch petugas saat login online** (`store.tsx` → `refreshOfficers(true)`) — daftar rekan sekawasan disimpan ke `trip.officers.v1` agar layar Ganti Petugas tetap berfungsi offline; ditarik ulang otomatis tiap koneksi pulih
    
      