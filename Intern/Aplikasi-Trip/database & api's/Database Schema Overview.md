> **Status:** disesuaikan dengan schema aktual — 25 September 2026
> Engine: **SQLite** (`backend/data/trip.db`) via **sql.js** — wrapper `backend/src/db.js` (mengonversi bind `undefined` → `null`).

## Entity Relationship

```
regions (1) -----> (N) officers
regions (1) <-----> (N) officers        [junction: officer_regions — many-to-many]
regions (1) -----> (N) dermagas         [D1, D2 per wilayah]
dermagas (1) -----> (N) routes          [Master Rute — Revisi #3]
dermagas (1) <-----> (N) officers       [junction: officer_dermagas — akses rute petugas]
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
| password | TEXT | **bcrypt** password wilayah untuk login 2 langkah (Revisi #4). Default `<kode>123`, mis. `BADAU` → `badau123` — bisa diganti tanpa ubah kode |
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

### dermagas (dermaga per wilayah — Revisi #3)
| Kolom | Tipe | Deskripsi |
|-------|------|-----------|
| id | TEXT PK | UUID |
| region_id | TEXT FK | → regions |
| name | TEXT | Nama dermaga (Dermaga 1, Dermaga 2) |
| code | TEXT | `D1` / `D2` (unik per region) |
| created_at | DATETIME | Waktu buat |

### officer_dermagas (junction petugas ↔ dermaga — banyak-ke-banyak)
| Kolom | Tipe | Deskripsi |
|-------|------|-----------|
| officer_id | TEXT FK | → officers |
| dermaga_id | TEXT FK | → dermagas |

> Menentukan rute apa yang dilihat petugas di layar Pilih Rute (`GET /routes/mine`)
> dan dermaga bawaan saat submit trip. Satu petugas bisa lebih dari satu dermaga
> (mis. Dewi Kusuma: D1 + D2).

### routes (Master Rute — Revisi #3, dikelola dinamis dari tab admin)
| Kolom | Tipe | Deskripsi |
|-------|------|-----------|
| id | TEXT PK | UUID |
| dermaga_id | TEXT FK | → dermagas |
| name | TEXT | Nama rute — **bisa diganti admin** tanpa ubah kode (mis. "Sijangkung → Sabadi") |
| route_from | TEXT | Kode asal (SJRE, AAAA, …) — jadi `routeCode` di mobile |
| route_to | TEXT | Kode tujuan |
| distance | TEXT nullable | Jarak (mis. "42 km"); kosong = tampil `—` |
| duration | TEXT nullable | Durasi (mis. "1j 10m"); kosong = progress ETA default 60 dtk |
| created_at | DATETIME | Waktu buat |

> Seed mengisi **tepat 12 rute** sesuai spesifikasi (3 wilayah × 2 dermaga × 2 arah)
> dan **menghapus rute placeholder** di dermaga spec kecuali masih dipakai `trips.route_id`.

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
| dermaga_id | TEXT FK **nullable** | Dermaga terkait. Diisi **otomatis oleh server** dari penugasan petugas (`officer_dermagas`) → dermaga region → `null`. Kolom ini awalnya `NOT NULL` padahal klien mobile tak pernah mengirimnya → setiap `POST /trips` gagal 500 (diperbaiki 25 Sep: derive server-side + migrasi jadi nullable) |
| route_id | TEXT FK nullable | Rute terpilih (opsional) |
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
