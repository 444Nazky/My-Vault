# Admin Dashboard

## Akses
```
http://localhost:8000
```
> Disajikan via CodeIgniter (`admin-ci/`), bukan Ionic.

## Tab & Fitur

### 1. Dashboard
- Statistik ringkas (total trip, kendaraan, tanggal)

### 2. Master Tarif
- CRUD tarif (golongan, jenis, muatan/kosong)
- **Tarif Region** (kartu):
  - Internal = 0
  - Lokal = cadangan (bisa diubah tanpa ubah kode)
  - Eksternal = tarif per region

### 3. Master Plat
- CRUD registrasi plat
- Status: Internal / Lokal / Eksternal
- Cek status via `POST /plates/check`

### 4. Petugas
- CRUD petugas
- **Aktif/Nonaktif** (`PUT /officers/:id/status`)
- **Pindah Region** (`PUT /officers/:id/regions`)
- Ganti PIN (`PUT /officers/:id/pin`)

### 5. Laporan
- Filter: tanggal, golongan, jenis kendaraan
- Detail tempat + jam WIB
- **Ekspor Excel (.xlsx)** — 2 sheet

### 6. Pengaturan (Tema)
- Tema: Terang / Gelap
- Ukuran Font: 90% / 100% / 110% / 125%
- Warna Aksen: Biru / Hijau / Ungu / Kuning
- Reset

## Struktur Backend

```
admin-ci/
├── index.php    # entry CodeIgniter
├── www/         # React build (sinkron dari src/)
└── data/        # SQLite database
```

## Build Mobile → Admin

```bash
npm run build          # output → www/
# otomatis sinkron ke admin-ci/www/
```
