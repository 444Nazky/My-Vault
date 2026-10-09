# Deployment Guide - Aplikasi Trip Angkutan

> [!tip] Jalankan lewat agent
> Prompt siap pakai untuk Claude Code ada di [[Deployment/Agents - Deployment|Agents - Deployment]].
> Panduan cepat: [[Deployment/Quick-Start|Quick-Start]] · detail fase: [[Deployment/Step-by-Step|Step-by-Step]]

## Overview

Aplikasi ini terdiri dari 3 komponen:
1. **Backend API** - Express.js + SQLite
2. **Admin Dashboard** - Static HTML/JS (atau PHP)
3. **Mobile App** - React/Ionic frontend

## Arsitektur Saat Ini (Local)

```
┌──────────────────┐
│ Mobile App       │
│ (localhost:5173) │
└────────┬─────────┘
         │ localhost:3000
         ▼
┌──────────────────┐
│ Backend API      │
│ (Express/SQLite) │
└──────────────────┘

┌──────────────────┐
│ Admin Dashboard  │
│ (localhost:8000) │
└──────────────────┘
```

## Arsitektur Target (Production)

```
┌─────────────┐     ┌─────────────┐     ┌──────────────────┐
│ Mobile App │────▶│ Backend API │◀────│ Admin Dashboard   │
│ (Users)    │     │ (Cloud)     │     │ (Static/PHP)     │
└─────────────┘     └─────────────┘     └──────────────────┘
```

---

## Opsi Deploy Backend

### Opsi 1: VPS (Virtual Private Server) - Recommended

**Pilihan VPS Murah:**
- DigitalOcean Droplet ($4/bulan)
- Vultr ($5/bulan)
- Linode ($5/bulan)
- AWS EC2 (Free Tier)
- Google Cloud (Free Tier)

#### Setup di VPS Ubuntu 22.04:

```bash
# 1. SSH ke server
ssh root@your-server-ip

# 2. Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# 3. Install PM2 (process manager)
npm install -g pm2

# 4. Create app directory
mkdir -p /var/www/trip-api
cd /var/www/trip-api

# 5. Upload code (via git atau scp)
# git clone https://github.com/your-repo/backend.git .
# atau
# scp -r ./backend/* root@your-server:/var/www/trip-api/

# 6. Install dependencies
npm install --production

# 7. Setup environment
cat > .env << EOF
PORT=3000
NODE_ENV=production
EOF

# 8. Start dengan PM2
pm2 start src/index.js --name trip-api
pm2 startup
pm2 save

# 9. Setup firewall
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 3000
```

#### Setup Nginx Reverse Proxy:

```bash
sudo apt install nginx

sudo cat > /etc/nginx/sites-available/trip-api << EOF
server {
    listen 80;
    server_name api.tripangkut.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/trip-api /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

#### Setup SSL (Let's Encrypt):

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d api.tripangkut.com
```

**Result:** Backend accessible di `https://api.tripangkut.com`

---

### Opsi 2: Railway.app (Gratis Tier)

1. Buka https://railway.app
2. Login with GitHub
3. New Project → Deploy from GitHub repo
4. Pilih repo backend
5. Railway auto-detect Node.js
6. Set environment variables di dashboard
7. Deploy!

**Result:** Backend accessible di `https://trip-api.up.railway.app`

**Free Tier Limits:**
- 500 hours/month
- 1GB RAM
- Shared CPU

---

### Opsi 3: Render.com (Gratis Tier)

1. Buka https://render.com
2. Login with GitHub
3. New → Web Service
4. Connect GitHub repo
5. Settings:
   - Build Command: `npm install`
   - Start Command: `pm2 start src/index.js`
6. Add Environment Variables
7. Deploy!

**Result:** Backend accessible di `https://trip-api.onrender.com`

---

### Opsi 4: Fly.io (Gratis Tier)

```bash
# Install flyctl
curl -L https://fly.io/install.sh | sh

# Login
fly auth login

# Create app
cd ~/RPL/Intern/Aplikasi-Trip-Ionic/backend
fly launch

# Set secrets
fly secrets set PORT=3000

# Deploy
fly deploy
```

**Result:** Backend accessible di `https://trip-api.fly.dev`

---

## Opsi Deploy Admin Dashboard

### Opsi 1: Vercel (Recommended - Gratis)

1. Buka https://vercel.com
2. Login with GitHub
3. New Project → Import admin-ci folder
4. Deploy!

