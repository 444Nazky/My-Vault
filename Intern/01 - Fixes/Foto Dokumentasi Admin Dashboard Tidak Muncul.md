# Fix — Foto Dokumentasi Tidak Muncul di Dashboard Admin

> **Tanggal:** 30 September 2026 · **Status:** selesai & terverifikasi E2E
> **Gejala:** kolom/expandable card di Laporan Trip hanya menampilkan "Tidak ada foto",
> ikon foto rusak, dan modal *Foto (N)* kosong — padahal petugas sudah mengirim dokumentasi.

## Akar Penyebab (2)

### 1. Folder upload terpisah → semua foto 404
Dua perintah memakai path yang **berbeda**:

| Komponen | File | Path yang dipakai |
|---|---|---|
| Static server (`/uploads`) | `backend/src/index.js` | `backend/uploads` |
| Multer (terima foto) | `backend/src/routes/trips.js` & `upload.js` | `backend/src/uploads` ❌ |

Akibatnya 25 file foto menumpuk di `backend/src/uploads` sementara server
menyajikan `backend/uploads` yang **kosong** → setiap `<img>` 404.

### 2. `import.meta.env` di build Angular → dashboard blank
`ReportSheet.tsx` memakai gaya Vite:

```ts
const BASE_URL = (import.meta as any).env.VITE_API_URL || 'http://localhost:3001'
```

Angular (`@angular/build` esbuild) **tidak mendefinisikan** `import.meta.env` →
`TypeError: Cannot read properties of undefined (reading 'VITE_API_URL')` di awal
pemuatan modul → seluruh React app gagal render (`#root` kosong).
Port fallback `3001` juga salah (backend di **3000**).

## Perbaikan

| File | Perubahan |
|---|---|
| `backend/src/uploads-dir.js` *(baru)* | Konstanta tunggal `UPLOADS_DIR` = `backend/uploads` (+ `mkdirSync`) |
| `backend/src/index.js` | Static server memakai `UPLOADS_DIR`; `fs`/`path` yang tak terpakai dibuang |
| `backend/src/routes/trips.js` | Multer `destination` → `UPLOADS_DIR` |
| `backend/src/routes/upload.js` | Multer `destination` → `UPLOADS_DIR` |
| 25 file foto | Dipindah `backend/src/uploads/` → `backend/uploads/` (ikut ter-commit) |
| `src/pages/admin/ReportSheet.tsx` | `BASE_URL` dihapus → `fotoUrl()` memakai `resolvePhotoUrl(path, getApiBaseUrl())` |

> `resolvePhotoUrl('/uploads/x.jpg', 'http://localhost:3000/api')`
> → `http://localhost:3000/uploads/x.jpg` (asal server API, **bukan** di bawah `/api`).

## Verifikasi

| Uji | Hasil |
|---|---|
| 25 foto di DB → `GET :3000/uploads/...` | **25/25 → 200 image/jpeg** |
| Round-trip `POST /api/upload` → `GET` hasilnya | 200 image/jpeg (file uji dibersihkan) |
| E2E Laporan: expand baris ber-unit | kartu terbuka, "Foto bukti trip", tabel plat/jenis/kategori, **2/2 thumbnail termuat** |
| Lightbox (klik thumbnail) | terbuka, gambar termuat, caption `TRP… · Bukti trip` |
| Tombol **Foto (25)** | modal galeri **25/25 foto termuat** |
| Spreadsheet `#/sheet` → tab *Detail Kendaraan* | **13/13 thumbnail** + lightbox OK, tanpa exception |
| `npx tsc --noEmit` · `ng lint` | 0 error · all files pass |
| Admin watch (`npm run dev:admin`) | rebuild → sync → bundle basi ter-prune otomatis |

## Catatan data

Riwayat trip sempat dikosongkan oleh `./clear-trip-history.sh` (30 Sep 09:21–09:23)
**bukan** oleh perbaikan ini. Data dipulihkan dari
`data/backups/trip_backup_20260930_092125.db` (34 trip / 54 kendaraan).
Untuk mengosongkan lagi: `./clear-trip-history.sh`.

Terkait: [[../02 - Mistakes/Path Uploads Terpisah dan Gaya Vite di Build Angular]] · [[tr]]
