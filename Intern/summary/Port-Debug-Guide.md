# Port Management & Debugging Guide

Tanggal: 24 September 2026

---

## Port Assignment

| Service | Port | URL |
|---------|------|-----|
| Backend API (Node.js) | 3000 | http://localhost:3000/api |
| Mobile App (Ionic dev) | 5173 | http://localhost:5173 |
| Admin Dashboard (PHP) | 8000 | http://localhost:8000 |

---

## Kill All Ports (Copy-Paste Ready)

```bash
# Kill all known ports in one command
pkill -f "node src/index.js" 2>/dev/null; pkill -f "php -S" 2>/dev/null; pkill -f "ng serve" 2>/dev/null; pkill -f "vite" 2>/dev/null; pkill -f "python.*http.server" 2>/dev/null

# Verify all ports free
ss -tlnp | grep -E "3000|5173|8000" || echo "All ports cleared"
```

**Alternative (manual):**
```bash
# Find PID on specific ports
lsof -ti:3000 | xargs kill -9 2>/dev/null
lsof -ti:5173 | xargs kill -9 2>/dev/null
lsof -ti:8000 | xargs kill -9 2>/dev/null

# Or using fuser
fuser -k 3000/tcp 5173/tcp 8000/tcp 2>/dev/null
```

---

## Start All Services (Sequential)

```bash
# Terminal 1: Backend API (port 3000)
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/backend
npm start

# Terminal 2: Mobile App (port 5173)
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic
npm start

# Terminal 3: Admin Dashboard (port 8000)
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/admin-ci
php -S localhost:8000
```

---

## One-Liner Start All (Background)

```bash
# Kill existing first
pkill -f "node src/index.js" 2>/dev/null; pkill -f "php -S" 2>/dev/null; pkill -f "ng serve" 2>/dev/null

# Start backend
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/backend && npm start > /dev/null 2>&1 &

# Start mobile (wait for backend)
sleep 2
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic && npm start > /dev/null 2>&1 &

# Start admin
sleep 3
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/admin-ci && php -S localhost:8000 > /dev/null 2>&1 &

# Verify
sleep 2
echo "=== Verification ==="
curl -s http://localhost:3000/api/health && echo " - API OK"
curl -s http://localhost:5173 | grep -q "Trip Angkutan" && echo " - Mobile OK"
curl -s http://localhost:8000 | grep -q "Trip Angkutan" && echo " - Admin OK"
```

---

## ⚠️ Important: Background Process Persistence

**Background processes (`&`) die when shell exits** (SIGHUP). Use these methods for persistent services:

### Method 1: Separate Terminals (Recommended)
```bash
# Terminal 1 - Backend
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/backend && npm start

# Terminal 2 - Mobile
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic && npm start

# Terminal 3 - Admin
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/admin-ci && php -S localhost:8000
```

### Method 2: tmux Sessions (Persistent)
```bash
# Install tmux if needed: sudo apt install tmux

# Create named sessions
tmux new-session -d -s backend 'cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/backend && npm start'
tmux new-session -d -s mobile 'cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic && npm start'
tmux new-session -d -s admin 'cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/admin-ci && php -S localhost:8000'

# List sessions
tmux ls

# Attach to session
tmux attach -t backend

# Kill session
tmux kill-session -t backend
```

### Method 3: nohup + disown (Quick Background)
```bash
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/backend
nohup npm start > backend.log 2>&1 &
disown

cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic
nohup npm start > mobile.log 2>&1 &
disown

cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/admin-ci
nohup php -S localhost:8000 > admin.log 2>&1 &
disown
```

### Method 4: systemd Services (Production)
```bash
# Create service files in /etc/systemd/system/
# See: https://www.freedesktop.org/software/systemd/man/systemd.service.html
```

---

## One-Liner Start All (Background - use nohup/disown)

```bash
# Kill existing first
pkill -f "node src/index.js" 2>/dev/null; pkill -f "php -S" 2>/dev/null; pkill -f "ng serve" 2>/dev/null

# Start backend
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/backend
nohup npm start > backend.log 2>&1 &
disown

# Start mobile (wait for backend)
sleep 2
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic
nohup npm start > mobile.log 2>&1 &
disown

# Start admin
sleep 3
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/admin-ci
nohup php -S localhost:8000 > admin.log 2>&1 &
disown

# Verify
sleep 2
echo "=== Verification ==="
curl -s http://localhost:3000/api/health && echo " - API OK"
curl -s http://localhost:5173 | grep -q "Trip Angkutan" && echo " - Mobile OK"
curl -s http://localhost:8000 | grep -q "Trip Angkutan" && echo " - Admin OK"
```

## Debugging Commands

### Check Port Status
```bash
# List all listening ports
ss -tlnp | grep -E "3000|5173|8000"

# Show process using port
lsof -i :3000
lsof -i :5173
lsof -i :8000

# Full process tree
ps aux | grep -E "node|php|ng"
```

