# Database Linking Architecture

## Overview

Sistem terdiri dari 3 komponen utama yang terhubung melalui REST API:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         MOBILE (Ionic)                              │
│                                                                   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ Login    │  │ Trip     │  │ Vehicle  │  │ Sync     │      │
│  │ Service  │  │ Service  │  │ Service  │  │ Service  │      │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘      │
│       │             │             │             │               │
│       │             │             │             │               │
│       │      ┌─────▼─────┐      │             │               │
│       │      │  SQLite   │      │             │               │
│       │      │ (offline) │      │             │               │
│       │      └───────────┘      │             │               │
│       │                        │             │               │
└───────┼────────────────────────┼─────────────┼───────────────┘
        │                        │             │
        │   HTTPS/REST API        │             │
        ▼                        ▼             ▼
┌───────────────────────────────────────────────────────────────┐
│                      BACKEND API                              │
│                                                               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐│
│  │ Auth     │  │ Trips    │  │ Reports  │  │ Admin   ││
│  │ Service  │  │ Service  │  │ Service  │  │ Service ││
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘│
│       │             │             │             │            │
│       └─────────────┼─────────────┼─────────────┘            │
│                       │             │                        │
│                       ▼             ▼                        │
│              ┌────────────────┐  ┌────────────────┐       │
│              │   PostgreSQL   │  │ Firebase Auth │       │
│              │   (primary)   │  │ (tokens)     │       │
│              └────────────────┘  └────────────────┘       │
│                       │                                   │
│                       ▼                                   │
│              ┌────────────────┐                          │
│              │ Firebase      │                          │
│              │ Storage       │                          │
│              │ (photos)     │                          │
│              └────────────────┘                          │
└───────────────────────────────────────────────────────────┘
        │             │             │
        ▼             ▼             ▼
┌───────────────────────────────────────────────────┐
│                   WEB DASHBOARD (Vue.js)             │
│                                                   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ Dashboard│  │ Reports │  │ Admin   │      │
│  │ View    │  │ View    │  │ Views  │      │
│  └──────────┘  └──────────┘  └──────────┘      │
└───────────────────────────────────────────────────┘
```

## Data Flow Detail

### 1. Login Flow

```
Mobile                          API                          Database
  │                              │                            │
  ├── PIN + device_id ───────> │                            │
  │                            ├── Validate PIN ──────────>│ users
  │                            ├── Check device binding ─>│ users
  │                            ├── Get tariffs ─────────>│ tariffs
  │                            ├── Generate Firebase token
  │                            └── Response: token + user + tariffs
  │ <─────────────────────────│                            │
  │ Store token locally          │                            │
```

### 2. Offline Input Flow

```
Mobile                          Local Storage              │
  │                              │                        │
  ├── User input trip            │                        │
  ├── Save to SQLite ─────────> │ local_trips table       │
  │                              │                        │
  ├── User input vehicle         │                        │
  ├── Save to SQLite ─────────> │ local_vehicles table    │
  │                              │                        │
  ├── Photo captured            │                        │
  └── Store locally             │                        │
```

### 3. Sync Flow

```
Mobile                          API                          Database
  │                              │                            │
  ├── Detect online             │                            │
  ├── Get pending from SQLite    │                            │
  ├── Upload photo ───────────────────────────────> Firebase Storage
  ├── Send trip JSON ───────>  │                            │
  │                            ├── Store trip ──────────>│ trips
  │                            ├── Store vehicles ─────>│ trip_kendaraan
  │                            ├── Update sync status
  │                            └── Response: success
  ├── Mark as synced ───────>  │ local_trips (is_synced = true)
```

### 4. Dashboard View Flow

```
Web Dashboard                    API                          Database
  │                              │                            │
  ├── Request stats ─────────>  │                            │
  │                            ├── Aggregate trips ───────>│ trips + trip_kendaraan
  │                            ├── Calculate revenue ────>│ trips + tariffs
  │                            └── Response: stats JSON
  │ <─────────────────────────│                            │
  └── Display dashboard         │                            │
```

### 5. Admin CRUD Flow

```
Web Dashboard                    API                          Database
  │                              │                            │
  ├── Create tariff ──────────>│                            │
  │                            ├── Insert tariff ───────>│ tariffs
  │                            └── Response: created
  │ <─────────────────────────│                            │
  ├── Update user ──────────>│                            │
  │                            ├── Update user ────────>│ users
  │                            └── Response: updated
```

## Database Tables

### PostgreSQL (Primary Storage)

| Table | Purpose | Linked To |
|-------|---------|-----------|
| users | Petugas/admin accounts | regions, trips |
| regions | Area operasional | users, trips, tariffs |
| tariffs | Master harga | trip_kendaraan |
| trips | Header trip | users, regions |
| trip_kendaraan | Detail kendaraan | trips, tariffs |

### SQLite (Mobile Offline)

| Table | Purpose | Syncs To |
|-------|---------|----------|
| trips | Local trip cache | PostgreSQL trips |
| vehicles | Local vehicle cache | PostgreSQL trip_kendaraan |
| tariffs | Tariff cache | PostgreSQL tariffs (read-only) |
| sync_queue | Pending uploads | Auto-sync on connect |

### Firebase

| Service | Purpose |
|---------|---------|
| Authentication | User tokens (mobile) |
| Storage | Photo files (vehicles, conditions) |

## API Integration

### Mobile calls API for:
- POST `/auth/login` - Login
- POST `/trips` - Create trip
- POST `/trips/{id}/vehicles` - Add vehicle
- PUT `/trips/{id}/complete` - Complete trip
- GET `/tariffs` - Get tariff cache

### Web Dashboard calls API for:
- GET `/reports/summary` - Dashboard stats
- GET `/trips` - Trip list
- GET `/reports/export` - Export files
- CRUD `/admin/users` - User management
- CRUD `/admin/tariffs` - Tariff management
- CRUD `/admin/regions` - Region management

## Offline Strategy

```
┌─────────────────────────────────────────┐
│              MOBILE DEVICE                │
│                                         │
│  ┌─────────────────────────────────┐  │
│  │     USER INPUT                    │  │
│  └───────────────┬─────────────────────┘  │
│                  │                      │
│                  ▼                      │
│  ┌───────────────────────────────┐     │
│  │     WRITE TO SQLite           │     │
│  │     (immediate, offline-safe)  │     │
│  └───────────────┬───────────────────┘     │
│                  │                       │
│                  ▼                       │
│  ┌───────────────────────────────┐     │
│  │     SYNC QUEUE              │     │
│  │     (background processor)    │     │
│  └───────────────┬───────────────┘     │
│                  │                       │
│                  ▼ (when online)        │
│  ┌─────────────────────────────────┐  │
│  │     UPLOAD TO API + FIREBASE    │  │
│  │     (retry on failure)          │  │
│  └─────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

## Conflict Resolution

| Data Type | Strategy | Reason |
|-----------|----------|---------|
| Trip header | Server wins | Supervisor may have accessed |
| Vehicle data | Last-write-wins | No logical conflict |
| User settings | Client wins | Local preference |
| Tariffs | Server wins | Single source of truth |
