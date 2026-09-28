# Step-by-Step Setup Guide

Panduan lengkap setup project dari awal sampai sinkronisasi berjalan.

---

## Arsitektur Sistem

| Komponen | Teknologi | Lokasi |
|----------|----------|---------|
| Mobile App | Ionic Framework | `/Aplikasi-Trip-Ionic/` |
| Backend API | Node.js + Express + SQLite | `/Aplikasi-Trip-Ionic/backend/` |
| Admin Dashboard | CodeIgniter 2.2.4 + MySQL | `/admin/` |
| Database | MySQL/MariaDB | Server |

---

## Prerequisites

Pastikan sudah install:
- Node.js 22+
- npm
- Git
- PHP 5.x (untuk Admin Dashboard CodeIgniter 2.2.4)
- MySQL/MariaDB

---

## Step 1: Clone & Install Dependencies

```bash
# Clone repo
git clone https://github.com/444Nazky/Aplikasi-Trip-Ionic.git
cd Aplikasi-Trip-Ionic

# Install frontend dependencies
npm install

# Install backend dependencies
cd backend
npm install
cd ..
```

---

## Step 2: Database Setup (SQLite)

Backend pakai sql.js (pure JavaScript SQLite, no native bindings):

```bash
cd backend
npm list sql.js
# Pastikan sudah terinstall
```

Kalau belum:
```bash
cd backend
npm install sql.js
```

---

## Step 3: Start Backend Server

```bash
cd backend
npm start
```

Output expected:
```
Database seeded with initial data
Database loaded
Server running on http://localhost:3000
Health check: http://localhost:3000/api/health
```

---

## Step 4: Test Backend API

Buka terminal baru:

```bash
# 1. Health check
curl http://localhost:3000/api/health
# Output: {"status":"ok","timestamp":"..."}

# 2. Login petugas (harus berhasil)
curl -X POST http://localhost:3000/api/auth/member-login \
  -H "Content-Type: application/json" \
  -d '{"username": "budi", "password": "budi123"}'
# Output: {"token":"eyJ...","officer":{"id":1,"name":"Budi Santoso",...}}

# 3. Create trip (dengan token dari step 2)
TOKEN="paste_token_disini"
curl -X POST http://localhost:3000/api/trips \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "statusMuatan": "muatan",
    "routeFrom": "SJRE",
    "routeTo": "SBDZ",
    "keterangan": "Internal"
  }'
# Output: {"id":"uuid","noTrip":"TRP20260923..."}

# 4. Get trips
curl http://localhost:3000/api/trips \
  -H "Authorization: Bearer $TOKEN"
# Output: [{"id":"...","route_from":"SJRE","route_to":"SBDZ",...}]

# 5. Admin login (untuk dashboard & laporan)
ATOKEN=$(curl -s -X POST http://localhost:3000/api/auth/admin-login \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "admin123"}' \
  | sed -n 's/.*"token":"\([^"]*\)".*/\1/p')

# 6. Laporan rinci (trip + detail kendaraan) — ADMIN ONLY
curl http://localhost:3000/api/reports/trips \
  -H "Authorization: Bearer $ATOKEN"
# Output: [{"no_trip":"TRP...","officer_name":"Andi Pratama",
#   "trip_revenue":1050000,
#   "vehicles":[{"no_polisi":"30293","vehicle_type":"Truck Besar",
#     "golongan":"Eksternal Bebas","has_load":1,
#     "tariff_amount":450000}, ...]}, ...]
# Catatan: pakai token petugas → 403, tanpa token → 401
```

---

## Step 5: Start Frontend

```bash
# Root folder (buka terminal baru)
cd /path/ke/Aplikasi-Trip-Ionic
npm start
```

Output expected:
```
VITE v5.x.x  ready in xxx ms
➜  Local:   http://localhost:5173/
➜  Network: http://192.168.x.x:5173/
```

---

## Step 6: Test di Browser

1. Buka `http://localhost:5173`
2. Login dengan:
   - Username: `budi`
   - Password: `budi123`
3. Buat trip baru:
   - Pilih rute
   - Pilih kondisi (muatan/kosong)
   - Tambah kendaraan (plat, tipe)
   - Selesaikan trip
4. Buka DevTools (F12):
   - Tab **Network** → cari request ke `localhost:3000/api/trips`
   - Status harus **201 Created**
