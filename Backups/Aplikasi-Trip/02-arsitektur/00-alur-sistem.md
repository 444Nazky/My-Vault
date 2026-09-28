# Alur Sistem

## Overview

```
Mobile App (React)          Backend (Express)         SQLite
    │                            │                      │
    ├── Login PIN ─────────────>│── bcrypt+JWT ───────>│ officers
    │<── token + daftar petugas<│                      │
    │                            │                      │
    ├── Pilih muatan → rute ────>│ (lokal di store)     │
    ├── Foto + input kendaraan ─>│ (lokal, sync queue)  │
    │                            │                      │
    ├── Sync queue ────────────>│── INSERT trips ────>│ trips
    │                            │── INSERT vehicles ──>│ vehicles
    │<── 201 / error ──────────<│                      │
    │                            │                      │
Admin (React)                  │                      │
    ├── GET /reports ─────────>│── JOIN ────────────>│
    |<── data + nama tempat ───<│                      │
    ├── Ekspor .xlsx ──────────>│ (client-side)       │
```

## Alur Trip

1. **Login** → PIN / username+password → JWT
2. **Mulai Trip** → pilih status muatan
   - Kosong → rute dikunci SJRE → SBDZ
   - Ada Angkutan → rute bebas
3. **Input Kendaraan** → 2 langkah:
   - Langkah 1: Plat nomor (OCR) + Jenis
   - Langkah 2: Kategori + Foto kamera wajib
4. **Submit Trip** → terkunci tanpa foto
5. **Sync** → `POST /trips` + `POST /trips/:id/vehicles`

## Region & Rute

| Kode | Nama |
|------|------|
| BADAU | Badau |
| SJRE | Sijangkung |
| SBDZ | Sabadi |
| ENTIKONG | Entikong |

> Alias: `BDAU` (mobile) → `BADAU` (database)

## Aturan Tarif

| Status Plat | Tarif |
|-------------|-------|
| Internal | 0 |
| Lokal | Cadangan (saat ini 0) |
| Eksternal | Sesuai region |
