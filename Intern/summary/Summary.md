# Sinkronisasi Data Aplikasi Trip Angkutan

Tanggal: 23 September 2026

## Apa yang Sudah Dilakukan

### Masalah Awal
Data trip hanya disimpan ke localStorage dan **tidak ada HTTP request ke backend**. Status selalu menunjukkan "Menunggu sinkronisasi" forever.

### Solusi yang Diimplementasi

1. **API Service** (`src/services/api.ts`)
   - HTTP client dengan JWT authentication
   - Error handling terpusat
   - Auto-clear token saat 401 Unauthorized

2. **Auth Service** (`src/services/auth.ts`)
   - Login dengan officer ID + PIN ke backend
   - JWT token management dengan localStorage persistence
   - Logout functionality

3. **Sync Service** (`src/services/sync.ts`)
   - Queue-based background synchronization
   - Auto-retry max 3x dengan delay 5 detik
   - Auto-sync saat app di foreground + online
   - Sync manual via banner di HomeScreen

4. **Integrasi Frontend**
   - `commitTrip()` → auto-add to sync queue
   - HomeScreen → sync banner + manual button
   - TripCompleteScreen → status sync + retry

5. **Backend Update**
   - Routes untuk `/auth/login`, `/trips`, `/trips/:id/vehicles`
   - JWT authentication middleware
   - SQLite database dengan seed data

### Alur Sinkronisasi

```
Trip Selesai → commitTrip() → addToSyncQueue(localStorage)
                              ↓
              ┌─── Auto-sync ───────────────────────┐
              │  - On app focus (window focus event) │
              │  - On online event                   │
              │  - processSyncQueue()                │
              └─── Manual (tap banner) ───────────────┘
                              ↓
              POST /api/trips → POST /api/trips/:id/vehicles
                              ↓
              ┌─── Success → hapus dari queue ────────┐
              └─── Failure → retry (max 3x) ──────────┘
```

### File yang Dibuat

| File | Purpose |
|------|---------|
| `src/services/api.ts` | HTTP client dengan JWT auth |
| `src/services/auth.ts` | Login + token management |
| `src/services/sync.ts` | Queue-based background sync |
| `start-dev.sh` | Script start frontend + backend |

### File yang Dimodifikasi

| File | Change |
|------|--------|
| `src/pages/store.tsx` | `commitTrip()` → auto-add to sync queue |
| `src/pages/mobile/HomeScreen.tsx` | Sync banner + manual button |
| `src/pages/mobile/TripCompleteScreen.tsx` | Sync status + retry |
| `src/pages/mobile/PinVerifyScreen.tsx` | API auth + demo fallback |
| `src/environments/environment.ts` | `apiBaseUrl: http://localhost:3000/api` |
| `src/environments/environment.prod.ts` | Production API URL |

---

## Tutorial Development

### Jalankan Development Server

```bash
# Option 1: Start both frontend + backend together
./start-dev.sh

# Option 2: Manual (separate terminals)
# Terminal 1 - Backend
cd backend
npm install
npm start

# Terminal 2 - Frontend  
npm start
```

Akses:
- Frontend: http://localhost:5173
- Backend API: http://localhost:3000/api

### API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/login` | Login dengan officer ID + PIN |
| GET | `/api/auth/verify` | Verify JWT token |
| GET/POST | `/api/trips` | CRUD trips |
| POST | `/api/trips/:id/vehicles` | Add vehicle |
| GET | `/api/health` | Health check |

### Login Demo

```
Username: budi
Password: budi123
```

atau PIN 6 digit: `123456` (untuk officer switch)

### Build untuk Production

```bash
# Build frontend
npm run build

# Sync ke Android
npx cap sync android

# Open di Android Studio
npx cap open android
```

### Konfigurasi Environment

Development: `src/environments/environment.ts`
```typescript
apiBaseUrl: 'http://localhost:3000/api'
```

Production: `src/environments/environment.prod.ts`
```typescript
apiBaseUrl: 'https://api.tripangkut.com/api'
```

### Troubleshooting

**Sync tidak jalan?**
1. Cek apakah backend sedang running di port 3000
2. Cek console browser untuk error
3. Buka Network tab di DevTools untuk lihat request

**401 Unauthorized?**
- Token expired atau invalid
- Logout dan login ulang

**Offline mode?**
- Data tetap tersimpan di localStorage
- Sync akan jalan otomatis saat online lagi