### Health Checks
```bash
# Backend API
curl -s http://localhost:3000/api/health

# Mobile App (check HTML)
curl -s http://localhost:5173 | grep -o "Trip Angkutan" | head -1

# Admin Dashboard
curl -s http://localhost:8000 | grep -o "Trip Angkutan" | head -1

# Admin API connectivity
curl -s http://localhost:8000/api/health 2>/dev/null || echo "Admin uses PHP, not API"
```

### View Logs
```bash
# Backend logs (if running in foreground)
cd backend && npm start

# Mobile dev server logs
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic && npm start

# PHP server logs
php -S localhost:8000

# All in background with log file
php -S localhost:8000 > admin.log 2>&1 &
tail -f admin.log
```

### Test API Endpoints
```bash
# Get admin JWT
TOKEN=$(curl -s -X POST http://localhost:3000/api/auth/admin-login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' | python3 -c "import sys,json; print(json.load(sys.stdin)['token'])")

# Use token for authenticated requests
curl -s http://localhost:3000/api/trips -H "Authorization: Bearer $TOKEN"
curl -s http://localhost:3000/api/tariffs -H "Authorization: Bearer $TOKEN"
curl -s http://localhost:3000/api/reports/trips -H "Authorization: Bearer $TOKEN"
```

### Debug React Build
```bash
# Check build output
ls /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/www/

# Verify API URL in build
grep -o 'apiBaseUrl[^,}]*' /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/www/*.js 2>/dev/null | head -1

# Rebuild mobile
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic && npm run build

# Rebuild admin (copy fresh build + index.php)
cp /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/www/index.html /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/admin-ci/
cp /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/www/*.js /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/admin-ci/
cp /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/www/*.css /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/admin-ci/
cp /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/archive/admin-ci/index.php /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/admin-ci/
```

---

## Common Issues & Fixes

| Issue | Fix |
|-------|-----|
| Port already in use | `pkill -f "node\|php\|ng"` |
| **Services die after script ends** | **Use `nohup ... & disown` or `tmux`/`screen` sessions** |
| Admin shows Mobile | index.php missing → copy dari archive/admin-ci/index.php |
| Mobile shows login | localStorage has old session → clear browser storage |
| API 401 Unauthorized | Token expired → re-login or check `ensureAdminBackendSession()` |
| CORS error | Check PHP index.php has `Access-Control-Allow-Origin: *` |
| Build stale | `rm -rf www && npm run build` |
| Backend connection refused | Process died → check logs, use `nohup` or `tmux` |

---

## Quick Restart (All in One - Uses nohup for persistence)

```bash
#!/bin/bash
# Save as restart-all.sh and chmod +x

echo "🔴 Killing all services..."
pkill -f "node src/index.js" 2>/dev/null
pkill -f "php -S" 2>/dev/null
pkill -f "ng serve" 2>/dev/null
pkill -f "vite" 2>/dev/null
sleep 2

echo "🟢 Starting Backend API (3000)..."
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/backend
nohup npm start > backend.log 2>&1 &
disown
sleep 3

echo "🟢 Starting Mobile (5173)..."
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic
nohup npm start > mobile.log 2>&1 &
disown
sleep 4

echo "🟢 Starting Admin (8000)..."
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/admin-ci
cp /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/archive/admin-ci/index.php /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/admin-ci/
nohup php -S localhost:8000 > admin.log 2>&1 &
disown
sleep 2

echo "✅ Verification..."
curl -s http://localhost:3000/api/health | grep -q "ok" && echo "API: OK" || echo "API: FAIL"
curl -s http://localhost:5173 | grep -q "Trip Angkutan" && echo "Mobile: OK" || echo "Mobile: FAIL"
curl -s http://localhost:8000 | grep -q "Trip Angkutan" && echo "Admin: OK" || echo "Admin: FAIL"

echo "📋 Logs: tail -f backend.log mobile.log admin.log"
```

---

## File Locations

```
/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/
├── backend/                 # Node.js API (port 3000)
│   └── src/index.js
├── src/                     # Ionic React source
├── www/                     # Build output (Angular)
├── admin-ci/                # Admin Dashboard (PHP serve)
│   ├── index.php            # Entry point (injects data-admin)
│   ├── index.html           # Built HTML
│   ├── main-*.js            # Static JS
│   └── styles-*.css         # Static CSS
└── admin/                   # Old PHP standalone (deprecated)
```

---

## Notes

- **Mobile** (`:5173`) → Uses `ng serve`, hot reload, login petugas
- **Admin** (`:8000`) → Static PHP serve, auto-login admin via `data-admin`
- **API** (`:3000`) → Node.js/Express, JWT auth, SQLite

Both Mobile and Admin share the same React source but detect context via `data-admin` attribute injected by PHP entry point.