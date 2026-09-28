# Fix — Master Rute Wilayah & Login Region (Revisi #3 & #4)

> **Tanggal:** 28 September 2026 · **Status:** selesai & terverifikasi E2E

## Masalah

- Layar **Pilih Rute** mobile memakai data statis `ROUTES` di `src/pages/data.ts` — hasil edit Master Rute admin tidak pernah terlihat petugas.
- Seed backend punya rute placeholder sisa (`A → B`, `C → D`) di dermaga Badau D1 yang tidak ada di spesifikasi.
- Login masih per-karyawan (`budi/123456`), bukan per-wilayah sesuai revisi.

## Perbaikan

### Backend
1. **`backend/src/db.js` — sinkron seed Master Rute**
   Blok khusus `BADAU D2` diganti jadi pembersihan umum: untuk tiap dermaga wilayah spec, rute yang **tidak ada di spesifikasi** dihapus — kecuali masih direferensikan `trips.route_id` (supaya laporan lama tak kehilangan relasi).
   Hasil: **12 rute persis** sesuai spec (Badau 4, Belitung 4, Kelapa Kampit 4). Sisa `A→B` hanya di region lama (Sabadi/Sijangkung/Entikong) di luar spec.

2. **`backend/src/routes/routes.js` — endpoint baru `GET /api/routes/mine`**
   Rute milik petugas yang sedang login (via `officer_dermagas`), tanpa `requireAdmin` (cukup JWT officer). Dipakai mobile agar hasil edit admin langsung terpakai.

### Mobile
3. **`src/pages/data.ts`** — helper `activeRoutes()`: pakai rute dari login backend (`getStoredRoutes()`), fallback statis bila belum pernah login.
4. **`src/pages/mobile/RouteSelectScreen.tsx`** — muat rute + `refreshStoredRoutes()` saat layar dibuka; trip **kosong tetap terkunci** `SJRE → SBDZ` (fallback statis kalau dermaga petugas tak punya rute itu).
5. **`TripSummaryScreen` / `TripActiveScreen`** — pakai `activeRoutes()`; guard durasi/jarak kosong (`Math.max(..., 60)`) supaya progress/ETA tidak `NaN`.
6. **`src/services/auth.ts`** — `refreshStoredRoutes()` → simpan ulang map rute per dermaga.

### Admin
7. **Tab baru "Master Rute"** (`AdminDashboard.tsx`): tabel Wilayah · Dermaga · Nama Rute · Asal · Tujuan · Jarak · Durasi · Aksi; form tambah/edit rute; nama rute bisa diubah dinamis (sesuai spec §Pengaturan Admin).

## Verifikasi E2E (Chromium CDP)

| Uji | Hasil |
|---|---|
| Login region BADAU/badau123 → Budi Santoso → PIN 123456 | ✅ masuk dashboard |
| Layar Pilih Rute tampilkan rute backend (SJRE→SBDZ, SBDZ→SJRE) | ✅ |
| `GET /routes/mine` | ✅ **200** (204 hanya preflight OPTIONS) |
| Trip kosong → rute terkunci 1 baris `SJRE → SBDZ` | ✅ |
| Tab Master Rute: 15 baris, header lengkap | ✅ |
| Admin ubah nama rute → reload → **persist di server** | ✅ |
| Admin ubah nama → **mobile langsung memakainya tanpa re-login** | ✅ |
| `tsc` 0 error · `ng lint` pass · `ng build` sukses · `www/`→`admin-ci/` sinkron | ✅ |

## Pelajaran

- Menambah endpoint backend **wajib restart backend** — proses Node tidak hot-reload (gejala: 404 padahal kode sudah ada).
- Seed idempoten "tambah jika belum ada" tidak pernah **menghapus** data lama; perlu blok pembersihan eksplisit.
