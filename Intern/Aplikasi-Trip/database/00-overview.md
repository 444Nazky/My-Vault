# Database Schema Overview

## Entity Relationship

```
users (1) -----> (N) trips
regions (1) ----> (N) users
regions (1) ----> (N) trips
trips (1) ------> (N) trip_kendaraan
tariffs (1) ----> (N) trip_kendaraan
```

## Tables

### users
| Kolom | Tipe | Deskripsi |
|-------|------|----------|
| id | PK | Identifier unik |
| nama | VARCHAR | Nama lengkap petugas |
| pin_hash | VARCHAR | Hash SHA-256 dari PIN 6 digit |
| region_id | FK | Region tempat petugas bertugas |
| device_id | VARCHAR | IMEI atau UUID perangkat |
| created_at | TIMESTAMP | Waktu registrasi |

### regions
| Kolom | Tipe | Deskripsi |
|-------|------|----------|
| id | PK | Identifier unik |
| nama | VARCHAR | Nama region |
| kode | VARCHAR | Kode singkatan |
| batas_lat_min/max | DECIMAL | Batas latitude |
| batas_lng_min/max | DECIMAL | Batas longitude |

### tariffs
| Kolom | Tipe | Deskripsi |
|-------|------|----------|
| id | PK | Identifier unik |
| golongan | VARCHAR | Internal / Eksternal / Lokal |
| jenis_kendaraan | VARCHAR | Truk / Mobil / Motor |
| tarif_muatan | INTEGER | Tarif dengan muatan |
| tarif_tanpa_muatan | INTEGER | Tarif tanpa muatan |

### trips
| Kolom | Tipe | Deskripsi |
|-------|------|----------|
| id | PK | Identifier unik |
| no_trip | VARCHAR | Nomor trip (TRP-DDMMYY-SEQ) |
| user_id | FK | Petugas yang membuat |
| region_id | FK | Region trip dilakukan |
| rute | VARCHAR | Kode rute |
| status_muatan | VARCHAR | Ada Muatan / Kosong |
| start_lat/lng | DECIMAL | Koordinat awal |
| end_lat/lng | DECIMAL | Koordinat akhir |
| created_at | TIMESTAMP | Waktu mulai |
| completed_at | TIMESTAMP | Waktu selesai |

### trip_kendaraan
| Kolom | Tipe | Deskripsi |
|-------|------|----------|
| id | PK | Identifier unik |
| trip_id | FK | Trip header |
| kendaraan_ke | INTEGER | Urutan kendaraan |
| golongan | VARCHAR | Golongan kendaraan |
| jenis_kendaraan | VARCHAR | Truk / Mobil / Motor |
| muatan | VARCHAR | Dengan / Tanpa Muatan |
| no_polisi | VARCHAR | Nomor polisi |
| foto_selfie_url | VARCHAR | URL foto selfie |
| tarif | INTEGER | Nilai tarif |
| lat/lng | DECIMAL | Koordinat saat foto |
