# Sinkronisasi Data Aplikasi Trip Angkutan

Tanggal: 23 September 2026

## Apa yang Sudah Dilakukan

### Masalah Awal
1. **Sync gap** - Login lokal (budi/admin) tidak dapat JWT → sync POST /trips selalu 401
2. **History tidak difilter** - Semua trip ditampilkan, bukan per-petugas

### Solusi yang Diimplementasi

#### 1. API Login Backend
- `POST /api/auth/member-login` - Login petugas dengan username/password → dapat JWT
- `POST /api/auth/admin-login` - Login admin dengan username/password → dapat JWT
- `POST /api/auth/login` - Login dengan PIN (officer switching)

#### 2. Frontend Auth Integration
- `LoginPage.tsx` → call `memberLogin()` setelah login lokal berhasil
- `auth.ts` → `ensureBackendSession()` auto-refresh JWT
- Sinkronisasi otomatis setelah trip selesai

#### 3. History Filter
- `HistoryScreen.tsx` → sudah filter `t.officer === officer.name`

### Alur Sinkronisasi Baru

```
1. Login (budi/budi123)
   ↓
2. LoginPage → memberLogin() → dapat JWT
   ↓
3. Buat & selesai trip → commitTrip()
   ↓
4. Auto-sync → POST /api/trips dengan JWT
   ↓
5. Backend terima & simpan ke database
```

### File yang Dibuat/Changed

| File | Change |
|------|--------|
| `backend/src/routes/auth.js` | +member-login, +admin-login |
| `src/services/auth.ts` | +memberLogin(), +ensureBackendSession() |
| `src/pages/LoginPage.tsx` | → call memberLogin() |
| `src/environments/environment.prod.ts` | → staging server URL |

---

## Konfigurasi Deployment

### Development
```typescript
apiBaseUrl: 'http://localhost:3000/api'
```

### Staging (192.168.1.2)
```typescript
apiBaseUrl: 'https://192.168.1.2/api'
```

---

## Test API

```bash
# Health check
curl http://localhost:3000/api/health

# Login petugas
curl -X POST http://localhost:3000/api/auth/member-login \
  -H "Content-Type: application/json" \
  -d '{"username": "budi", "password": "budi123"}'

# Create trip (dengan JWT)
curl -X POST http://localhost:3000/api/trips \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"statusMuatan": "muatan", "routeFrom": "SJRE", "routeTo": "SBDZ"}'
```

---

## Isu yang Masih Ada

> **Update 25 September 2026:**
>
> 1. **Tarif mapping** — ✅ **SELESAI.** `tariffFor()` kini exact match ke master tarif lebih dulu (opsi form dibangun dari master tarif), fallback parsial → `Truck Sedang` → default.
> 2. **Keamanan endpoint tarif** — ✅ **SELESAI.** `backend/src/routes/tariffs.js` kini `authenticate + requireAdmin` (GET/POST/PUT/DELETE). Seluruh route penting sudah terproteksi JWT.
> 3. **Database produksi** — ⏳ **MASIH BERLAKU.** Backend masih SQLite via sql.js (`backend/data/trip.db`); MariaDB di server belum dipakai.
> 4. **Backup file** — ✅ **SELESAI.** `AdminDashboard.backup.tsx` sudah tidak ada di repo.
>
> Isu baru yang sudah diperbaiki (lihat `summary/Summary.md` bagian Update 25 Sep 2026): sync daftar petugas (404 `my-region` karena backend lama + sesi mati karena refresh PIN demo), scroll dashboard admin, favicon Ionic, tema/font/aksen admin.
