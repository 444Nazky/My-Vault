# Mobile App

## Struktur Proyek

```
src/
├── pages/
│   ├── LoginPage.tsx
│   ├── store.tsx          # context (draft trip, petugas, tarif)
│   ├── data.ts            # rute statis, master tarif
│   ├── types.ts
│   ├── mobile/
│   │   ├── HomeScreen.tsx
│   │   ├── TripConditionScreen.tsx  # pilih muatan
│   │   ├── RouteSelectScreen.tsx    # pilih rute
│   │   ├── VehicleFormScreen.tsx    # input kendaraan 2 langkah
│   │   ├── CameraScreen.tsx         # wajib kamera
│   │   ├── TripSummaryScreen.tsx    # submit
│   │   ├── HistoryScreen.tsx
│   │   ├── ProfileScreen.tsx
│   │   └── OfficerSwitchScreen.tsx  # ganti petugas
│   └── admin/
│       └── AdminDashboard.tsx
└── services/
    ├── api.ts              # HTTP client
    ├── auth.ts             # login, refresh
    ├── sync.ts             # offline queue
    ├── officers.ts         # daftar petugas
    └── ocr.ts              # baca plat
```

## Alur Utama

### 1. Login
1. Pilih role: Admin / Petugas
2. Admin: username + password
3. Petugas: ID + PIN 6 digit

### 2. Mulai Trip
1. **Pilih status muatan dulu:**
   - Kosong/Tidak Ada Muatan → rute dikunci SJRE → SBDZ
   - Ada Angkutan → rute bebas
2. Pilih rute → trip dibuat

### 3. Input Kendaraan (2 Langkah)
**Langkah 1:** Plat nomor (+ scan OCR) + Jenis kendaraan
**Langkah 2:** Kategori + Foto kamera (WAJIB, galeri dimatikan)

### 4. Submit
- Tombol terkunci sampai foto ada
- Simpan → sync queue
- Offline: data tersimpan lokal
- Online: langsung kirim ke server

## Fitur Utama

- **OCR plat** → cek status (Internal/Lokal/Eksternal)
- **Daftar plat sudah diinput** → ketuk untuk lihat detail + foto
- **Ganti petugas** → sinkron dengan admin (aktif/nonaktif, region)
- **History** → lihat trip sebelumnya

## Build & Run

```bash
npm run build          # build → www/
cd backend && node src/index.js   # backend :3000
php -S localhost:8000 -t admin-ci # admin :8000
```
