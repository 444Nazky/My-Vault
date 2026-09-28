# Infrastruktur

## Struktur File

```
Aplikasi-Trip/
├── backend/
│   ├── src/
│   │   ├── index.js      # Express app :3000
│   │   ├── db.js         # SQLite wrapper
│   │   └── routes/       # API routes
│   └── data/
│       └── trip.db       # SQLite database
├── www/                   # React build (mobile)
└── admin-ci/              # Admin dashboard
    ├── index.php
    └── www/               # Sinkron dari build
```

## Port

| Service | Port |
|---------|------|
| Backend API | 3000 |
| Admin Dashboard | 8000 |
| Mobile Web | 8100 (dev) |

## API Base URL

- Development: `http://localhost:3000/api`
- Staging: `https://192.168.1.2/api`

## Environment

```bash
# backend/.env
JWT_SECRET=trip-angkut-secret-key
PORT=3000
NODE_ENV=staging
```

## Run Services

```bash
# Backend
cd backend && node src/index.js

# Admin Dashboard
php -S localhost:8000 -t admin-ci

# Mobile Dev (opsional)
ionic serve
```

## Database

- SQLite via `sql.js`
- File: `backend/data/trip.db`
- Tables: officers, regions, officer_regions, tariffs, region_tariffs, plates, trips, vehicles

## Backup

```bash
# Backup database
cp backend/data/trip.db backend/data/trip.db.bak-$(date +%Y%m%d)
```
