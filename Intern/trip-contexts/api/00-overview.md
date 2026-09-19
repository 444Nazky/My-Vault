# API Documentation Overview

## Base URL
```
Production: https://api.tripangkut.com/v1
```

## Authentication
- Bearer Token dari Firebase Custom Token
- Token expires dalam 7 hari

## Common Headers
```
Content-Type: application/json
Authorization: Bearer <token>
```

## Response Format

### Success
```json
{
  "success": true,
  "data": { ... }
}
```

### Error
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message"
  }
}
```

## Endpoint Groups

### Auth
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | /auth/login | Login dengan PIN |
| POST | /auth/refresh | Refresh token |

### Trips
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | /trips | Daftar trip |
| POST | /trips | Buat trip baru |
| GET | /trips/{id} | Detail trip |
| PUT | /trips/{id}/complete | Selesaikan trip |

### Vehicles
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | /trips/{id}/vehicles | Tambah kendaraan |
| GET | /trips/{id}/vehicles | Daftar kendaraan |

### Reports
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | /reports/summary | Ringkasan laporan |
| GET | /reports/daily | Laporan harian |
| GET | /reports/export | Export laporan |

### Admin
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET/POST | /admin/users | Manajemen user |
| GET/POST | /admin/tariffs | Manajemen tarif |
| GET/POST | /admin/regions | Manajemen region |
