# Step-by-Step Deployment Guide - Trip Angkutan

## Target Architecture

```
┌─────────────┐
│   HP Anda   │◀── Install APK
└─────────────┘
       │
       │ Internet
       ▼
┌─────────────────────────────────────┐
│  Railway (Backend API)              │
│  https://trip-api.up.railway.app   │
└─────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────┐
│  Vercel (Admin Dashboard)           │
│  https://trip-admin.vercel.app      │
└─────────────────────────────────────┘
```

---

## PHASE 1: Persiapan

### 1.1 Buat GitHub Repository

1. Buka https://github.com
2. Login → New Repository
3. Nama: `Aplikasi-Trip-Ionic`
4. Private → Create Repository
5. Copy repository URL

### 1.2 Push Code ke GitHub

```bash
cd ~/RPL/Intern/Aplikasi-Trip-Ionic

# Initialize git (jika belum)
git init
git add .
git commit -m "Initial commit"

# Add remote
git remote add origin https://github.com/YOUR_USERNAME/Aplikasi-Trip-Ionic.git
git branch -M main
git push -u origin main
```

### 1.3 Buat FolderTerpisah untuk Deploy

```bash
# Buat folder deployment
mkdir -p ~/Deployment-Trip

# Copy project
cp -r ~/RPL/Intern/Aplikasi-Trip-Ionic ~/Deployment-Trip/
cd ~/Deployment-Trip/Aplikasi-Trip-Ionic

# Hapus node_modules (akan diinstall ulang)
rm -rf node_modules backend/node_modules
```

---

## PHASE 2: Deploy Backend ke Railway

### 2.1 Daftar Railway

1. Buka https://railway.app
2. Klik "Login" → "Login with GitHub"
3. Berikan akses ke repository GitHub

### 2.2 Buat Project Baru

1. Di Railway Dashboard → "New Project"
2. Pilih **"Deploy from GitHub repo"**
3. Cari dan pilih repository `Aplikasi-Trip-Ionic`
4. Klik pada repository untuk deploy

### 2.3 Configure Backend Deployment

1. Railway akan deploy otomatis, tapi kita perlu set root directory
2. Klik pada deployment → "Settings"
3. **Root Directory**: `backend`
4. **Build Command**: `npm install`
5. **Start Command**: `npm start`

### 2.4 Tunggu Deploy

1. Lihat progress di tab "Deployments"
2. Tunggu sampai status "Deployed" (biasanya ~2 menit)
3. Copy URL deployment (contoh: `https://trip-api.up.railway.app`)

### 2.5 Verifikasi Backend

Buka browser, test endpoint:

```
https://trip-api.up.railway.app/api/health
```

Harus muncul:
```json
{"status":"ok","timestamp":"2024-..."}
```

### 2.6 Test Login Endpoint

```
https://trip-api.up.railway.app/api/auth/login
```

---

## PHASE 3: Deploy Admin Dashboard ke Vercel

### 3.1 Daftar Vercel

1. Buka https://vercel.com
2. Klik "Sign Up" → "Continue with GitHub"
3. Berikan akses ke repository

### 3.2 Deploy Admin

1. Di Vercel Dashboard → "Add New" → "Project"
2. Import repository `Aplikasi-Trip-Ionic`
3. **Root Directory**: `admin-ci`
4. **Framework Preset**: "Other"
5. **Build Command**: (kosongkan)
6. **Output Directory**: `.` (titik)
7. Click "Deploy"

### 3.3 Tunggu Deploy

1. Lihat progress deployment
2. Setelah selesai, dapat URL seperti: `https://trip-admin.vercel.app`

### 3.4 Update Admin Config

Setelah deploy, perlu update API URL:

1. Buka repository di GitHub
2. Edit file `admin-ci/assets/config.js` atau `admin-ci/js/config.js`
3. Ubah `API_BASE` ke URL Railway:

```javascript
// Sebelum (local)
const API_BASE = 'http://localhost:3000';

// Sesudah (production)
const API_BASE = 'https://trip-api.up.railway.app';
```

4. Commit & Push
5. Vercel auto-redeploy

---

## PHASE 4: Update Mobile App

### 4.1 Update API URL

1. Buka `src/services/auth.ts` atau `src/services/api.ts`
2. Ubah API_BASE:

```typescript
// Development
const API_BASE = 'http://localhost:3000';

// Production - Ganti dengan URL Railway Anda
const API_BASE = 'https://trip-api.up.railway.app';
```

Atau gunakan environment variable:

```typescript
const API_BASE = import.meta.env.VITE_API_URL || 'http://localhost:3000';
```

### 4.2 Buat File Environment

Buat file `.env.production`:

```
VITE_API_URL=https://trip-api.up.railway.app
```

### 4.3 Build Mobile App

```bash
cd ~/Deployment-Trip/Aplikasi-Trip-Ionic

# Install dependencies
npm install

# Build for production
npm run build
# atau
ionic build --prod
```

---

## PHASE 5: Export APK ke HP

### 5.1 Setup Android SDK (jika belum)