5. Tab **Console** → harus ada log:
   ```
   Database seeded with initial data
   ```
6. Login admin (`admin`/`admin123`) → dashboard admin:
   - Tab **Dashboard** → tabel "Trip Terbaru dari Server" terisi (klik **Refresh** kalau baru)
   - Tab **Laporan** → daftar trip; **klik salah satu baris** untuk buka detail kendaraan:
     plat, jenis, kategori (Internal/Eksternal), beban, tarif, dan total tarif trip

---

## Step 7: Build Production

```bash
# Build frontend
npm run build
# Output: www/

# Sync ke Android (optional)
npx cap sync android
```

---

## Step 8: Deploy ke Server

### A. Deploy Frontend Static Files

```bash
# Copy www/ folder ke server
scp -r www/ server@192.168.1.2:/var/www/html/

# Atau kalau pakai nginx yang sudah ada
# Copy ke folder yang di-serve nginx
```

### B. Deploy Backend

```bash
# Di server, buat folder
ssh server@192.168.1.2
mkdir -p /home/server/trip-backend

# Copy backend folder
scp -r backend/ server@192.168.1.2:/home/server/trip-backend/

# Install dependencies di server
ssh server@192.168.1.2
cd /home/server/trip-backend/backend
npm install

# Start dengan pm2 (production)
npm install -g pm2
pm2 start src/index.js --name trip-api
pm2 save
pm2 startup
```

### C. Update Environment URL

Edit `src/environments/environment.prod.ts` sebelum build:

```typescript
export const environment = {
  production: true,
  apiBaseUrl: 'https://192.168.1.2/api'
};
```

---

## Troubleshooting

### Backend tidak bisa start?

**Error: Cannot find module 'sql.js'**
```bash
cd backend
npm install sql.js
```

**Error: port 3000 already in use**
```bash
# Cari process
lsof -i :3000
# Kill process
kill -9 <PID>
```

### Frontend tidak connect ke backend?

1. Cek CORS di backend sudah enable:
   ```javascript
   // backend/src/index.js
   app.use(cors()); // harus ada
   ```

2. Cek apiBaseUrl di environment.ts:
   ```typescript
   apiBaseUrl: 'http://localhost:3000/api'
   ```

### Tab Laporan kosong / "Tidak dapat terhubung ke server"?

1. Pastikan backend jalan: `curl localhost:3000/api/health`
2. Token admin kadang sudah expired (24 jam) → klik **Refresh** (otomatis re-login)
3. Cek DevTools → Network → request `GET /api/reports/trips` → harus 200, bukan 401/403
4. Kalau 403, token yang terpakai bukan admin → logout → login ulang `admin`/`admin123`

### Dashboard "Trip Terbaru dari Server" kosong padahal sync 201?

- Dulu bug: token admin tanpa `regionId` → `GET /trips` difilter `region_id = NULL` → `[]`
- Sudah difix (admin tanpa filter region). Kalau masih terjadi, **restart backend** dengan kode terbaru

### Sync masih 401?

1. Buka DevTools → Application → localStorage
2. Cari `trip.auth.token.v1`
3. Kalau kosong, berarti login tidak call memberLogin()
4. Cek LoginPage.tsx apakah ada import memberLogin

### Trip tidak masuk queue?

1. Buka DevTools → Application → localStorage
2. Cari `trip.syncQueue.v1`
3. Kalau kosong, berarti addToSyncQueue tidak dipanggil
4. Cek commitTrip() di store.tsx

### Reset Data

```bash
# Hapus localStorage di browser (DevTools → Application → Clear storage)

# Reset database SQLite
cd backend/data
rm trip.db
# Restart backend - database akan dibuat ulang dengan seed data
```

---

## Quick Reference

| Task | Command |
|------|---------|
| Start backend | `cd backend && npm start` |
| Start frontend | `npm start` |
| Test API | `curl http://localhost:3000/api/health` |
| Login test | `curl -X POST localhost:3000/api/auth/member-login -H "Content-Type: application/json" -d '{"username":"budi","password":"budi123"}'` |
| Build | `npm run build` |
| Clear storage | DevTools → Application → Clear storage |

---

## Credentials

| Role | Username | Password | PIN |
|------|---------|---------|-----|
| Petugas | budi | budi123 | 123456 |
| Petugas | andi | budi123 | 123456 |
| Admin | admin | admin123 | - |
