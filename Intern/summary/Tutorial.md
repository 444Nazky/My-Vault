# Tutorial Sinkronisasi Data - Penjelasan Teknis

## Arsitektur Sistem

```
┌─────────────────────────────────────────────────────────────┐
│                    MOBILE APP (Ionic)                        │
│  Ionic Framework + Capacitor                               │
│  - Local-first (localStorage)                             │
│  - Sync queue → Backend                                   │
└─────────────────────┬─────────────────────────────────────┘
                      │ HTTP/REST
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    BACKEND API (Node.js)                    │
│  Node.js + Express + SQLite (sql.js)                        │
│  - JWT Authentication                                     │
│  - Trip CRUD                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│               ADMIN DASHBOARD (CodeIgniter 2.2.4)          │
│  PHP + MySQL/MariaDB                                      │
│  - CRUD Tariff                                            │
│  - CRUD Officer                                          │
│  - Laporan                                               │
└─────────────────────────────────────────────────────────────┘
```

## Gambaran Umum

Aplikasi Trip Angkutan bersifat **local-first**: data trip disimpan dulu ke localStorage di perangkat petugas, lalu di-sync ke backend saat ada koneksi internet.

## Masalah Awal

```
Login (budi/budi123) → localStorage only → No JWT
                                           ↓
Buat Trip → commitTrip() → addToSyncQueue()
                                           ↓
processSyncQueue() → POST /api/trips → ❌ 401 (no token)
```

### Kenapa Sync Gagal?

1. Login page menggunakan auth lokal (hardcoded username/password)
2. Tidak ada request ke backend untuk dapat JWT token
3. Endpoint POST /trips memerlukan JWT (middleware `authenticate`)
4. Tanpa token → 401 Unauthorized → sync gagal permanen

## Masalah: sql.js undefined binding

sql.js tidak bisa bind `undefined` - harus `null`. Fix di db.js wrapper:

```javascript
const safeParams = params.map(p => p === undefined ? null : p);
db.run(sql, safeParams);
```

Tanpa fix ini, CREATE TRIP gagal dengan error:
```
Wrong API use: tried to bind a value of an unknown type (undefined)
```

## Solusi: Backend Login Endpoint

### 1. Tambah Endpoint di Backend

**File:** `backend/src/routes/auth.js`

```javascript
// Member/officer login dengan username/password
// Maps ke seeded officer: budi=1, andi=2, siti=3, rizky=4, dewi=5
const OFFICER_USERNAME_MAP = {
  'budi': 1,
  'andi': 2,
  'siti': 3,
  'rizky': 4,
  'dewi': 5
};

router.post('/member-login', (req, res) => {
  const { username, password } = req.body;
  // Validasi credentials...
  // Return JWT token + officer data
});
```

### 2. Update Frontend Auth Service

**File:** `src/services/auth.ts`

```typescript
// Login petugas ke backend, dapat JWT
export async function memberLogin(username: string, password: string) {
  const result = await api.post<LoginResponse>('/auth/member-login', {
    username, password
  });

  if (result.ok && result.data) {
    api.setToken(result.data.token);  // Simpan JWT
    saveOfficer(result.data.officer);
    return { success: true };
  }
  return { success: false };
}

// Auto-refresh JWT sebelum sync
export async function ensureBackendSession(): Promise<boolean> {
  if (api.isAuthenticated) return true;
  const stored = getStoredOfficer();
  if (!stored) return false;
  const result = await loginWithPin(stored.id, DEMO_PIN);
  return result.success;
}
```

### 3. Integrate dengan Login Page

**File:** `src/pages/LoginPage.tsx`

```typescript
const handleLogin = async () => {
  // 1. Validasi credentials lokal
  if (username === creds.username && password === creds.password) {
    setLoading(true);

    // 2. Untuk member, juga dapat JWT dari backend
    if (userType === 'member') {
      await memberLogin(username, password);
    }

    // 3. Masuk app
    onLogin(userType);
  }
};
```

## Alur Sinkronisasi Lengkap

