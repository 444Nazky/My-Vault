# Database Schema Overview

> **Status:** disesuaikan dengan schema aktual — 25 September 2026
> Engine: **SQLite** (`backend/data/trip.db`) via **sql.js** — wrapper `backend/src/db.js` (mengonversi bind `undefined` → `null`).

## Entity Relationship

```
regions (1) -----> (N) officers
regions (1) <-----> (N) officers        [junction: officer_regions — many-to-many]
regions (1) -----> (N) trips
regions (1) -----> (N) region_tariffs   [tarif lokal/eksternal per region — konfigurasi terpusat]
regions (1) -----> (N) vehicle_plates   [registrasi plat: region asal]
officers (1) ----> (N) trips
trips (1) --------> (N) trip_vehicles
vehicles (1) -----> (N) trip_vehicles
tariffs (1) -------> (N) vehicles      [tariff_id saat tarif dihitung server]
```

## Tables (aktual)

### regions
| Kolom | Tipe | Deskripsi |
|-------|------|-----------|
| id | TEXT PK | UUID region |
| name | TEXT UNIQUE | Nama region (Badau, Entikong, …) |
| code | TEXT UNIQUE | Kode singkatan (BADAU, ENTIKONG, SBDZ, SJRE) |
| created_at | DATETIME | Waktu buat |

> Catatan alias: kode rute `BDAU` dipetakan ke region `BADAU` saat laporan dibuat.

### officers
| Kolom | Tipe | Deskripsi |
|-------|------|-----------|
| id | TEXT PK | `"1".."5"` (legacy) atau UUID |
| name | TEXT | Nama petugas |
| pin | TEXT | Hash **bcrypt** PIN |
| region_id | TEXT FK | Region utama = klaim JWT (region pertama bila multi) |
| is_active | INTEGER | **1 = Aktif, 0 = Nonaktif** (login & refresh ditolak bila 0) |
| created_at | DATETIME | Waktu buat |

### officer_regions (junction many-to-many)
| Kolom | Tipe | Deskripsi |
|-------|------|-----------|
| officer_id | TEXT FK | → officers |
| region_id | TEXT FK | → regions |

> Sumber kebenaran akses wilayah petugas. Baris lama tanpa junction fallback ke `officers.region_id`.

### tariffs (master tarif — dikelola admin)
| Kolom | Tipe | Deskripsi |
|-------|------|-----------|
| id | TEXT PK | UUID |
| golongan | TEXT | Golongan (mis. Eksternal, angka romawi untuk baris lama) |
| vehicle_type | TEXT | Jenis kendaraan (Truck Besar, Motor, …) |
| loaded_tariff | INTEGER | Tarif dengan muatan |
| empty_tariff | INTEGER | Tarif tanpa muatan |
| is_active | INTEGER | 1 = aktif |
| description | TEXT | Keterangan |
| created_at | DATETIME | Waktu buat |

### region_tariffs (konfigurasi tarif terpusat — tanpa ubah kode)
| Kolom | Tipe | Deskripsi |
|-------|------|-----------|
| id | TEXT PK | UUID |
| region_id | TEXT FK | Region |
| tariff_type | TEXT | `lokal` / `eksternal` |
| nominal_tariff | INTEGER | Nominal (lokal default **0** = cadangan, bisa diubah) |
| is_active | INTEGER | Status aktif |

> Aturan: **Internal = 0** (via `vehicle_plates.status='internal'`), **Lokal = cadangan/bisa diubah**, **Eksternal = tarif region**.

### vehicle_plates (registrasi plat)
| Kolom | Tipe | Deskripsi |
|-------|------|-----------|
| id | TEXT PK | UUID |
| plate | TEXT | Nomor plat |
| owner | TEXT | Pemilik (opsional) |
| origin_region_id | TEXT FK | Region asal |
| status | TEXT | `internal` / `lokal` / `eksternal` |
| is_active | INTEGER | Status aktif plat |
| created_at | DATETIME | Waktu registrasi |

### plate_scans (riwayat cek/scanning plat)
| Kolom | Tipe | Deskripsi |
|-------|------|-----------|
| id | TEXT PK | UUID |
| plate | TEXT | Plat terbaca (hasil OCR/manual) |
| status | TEXT | Status hasil cek |
| origin_region_id | TEXT FK | Region asal kendaraan |
| checkpoint_region_id | TEXT FK | Region pos pemeriksaan |
| tariff_amount | INTEGER | Tarif yang dikenakan |
| officer_id | TEXT FK | Petugas pemeriksa |
| created_at | DATETIME | Waktu scan |

### trips
| Kolom | Tipe | Deskripsi |
|-------|------|-----------|
| id | TEXT PK | UUID |
| no_trip | TEXT | Nomor trip **`TRP-YYYY-NNNN`** |
| officer_id | TEXT FK | Petugas pembuat |
| region_id | TEXT FK | Region trip |
| status_muatan | TEXT | `muatan` / `kosong` |
| route_from / route_to | TEXT | Kode rute (trip kosong = SJRE → SBDZ) |
| keterangan | TEXT | Keterangan trip |
| foto_kosong_path | TEXT | Foto bukti (kamera) |
| is_synced | INTEGER | Penanda sinkron |
| created_at | DATETIME | Waktu buat |

### vehicles
| Kolom | Tipe | Deskripsi |
|-------|------|-----------|
| id | TEXT PK | UUID |
| no_polisi | TEXT | Nomor polisi |
| vehicle_type | TEXT | Jenis kendaraan |
| golongan | TEXT | Kategori/golongan |
| trip_id | TEXT FK | Trip pemilik |
| has_load | INTEGER | 1 = ada muatan |
| tariff_id | TEXT FK | Master tarif yang dipakai (null bila fallback) |
| tariff_amount | INTEGER | Tarif (dihitung **server** dari master tarif + tarif region) |
| foto_path | TEXT | Foto dokumentasi |
| latitude / longitude | TEXT | Koordinat (belum dipakai) |
| created_at | DATETIME | Waktu buat |

### trip_vehicles (junction trip ↔ kendaraan)
| Kolom | Tipe | Deskripsi |
|-------|------|-----------|
| id | TEXT PK | UUID |
| trip_id | TEXT FK | → trips |
| vehicle_id | TEXT FK | → vehicles |
| created_at | DATETIME | Waktu |

---

## Catatan Implementasi
- **Tabel lama vs terbaru:** dokumen desain awal menyebut `users`/`trip_kendaraan` — nama aktualnya `officers`/`vehicles` + junction `trip_vehicles`.
- ID dikirim sebagai **string** (mendukung ID legacy & UUID).
- sql.js menulis seluruh file DB setiap mutasi (`saveDb()`).
