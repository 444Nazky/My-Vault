# API Reference

> **Base URL:** `http://localhost:3000/api`
> **Auth:** Bearer token (JWT HS256, 24 jam)

## Auth

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/auth/admin-login` | Login admin `{username, password}` |
| POST | `/auth/member-login` | Login petugas `{username, password}` |
| POST | `/auth/login` | Login PIN `{officerId, pin}` → 401 jika Nonaktif |
| POST | `/auth/refresh` | Refresh JWT dari DB terbaru |
| GET | `/auth/verify` | Validasi token |

## Trips

| Method | Endpoint | Akses | Deskripsi |
|--------|----------|-------|-----------|
| POST | `/trips` | officer | Buat trip |
| GET | `/trips` | officer/admin | Daftar trip |
| GET | `/trips/:id` | officer/admin | Detail trip + kendaraan |
| POST | `/trips/:id/vehicles` | officer | Tambah kendaraan |

## Master Data (Admin)

| Resource | Endpoints |
|----------|-----------|
| Tariff | `GET/POST/PUT/DELETE /tariffs` |
| Region Tariff | `GET /region-tariffs`, `PUT /region-tariffs/:id` |
| Plates | `GET/POST/PUT/DELETE /plates`, `POST /plates/check` |
| Officers | `GET /officers`, `POST /officers` |
| Regions | `GET /regions`, `POST /regions` |

## Officer Management

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| PUT | `/officers/:id/status` | Aktif/Nonaktif |
| PUT | `/officers/:id/regions` | Pindah akses wilayah |
| PUT | `/officers/:id/pin` | Ganti PIN |
| GET | `/officers/my-region` | Petugas satu wilayah |
| DELETE | `/officers/:id` | Hapus petugas |

## Reports (Admin)

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/reports/summary` | Statistik ringkas |
| GET | `/reports/trips` | Laporan trip (filter: date, golongan, vehicleType) |
| GET | `/reports/trips/filters` | Opsi filter |
| GET | `/reports/trips/export` | Export CSV (fallback) |

## Response Format

```json
// Sukses
{ "token": "...", "officer": {...} }

// Error
{ "error": "Pesan kesalahan" }
```

## Catatan
- ID petugas lama (`"1".."5"`) dan UUID baru didukung
- sql.js tidak bind `undefined` → dikonversi ke `null`