```bash
# Install Android SDK
sudo apt install openjdk-17-jdk

# Download command line tools
mkdir -p ~/android-sdk/cmdline-tools
cd ~/android-sdk/cmdline-tools
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip commandlinetools-linux-11076708_latest.zip
mv cmdline-tools latest

# Set environment
export ANDROID_HOME=~/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# Accept licenses
yes | sdkmanager --licenses
```

### 5.2 Add Capacitor Android

```bash
cd ~/Deployment-Trip/Aplikasi-Trip-Ionic

# Add android platform
npx cap add android

# Sync web assets
npx cap sync android
```

### 5.3 Build Debug APK

```bash
# Open in Android Studio
npx cap open android

# Atau build langsung dari terminal
cd android
./gradlew assembleDebug
```

APK akan ada di:
```
android/app/build/outputs/apk/debug/app-debug.apk
```

### 5.4 Transfer ke HP

**cara 1: Via USB**
1. Connect HP ke komputer
2. Copy APK ke HP storage
3. Install di HP (enable "Install from unknown sources" dulu)

**cara 2: Via Adb**
```bash
adb install android/app/build/outputs/apk/debug/app-debug.apk
```

**cara 3: Via Local Network**
```bash
# Start local server
python3 -m http.server 8000 --directory android/app/build/outputs/apk/debug

# Di HP browser:
# http://YOUR_PC_IP:8000/app-debug.apk
```

**cara 4: Via QR Code (Android Studio)**
1. Open project di Android Studio
2. Run → Run 'app' (pilih device/HP)
3. Pilih HP yang connected via USB
4. APK auto-install ke HP

### 5.5 Enable Install Unknown Apps

Di HP Android:
1. Settings → Security
2. "Unknown sources" atau "Install unknown apps"
3. Enable untuk Browser atau File Manager

### 5.6 Install APK

1. Buka File Manager di HP
2. Cari file `app-debug.apk`
3. Tap untuk install
4. Done! App siap digunakan

---

## PHASE 6: Verifikasi Semua Berfungsi

### 6.1 Test di HP

1. Buka app Trip Angkutan
2. Login dengan credentials officer
3. Buat trip baru
4. Record kendaraan
5. Cek data muncul di Admin Dashboard

### 6.2 Test Admin Dashboard

1. Buka browser HP/PC: `https://trip-admin.vercel.app`
2. Login dengan admin credentials
3. Cek data trip

### 6.3 Checklist

- [ ] Backend running di Railway
- [ ] Admin Dashboard accessible
- [ ] Mobile app connect ke Railway backend
- [ ] Login berfungsi
- [ ] Create trip berfungsi
- [ ] Record kendaraan berfungsi
- [ ] Data muncul di Admin

---

## PHASE 7: Custom Domain (Optional)

### 7.1 Beli Domain

Beli di:
- Niagahoster (~Rp 50.000/tahun)
- Namecheap ($10/tahun)
- Google Domains

### 7.2 Setup DNS

Di provider domain:
```
# A Record
@ → Railway IP atau CNAME ke railway.app

# Contoh untuk api.tripangkut.com
api → trip-api.up.railway.app
admin → cname.vercel-dns.com
```

### 7.3 Update URLs

```typescript
// Mobile app
const API_BASE = 'https://api.tripangkut.com';
```

---

## Troubleshooting

### Backend 500 Error di Railway

```bash
# Check logs
# Di Railway Dashboard → Deployment → Logs

# Common issues:
# - Missing dependencies → npm install
# - Port not set → Pastikan PORT=3000
# - Database not found → Cek path database
```

### CORS Error

Tambah di `backend/src/index.js`:

```javascript
app.use(cors({
  origin: ['https://trip-admin.vercel.app', 'capacitor://localhost']
}));
```

Redeploy Railway setelah edit.

### Mobile App Connect Failed

1. Pastikan HP terhubung internet
2. Cek URL API sudah benar
3. Test dengan Postman/curl dulu
4. Cek logs di browser DevTools

### APK Install Failed

1. Enable "Unknown sources" di Settings
2. HP mungkin block install dari sumber tidak dikenal
3. Cek storage HP cukup

---

## Command Reference

```bash
# === BACKEND ===
# Deploy ke Railway
# (via Railway Dashboard UI)

# Check backend logs
# (Railway Dashboard → Deployment → Logs)

# === ADMIN ===
# Deploy ke Vercel
vercel --prod

# === MOBILE ===
# Build
ionic build
npx cap sync android

# Open in Android Studio
npx cap open android

# Build APK
cd android && ./gradlew assembleDebug

# Install via ADB
adb install android/app/build/outputs/apk/debug/app-debug.apk

# === GIT ===
# Push changes
git add .
git commit -m "Update API URL"
git push origin main
```

---

## URLs清单

```
Backend API:  https://trip-api.up.railway.app
Admin Panel:  https://trip-admin.vercel.app
Mobile App:   (APK di HP)
```

---

## Biaya

| Service | Plan | Biaya |
|---------|------|-------|
| Railway | Starter | $0 |
| Vercel | Hobby | $0 |
| Domain (optional) | .com | $10/tahun |
| **Total** | | **$0-10** |

---

*Step-by-step guide - Mulai dari Phase 1!*