```
┌─────────────────────────────────────────────────────────────┐
│ 1. LOGIN                                                  │
│    LoginPage → memberLogin() → POST /auth/member-login     │
│    ← JWT token + officer data                              │
│    JWT disimpan di api.token + localStorage               │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. BUAT TRIP                                              │
│    Route Select → Vehicle Form → Camera → Trip Summary      │
│    → commitTrip() → addToSyncQueue(trip)                  │
│    Trip tersimpan di localStorage + queue                 │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. SELESAI TRIP                                           │
│    TripCompleteScreen mount → processSyncQueue()          │
│    → POST /api/trips (Authorization: Bearer <JWT>)        │
│    ← 201 Created                                         │
│    → hapus dari queue                                    │
└─────────────────────────────────────────────────────────────┘
```

## File Services

### src/services/api.ts
- HTTP client wrapper dengan fetch
- Auto-set Authorization header
- Error handling

### src/services/auth.ts
- `memberLogin()` - Login petugas
- `loginWithPin()` - Login dengan PIN
- `ensureBackendSession()` - Auto JWT refresh
- Token persistence di localStorage

### src/services/sync.ts
- `addToSyncQueue()` - Tambah trip ke queue
- `processSyncQueue()` - Proses semua pending trips
- `getPendingCount()` - Hitung trip belum sync
- Auto-retry max 3x
- Online/offline detection

## Fitur Laporan Admin (detail per trip)

### Kebutuhan
Admin perlu melihat per 1 trip: kendaraan apa saja, nomor plat, kategori (Internal / Eksternal), total tarif, dll.

### Backend: `GET /reports/trips` (admin only)

**File:** `backend/src/routes/reports.js`

Endpoint kini join nama petugas + menyertakan array kendaraan nested per trip:

```javascript
let query = `
  SELECT t.*, r.name as region_name, o.name as officer_name,
    (SELECT COUNT(*) FROM trip_vehicles tv WHERE tv.trip_id = t.id) as vehicle_count,
    (SELECT SUM(v.tariff_amount) FROM vehicles v WHERE v.trip_id = t.id) as trip_revenue
  FROM trips t
  JOIN regions r ON t.region_id = r.id
  LEFT JOIN officers o ON t.officer_id = o.id
  WHERE 1=1
`;
// ... filter tanggal/rute/golongan/status

const trips = db.prepare(query).all(...params);

// Lampirkan detail kendaraan per trip
const vehStmt = db.prepare(`
  SELECT no_polisi, vehicle_type, golongan, has_load, tariff_amount
  FROM vehicles WHERE trip_id = ?
`);
for (const t of trips) {
  t.vehicles = vehStmt.all(t.id);
  if (t.trip_revenue == null) {
    t.trip_revenue = t.vehicles.reduce((s, v) => s + (v.tariff_amount || 0), 0);
  }
}
res.json(trips);
```

Respons contoh:
```json
{
  "no_trip": "TRP202609236QWU",
  "route_from": "SBDZ", "route_to": "SJRE",
  "status_muatan": "muatan",
  "keterangan": "Eksternal Bebas",
  "officer_name": "Andi Pratama",
  "region_name": "Badau",
  "vehicle_count": 6,
  "trip_revenue": 1050000,
  "vehicles": [
    { "no_polisi": "30293", "vehicle_type": "Truck Besar",
      "golongan": "Eksternal Bebas", "has_load": 1,
      "tariff_amount": 450000 }
  ]
}
```

> Kategori kendaraan disimpan di kolom `vehicles.golongan`:
> `Internal` · `Eksternal` · `Eksternal Bebas`
> (baris lama bisa berupa angka romawi golongan, fallback badge biru)

### Frontend: service

**File:** `src/services/trips.ts`

```typescript
export interface ReportVehicle {
  no_polisi: string
  vehicle_type: string
  golongan: string      // kategori: Internal / Eksternal (...)
  has_load: number      // 1 = ada muatan, 0 = kosong
  tariff_amount: number
}

export interface ReportTrip {
  no_trip: string
  route_from: string | null
  route_to: string | null
  status_muatan: 'muatan' | 'kosong'
  keterangan: string | null
  officer_name?: string | null
  region_name?: string | null
  vehicle_count: number
  trip_revenue: number | null
  vehicles: ReportVehicle[]
}

export async function fetchTripReports(): Promise<ReportTrip[] | null> {
  const result = await api.get<ReportTrip[]>('/reports/trips')
  if (!result.ok || !result.data) return null
  return result.data
}
```

