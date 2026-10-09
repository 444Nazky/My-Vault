# Backend Migration - Trip Angkutan

## Current State
- Backend: Express.js + SQLite (local)
- Database: `database.sqlite` file
- API: ~12 routes

## Target State
- Backend: Tetap Express.js
- Database: SQLite atau PostgreSQL di cloud
- Hosting: Railway/Render/Fly.io/VPS

---

## Step 1: Persiapan

### 1.1 Export Database Schema

```bash
cd ~/RPL/Intern/Aplikasi-Trip-Ionic/backend

# Lihat semua tables
sqlite3 database.sqlite ".tables"

# Export schema
sqlite3 database.sqlite ".schema" > schema.sql

# Lihat struktur officers
sqlite3 database.sqlite ".schema officers"
```

### 1.2 Export Data

```bash
# Create exports folder
mkdir -p ../migration_exports

# Export each table as CSV
sqlite3 database.sqlite -header -csv "SELECT * FROM officers;" > ../migration_exports/officers.csv
sqlite3 database.sqlite -header -csv "SELECT * FROM vehicles;" > ../migration_exports/vehicles.csv
sqlite3 database.sqlite -header -csv "SELECT * FROM trips;" > ../migration_exports/trips.csv
sqlite3 database.sqlite -header -csv "SELECT * FROM regions;" > ../migration_exports/regions.csv
sqlite3 database.sqlite -header -csv "SELECT * FROM tariffs;" > ../migration_exports/tariffs.csv
sqlite3 database.sqlite -header -csv "SELECT * FROM region_tariffs;" > ../migration_exports/region_tariffs.csv

# Check exports
head -3 ../migration_exports/officers.csv
```

---

## Step 2: Deploy Backend ke Cloud

### Option A: Railway

1. Buka https://railway.app
2. Login → New Project → "Deploy from GitHub"
3. Pilih repo backend
4. Railway auto-detect Node.js
5. Tunggu deploy (~2 menit)
6. Copy deployment URL

### Option B: Render

1. Buka https://render.com
2. Login → New → Web Service
3. Connect GitHub repo
4. Settings:
   - Root Directory: `backend`
   - Build Command: `npm install`
   - Start Command: `npm start`
5. Create & Deploy

### Option C: Fly.io

```bash
# Install flyctl
curl -L https://fly.io/install.sh | sh
fly auth login

# Launch
cd backend
fly launch --name trip-api

# Set port
fly secrets set PORT=3000

# Deploy
fly deploy
```

---

## Step 3: Import Data ke Cloud

### Railway (with persistent disk)

Railway menyediakan persistent disk untuk SQLite:

1. Di Railway dashboard → Pilih project → Add Redis/Postgres
2. Pilih "Add a database" → "SQLite (Beta)" atau "PostgreSQL"
3. Import CSV via TablePlus atau pgAdmin

### PostgreSQL Import

```bash
# Connect to PostgreSQL di cloud
psql $DATABASE_URL

# Create tables (sesuaikan schema)
CREATE TABLE officers (
  id TEXT PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  pin_hash TEXT NOT NULL,
  full_name TEXT,
  region_id TEXT,
  role TEXT DEFAULT 'officer',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

# Import CSV
\COPY officers FROM 'officers.csv' CSV HEADER;
\COPY vehicles FROM 'vehicles.csv' CSV HEADER;
-- dst...
```

---

## Step 4: Update Mobile App

### 4.1 Update API Base URL

Edit file config atau environment:

```typescript
// Development
const API_BASE = 'http://localhost:3000';

// Production - Ganti dengan URL cloud
const API_BASE = 'https://trip-api.up.railway.app';
```

### 4.2 Test Connection

```bash
# Test health endpoint
curl https://trip-api.up.railway.app/api/health

# Test login
curl -X POST https://trip-api.up.railway.app/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","pin":"123456"}'
```

---

## Step 5: Deploy Admin Dashboard

### 5.1 Update API URL di Admin

Edit `admin-ci/assets/config.js`:
```javascript
const API_BASE = 'https://trip-api.up.railway.app';
```

### 5.2 Deploy

```bash
# Vercel
cd admin-ci
vercel --prod

# Atau Netlify
netlify deploy --prod --dir=.
```

---

## Migration Checklist

- [ ] 1. Export data dari SQLite
- [ ] 2. Deploy backend ke Railway/Render/Fly.io
- [ ] 3. Setup database di cloud
- [ ] 4. Import data
- [ ] 5. Test semua API endpoints
- [ ] 6. Update mobile app API URL
- [ ] 7. Build & test mobile APK
- [ ] 8. Deploy admin dashboard
- [ ] 9. Test end-to-end

---

## Troubleshooting

### Database Connection Error
- Cek DATABASE_URL environment variable
- Pastikan format URL benar

### Data Import Failed
- Cek encoding CSV (pastikan UTF-8)
- Cek kolom matches schema

### API Returns 404
- Cek routing di cloud console
- Cek logs untuk error details

---

*Migration guide - backup database sebelum migrate!*
