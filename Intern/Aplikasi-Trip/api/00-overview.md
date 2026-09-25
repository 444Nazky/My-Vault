# API Documentation Overview

> **Status:** disesuaikan dengan backend aktual — 25 September 2026
> Implementasi: **Node.js + Express + SQLite (sql.js)** · `backend/src/`

## Base URL
```
Development : http://localhost:3000/api
Staging     : https://192.168.1.2/api        (lihat src/environments/)
```

## Authentication
- **JWT** (HS256, secret `JWT_SECRET` / default `trip-angkut-secret-key`), masa berlaku **24 jam**
- Dua peran: `role: 'officer'` (klaim `officerId`, `regionId`) dan `role: 'admin'` (klaim `username`)
- Middleware: `authenticate` (wajib token) → `requireAdmin` (hanya admin)
- Bearer token di header: `Authorization: Bearer <token>`

## Response Format
- Sukses: objek/array langsung, contoh `[{...}]` atau `{ token, officer }`
- Error: `{ "error": "pesan manusiawi" }` dengan status 400/401/403/404/500

---

## Endpoint Groups

### Auth (`/auth`)
| Method | Endpoint | Akses | Deskripsi |
|--------|----------|-------|-----------|
| POST | `/auth/admin-login` | publik | Login admin `{username, password}` → JWT admin |
| POST | `/auth/member-login` | publik | Login petugas `{username, password}` → JWT officer |
| POST | `/auth/login` | publik | Login PIN `{officerId, pin}` → JWT officer — **ditolak 401 bila Nonaktif** |
| POST | `/auth/refresh` | officer | Terbit ulang JWT dari **klaim DB terbaru** (wilayah & status ikut terbaru) tanpa PIN — 401 bila akun nonaktif |
| GET | `/auth/verify` | token | Validasi token + info officer |
| GET | `/auth/officers/:regionCode` | publik | Daftar petugas aktif per region |

### Trips (`/trips`)
| Method | Endpoint | Akses | Deskripsi |
|--------|----------|-------|-----------|
| POST | `/trips` | officer | Buat trip (petugas melihat region sendiri, admin semua) |
| GET | `/trips` | officer/admin | Daftar trip |
| GET | `/trips/:id` | officer/admin | Detail trip + kendaraan |
| POST | `/trips/:id/vehicles` | officer | Tambah kendaraan (tarif dihitung server dari master tarif) |

### Vehicles (`/vehicles`)
| Method | Endpoint | Akses | Deskripsi |
|--------|----------|-------|-----------|
| GET | `/vehicles` | admin | Daftar kendaraan (100 terbaru) |

### Master Tarif (`/tariffs`)
| Method | Endpoint | Akses | Deskripsi |
|--------|----------|-------|-----------|
| GET/POST/PUT/DELETE | `/tariffs[/:id]` | admin | CRUD master tarif (golongan, jenis, muatan/kosong) |

### Tarif Region — konfigurasi terpusat (`/region-tariffs`)
| Method | Endpoint | Akses | Deskripsi |
|--------|----------|-------|-----------|
| GET | `/region-tariffs` | admin | Semua region + `lokal_tariff`, `lokal_active`, `eksternal_tariff`, `eksternal_active` |
| PUT | `/region-tariffs/:regionId` | admin | Simpan `{tariffType: 'lokal'\|'eksternal', nominalTariff, isActive}` |

> Aturan: **Internal = 0 · Lokal = cadangan/bisa diubah (saat ini 0) · Eksternal = tarif region.** Perubahan cukup lewat admin, tanpa ubah kode.

### Registrasi Plat (`/plates`)
| Method | Endpoint | Akses | Deskripsi |
|--------|----------|-------|-----------|
| GET/POST/PUT/DELETE | `/plates[/:id]` | admin | CRUD plat (nomor, pemilik, region asal, status) |
| POST | `/plates/check` | token | Cek status plat `{plate, originRegionId?}` → `internal` (tarif 0) / `lokal` (konfigurasi lokal pos) / `eksternal` (tarif region) |

### Petugas (`/officers`) — many-to-many via `officer_regions`
| Method | Endpoint | Akses | Deskripsi |
|--------|----------|-------|-----------|
| GET | `/officers` | admin | Semua petugas + daftar `regions[]` (fallback kolom lama) |
| GET | `/officers/my-region` | **officer** | Petugas yang **berbagi ≥1 wilayah** dengan peminta (dipakai layar Ganti Petugas) |
| POST | `/officers` | admin | Buat petugas (`regionIds[]` → junction) |
| PUT | `/officers/:id/regions` | admin | **Pindah/atur akses wilayah** (ganti seluruh junction + `region_id` pertama) |
| PUT | `/officers/:id/pin` | admin | Ganti PIN (bcrypt) |
| PUT | `/officers/:id/status` | admin | **Aktif/Nonaktif** `{isActive}` |
| DELETE | `/officers/:id` | admin | Hapus petugas + junction |

### Regions (`/regions`)
| Method | Endpoint | Akses | Deskripsi |
|--------|----------|-------|-----------|
| GET | `/regions` | token | Daftar region |
| POST | `/regions` | admin | Tambah region |

### Reports (`/reports`) — admin-only
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/reports/summary` | Statistik ringkas (filter tanggal/region) |
| GET | `/reports/trips` | Laporan rinci: `route_from_name`, `route_to_name`, jam **WIB**, kendaraan per trip; filter `startDate`, `endDate`, `golongan`, `vehicleType` |
| GET | `/reports/trips/filters` | Opsi filter **golongan & jenis kendaraan** (dari master tarif) |
| GET | `/reports/trips/export` | Export server-side (fallback) |

> Ekspor Excel utama dilakukan di klien (`src/services/xlsx.ts`) — 2 sheet, tanpa dependency tambahan.

### Health
| GET | `/health` | publik | Health check |

---

## Catatan Kompatibilitas
- ID petugas lama (`"1".."5"`) dan UUID baru keduanya didukung — selalu dikirim/kembalikan sebagai **string**.
- `officer_regions` adalah sumber kebenaran wilayah; kolom `officers.region_id` dipertahankan untuk klaim JWT & fallback baris lama.
- sql.js tidak bisa bind `undefined` → wrapper `db.js` mengonversi ke `null`.