### Frontend: tab Laporan (AdminDashboard)

Lazy-load saat tab dibuka:

```typescript
const loadReports = async () => {
  setReportState('loading')
  const ok = await ensureAdminBackendSession()   // JWT admin dulu
  if (!ok) { setReportState('offline'); return }
  const rows = await fetchTripReports()
  if (rows === null) { setReportState('offline'); return }
  setReportTrips(rows)
  setReportState('ready')
}

useEffect(() => {
  if (tab === 'reports' && reportState === 'idle') void loadReports()
}, [tab, reportState])
```

UI: kartu ringkasan (Total Trip / Trip Muatan / Total Unit / Total Pendapatan) + daftar trip berbentuk **accordion** — klik baris →展开 detail:

```
▼ TRP202609236QWU  SBDZ → SJRE  Andi Pratama  [muatan]  6 unit  Rp 1.050.000
   Kategori · Wilayah · Tanggal
   ┌ Plat ──── Jenis ──── Kategori ────────────── Beban ──── Tarif ┐
   │ 30293    Truck Besar Eksternal Bebas Muatan  450.000│
   │ ...                                                            │
   │                        Total Tarif Trip (6 unit)      1.050.000│
   └────────────────────────────────────────────────────────────────┘
```

Badge warna kategori: Internal (slate) · Eksternal (amber) · Eksternal Bebas (rose).

### Verifikasi

```bash
# Admin token
AT=$(curl -s -X POST localhost:3000/api/auth/admin-login \
  -H 'Content-Type: application/json' \
  -d '{"username":"admin","password":"admin123"}' \
  | sed -n 's/.*"token":"\([^"]*\)".*/\1/p')

# Laporan rinci
curl -s localhost:3000/api/reports/trips -H "Authorization: Bearer $AT"
# → semua trip + vehicles nested
# Petugas → 403, tanpa token → 401
```

## Fix: Dashboard Admin Kosong Padahal Sync OK

`GET /trips` dulu selalu filter `WHERE region_id = ?`. Token admin tidak punya `regionId` → `NULL` → `[]`.

```javascript
const isAdmin = role === 'admin';
let query = `... WHERE ${isAdmin ? '1 = 1' : 't.region_id = ?'}`;
const params = isAdmin ? [] : [regionId];
```

Sekarang: admin lihat semua trip, petugas tetap hanya wilayahnya.

## Konfigurasi Environment

### Development
```typescript
// src/environments/environment.ts
apiBaseUrl: 'http://localhost:3000/api'
```

### Staging Server
```typescript
// src/environments/environment.prod.ts
apiBaseUrl: 'https://192.168.1.2/api'
```

## Cara Setup dari Awal

### 1. Install Dependencies

```bash
cd backend
npm install
```

### 2. Jalankan Backend

```bash
cd backend
npm start
# Server running on http://localhost:3000
```

### 3. Jalankan Frontend

```bash
npm install
npm start
# Frontend on http://localhost:5173
```

### 4. Test Manual

```bash
# Health check
curl http://localhost:3000/api/health

# Login petugas
curl -X POST http://localhost:3000/api/auth/member-login \
  -H "Content-Type: application/json" \
  -d '{"username": "budi", "password": "budi123"}'

# Create trip (paste token dari response)
curl -X POST http://localhost:3000/api/trips \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "statusMuatan": "muatan",
    "routeFrom": "SJRE",
    "routeTo": "SBDZ"
  }'
```

## Troubleshooting

### Sync masih 401?
1. Cek LoginPage.tsx - apakah `memberLogin()` dipanggil?
2. Cek DevTools → Application → localStorage → trip.auth.token
3. Cek DevTools → Network → request /auth/member-login response

### Backend tidak jalan?
1. Cek port 3000 tersedia: `lsof -i :3000`
2. Cek sql.js terinstall: `cd backend && npm list sql.js`
3. Rebuild: `cd backend && rm -rf node_modules && npm install`

### Trip tidak masuk queue?
1. Cek `commitTrip()` dipanggil saat trip selesai
2. Cek `addToSyncQueue()` dipanggil di commitTrip
3. Cek localStorage → trip.syncQueue.v1