**atau via CLI:**
```bash
npm i -g vercel
cd ~/RPL/Intern/Aplikasi-Trip-Ionic/admin-ci
vercel --prod
```

**Result:** Admin accessible di `https://admin-trips.vercel.app`

---

### Opsi 2: Netlify (Gratis)

```bash
npm i -g netlify-cli
cd ~/RPL/Intern/Aplikasi-Trip-Ionic/admin-ci
netlify deploy --prod
```

**Result:** Admin accessible di `https://trip-admin.netlify.app`

---

### Opsi 3: Shared Hosting (PHP cPanel)

1. Compress admin-ci folder
2. Upload via cPanel File Manager atau FTP
3. Extract di public_html/
4. Done!

---

### Opsi 4: VPS dengan Nginx

```bash
sudo apt install nginx php-fpm

sudo cat > /etc/nginx/sites-available/admin << EOF
server {
    listen 80;
    server_name admin.tripangkut.com;
    root /var/www/admin;
    index index.html index.php;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/admin /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

---

## Update Mobile App untuk Production

### 1. Update API Base URL

Edit `src/config/index.ts` atau `.env`:

```typescript
// Development
const API_BASE = 'http://localhost:3000';

// Production - Ganti dengan URL backend Anda
const API_BASE = 'https://api.tripangkut.com';
```

### 2. Build Production

```bash
cd ~/RPL/Intern/Aplikasi-Trip-Ionic

# Development build
ionic build

# Production build
ionic build --prod
```

### 3. Build APK Android

```bash
# Add android platform (jika belum)
ionic cap add android

# Sync web assets
ionic cap sync android

# Open in Android Studio
ionic cap open android

# Atau build APK langsung
cd android
./gradlew assembleDebug    # Debug APK
./gradlew assembleRelease  # Release APK (butuh signing key)
```

### 4. Signing APK untuk Play Store

1. Generate keystore:
```bash
keytool -genkey -v -keystore my-release-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000
```

2. Setup di `android/app/build.gradle`:
```groovy
android {
    signingConfigs {
        release {
            storeFile file('my-release-key.keystore')
            storePassword 'password'
            keyAlias 'my-key-alias'
            keyPassword 'password'
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

---

## Deploy Checklist

### Backend
- [ ] Pilih hosting provider
- [ ] Upload/deploy code
- [ ] Setup environment variables
- [ ] Test endpoint: `https://api.yourdomain.com/api/health`
- [ ] Setup domain (optional)
- [ ] Setup SSL

### Admin Dashboard
- [ ] Pilih hosting provider
- [ ] Upload/deploy static files
- [ ] Update API URL di config
- [ ] Test login

### Mobile App
- [ ] Update API_BASE ke URL production
- [ ] Build web assets
- [ ] Sync ke Capacitor
- [ ] Build APK
- [ ] Test di device
- [ ] (Optional) Upload ke Play Store

---

## Biaya Estimasi

| Komponen | Opsi | Biaya/Bulan |
|----------|------|-------------|
| Backend API | VPS (DigitalOcean) | $4-6 |
| Backend API | Railway | $0 (free tier) |
| Backend API | Render | $0 (free tier) |
| Backend API | Fly.io | $0 (free tier) |
| Admin Dashboard | Vercel | $0 |
| Admin Dashboard | Netlify | $0 |
| Domain | .com/.id | $10-15/tahun |
| SSL | Let's Encrypt | $0 |
| **Total** | | **$0-6/bulan** |

---

## Environment Variables

Backend (.env):
```
NODE_ENV=production
PORT=3000
# Optional
JWT_SECRET=your-secret-key
CORS_ORIGIN=https://yourdomain.com
```

Mobile App (.env):
```
VITE_API_URL=https://api.yourdomain.com
```

---

## Troubleshooting

### CORS Error
Pastikan backend set CORS untuk domain Anda:
```javascript
app.use(cors({
  origin: ['https://yourdomain.com', 'capacitor://localhost']
}));
```

### Mobile App Tidak Connect
1. Cek API_BASE URL sudah benar
2. Cek backend sudah running
3. Cek CORS settings
4. Test dengan Postman/curl

### Build Failed
```bash
npm cache clean --force
rm -rf node_modules
npm install
ionic cap sync android
```

---

*Document created: 2024*
*Last updated: 2024*
