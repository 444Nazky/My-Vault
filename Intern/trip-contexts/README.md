# Trip Angkutan Plantation - Documentation Index

## Core Documents

| File | Description |
|------|-------------|
| [01-penjelasan.md](01-penjelasan.md) | Penjelasan lengkap untuk mentor |
| [02-konsep.md](02-konsep.md) | Konsep dan arsitektur sistem |

## Architecture

| File | Description |
|------|-------------|
| [architecture/use-case.md](architecture/use-case.md) | Use Case Diagram |
| [architecture/dfd.md](architecture/dfd.md) | Data Flow Diagram |
| [architecture/database-linking.md](architecture/database-linking.md) | Database integration diagram |
| [architecture/step-by-step-flow.md](architecture/step-by-step-flow.md) | Step-by-step data flow dari mobile ke dashboard |

## Database

| File | Description |
|------|-------------|
| [database/00-overview.md](database/00-overview.md) | ERD dan schema |

## Mobile App (Ionic)

| File | Description |
|------|-------------|
| [ionic/00-overview.md](ionic/00-overview.md) | Struktur proyek Ionic dan implementasi |
| [ionic/screens.md](ionic/screens.md) | Screen specifications (HTML templates) |
| [ionic/offline-sync.md](ionic/offline-sync.md) | Strategi offline-first dengan SQLite |

## API

| File | Description |
|------|-------------|
| [api/00-overview.md](api/00-overview.md) | Endpoint API documentation |

## Firebase

| File | Description |
|------|-------------|
| [firebase/auth.md](firebase/auth.md) | Firebase Authentication |

## UI/UX

| File | Description |
|------|-------------|
| [mockups/screens.md](mockups/screens.md) | Wireframe screens |

## Requirements

| File | Description |
|------|-------------|
| [requirements/functional.md](requirements/functional.md) | Functional requirements |

## Methodology

| File | Description |
|------|-------------|
| [methodology/waterfall.md](methodology/waterfall.md) | Development process |

## Edge Cases

| File | Description |
|------|-------------|
| [edge-cases/handling.md](edge-cases/handling.md) | Error handling |

---

## Quick Summary

**Project:** Sistem Informasi Angkutan Plantation

**Tujuan:** Digitalisasi pencatatan Angkutan di perkebunan

### Komponen Sistem

| Komponen | Teknologi | Lokasi |
|----------|----------|---------|
| Mobile App | Ionic/Angular/TypeScript | `/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/` |
| Web Dashboard | Vue.js/TypeScript | `/home/nazky/RPL/Intern/Aplikasi-Trip-Dashboard/` |
| Backend API | Laravel/Node.js | (belum dibuat) |
| Database | PostgreSQL | (belum dibuat) |

### Fitur Utama
- Login dengan PIN 6 digit
- Input kendaraan dengan foto selfie & GPS
- Offline-first dengan SQLite storage
- Geofencing validasi lokasi
- Dashboard real-time
- Export laporan PDF/Excel/CSV
- Manajemen user, tariff, region

### Database Linking

```
Mobile (Ionic)                    Backend API                    Database
    │                              │                            │
    │─── Login (PIN + device_id) ─>│                            │
    │                              │─── Validate PIN ──────────>│ PostgreSQL
    │                              │<── User Data + Tariffs ────│
    │<── Token + Tariffs ──────────│                            │
    │                              │                            │
    │─── Input Trip (offline) ──>│ Local SQLite                │
    │    └── SQLite               │                            │
    │                              │                            │
    │─── Sync (quenue) ────────>│─── Store Trip ───────────>│ PostgreSQL
    │                              │─── Upload Photo ────────>│ Firebase Storage
    │                              │                            │
    │<── Sync Status ──────────────│<── Confirmed ────────────│
    │                              │                            │
Web Dashboard                     │                            │
    │                              │                            │
    │────────────────────────────>│─── Read Trips ───────────>│ PostgreSQL
    │<────────────────────────────│<── Dashboard Data ────────│
    │                              │                            │
    │────────────────────────────>│─── CRUD User/Tariff ────>│ PostgreSQL
    │────────────────────────────>│─── Export Reports ───────>│ PostgreSQL
```

### Teknologi

**Mobile (Ionic):**
- Ionic 7 + Angular 17
- TypeScript
- @ionic/storage (SQLite)
- @capacitor/geolocation, camera, network

**Web Dashboard (Vue.js):**
- Vue.js 3 + TypeScript
- Pinia (state management)
- Tailwind CSS
- Chart.js

**Backend:**
- Laravel / Node.js
- PostgreSQL
- Firebase Auth + Storage

**Durasi:** 14 minggu (Waterfall)
