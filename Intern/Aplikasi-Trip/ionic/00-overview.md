# Ionic Implementation Overview

> **Status:** struktur aktual — 25 September 2026. Aplikasi memakai **React** (ReactDOM) yang di-build dengan Angular CLI (`@angular/build:application` → output `www/`), **bukan** struktur Angular/Ionic module (rancangan awal sudah tidak dipakai).

## Struktur Proyek (aktual)

```
src/
├── main.tsx               # ReactDOM.createRoot → #root
├── App.tsx                # routing utama: LoginPage | MobileApp | AdminDashboard
├── index.css    (styles)  # Tailwind + aturan admin (html[data-admin]: scroll, tema, aksen)
├── global.scss, theme/variables.scss
├── index.html             # entry build
├── environments/          # apiBaseUrl (dev localhost:3000 / staging)
├── pages/
│   ├── LoginPage.tsx      # login username/password (admin & member)
│   ├── store.tsx          # context React (draft trip, petugas, tarif, sinkron)
│   ├── data.ts            # data statis: rute, master tarif awal, seed
│   ├── types.ts           # tipe MobileScreen dll.
│   ├── mobile/            # layar aplikasi petugas
│   │   ├── MobileApp.tsx / MobileShell.tsx / StatusBar.tsx / FloatingBottomNav.tsx
│   │   ├── HomeScreen.tsx
│   │   ├── TripConditionScreen.tsx     # pilih status muatan (revisi alur)
│   │   ├── RouteSelectScreen.tsx       # rute; kosong → kunci SJRE→SBDZ
│   │   ├── VehicleFormScreen.tsx       # 2 langkah + daftar plat sudah diinput
│   │   ├── CameraScreen.tsx            # wajib kamera (tanpa galeri)
│   │   ├── TripSummaryScreen.tsx       # submit terkunci tanpa foto
│   │   ├── TripActiveScreen.tsx / TripCompleteScreen.tsx
│   │   ├── HistoryScreen.tsx / HistoryDetailScreen.tsx
│   │   ├── ProfileScreen.tsx / SettingsScreen.tsx
│   │   └── OfficerSwitchScreen.tsx / PinVerifyScreen.tsx   # ganti petugas (sinkron admin)
│   └── admin/
│       └── AdminDashboard.tsx          # dashboard admin (tab: Dashboard, Master Tarif,
│                                       #  Master Plat, Petugas, Laporan, Pengaturan)
└── services/
    ├── api.ts       # HTTP client + JWT
    ├── auth.ts      # memberLogin, loginWithPin, ensureBackendSession, refreshBackendSession
    ├── sync.ts      # antrian sinkron trip offline
    ├── officers.ts  # tarik daftar petugas (/officers/my-region) + cache
    ├── trips.ts     # laporan trip + filter + format tanggal WIB
    ├── tariffs.ts / regions.ts / plates.ts
    ├── ocr.ts       # pembacaan plat dari foto
    ├── theme.ts     # tema/font/aksen admin (persist localStorage)
    └── xlsx.ts      # ekspor Excel .xlsx tanpa dependency tambahan
```

## Backend (`backend/`)

```
backend/src/
├── index.js          # Express app, port 3000
├── db.js             # sql.js wrapper (SQLite file data/trip.db)
├── middleware/auth.js# authenticate (JWT) + requireAdmin
└── routes/
    ├── auth.js       # member-login, admin-login, login (PIN), refresh, verify
    ├── trips.js      # trip + kendaraan
    ├── vehicles.js / tariffs.js / region-tariffs.js
    ├── plates.js     # registrasi & cek plat (internal/lokal/eksternal)
    ├── officers.js   # CRUD + my-region + regions + status (many-to-many)
    ├── regions.js
    └── reports.js    # summary, trips, filters, export
```

## Admin dashboard (`admin-ci/`)
- Entry: `index.php` (CodeIgniter) → menyajikan `index.html` hasil build dengan atribut `data-admin`, strip favicon Ionic, dan inline fix scroll.
- Isi: bundle ber-hash `main-*.js` / `styles-*.css` + `assets/`, disinkronkan dari `www/` setiap build.

## Perintah

```bash
npm run build         # build → www/ (lalu sinkron ke admin-ci/)
cd backend && node src/index.js   # backend :3000
php -S localhost:8000 -t admin-ci # dashboard admin (atau server CI)
```
