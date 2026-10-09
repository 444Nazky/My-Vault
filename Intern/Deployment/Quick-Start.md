# Quick Start - Deploy Trip Angkutan

## Prerequisites
- [ ] Akun Railway/Render/Fly.io (free)
- [ ] Akun Vercel/Netlify (free)
- [ ] (Optional) VPS $4-6/bulan

---

## Phase 1: Deploy Backend (15 menit)

### Opsi A: Railway (Recommended - Gratis)
```
1. Buka https://railway.app
2. Login with GitHub
3. New Project → Deploy from GitHub repo
4. Pilih repo backend
5. Tunggu deploy selesai
6. Copy URL (contoh: https://trip-api.up.railway.app)
```

### Opsi B: Render
```
1. Buka https://render.com
2. Login with GitHub
3. New → Web Service
4. Connect GitHub repo
5. Start Command: npm start
6. Deploy!
```

### Opsi C: Fly.io
```bash
curl -L https://fly.io/install.sh | sh
fly auth login
cd backend
fly launch
fly deploy
```

### Opsi D: VPS
```bash
# SSH ke server
ssh root@your-ip

# Install Node.js & PM2
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs
npm install -g pm2

# Upload code & start
pm2 start src/index.js --name trip-api
```

**Test Backend:**
```bash
curl https://your-backend-url.up.railway.app/api/health
# Should return: {"status":"ok",...}
```

---

## Phase 2: Deploy Admin Dashboard (5 menit)

### Vercel
```bash
npm i -g vercel
cd admin-ci
vercel --prod
```

### Netlify
```bash
npm i -g netlify-cli
cd admin-ci
netlify deploy --prod --dir=.
```

---

## Phase 3: Update Mobile App (10 menit)

### 1. Update API URL
```typescript
// src/config/index.ts atau .env
VITE_API_URL=https://your-backend-url.up.railway.app
```

### 2. Build APK
```bash
ionic build
ionic cap sync android
ionic cap open android
# Build APK di Android Studio
```

---

## Timeline

| Phase | Task | Waktu |
|-------|------|-------|
| 1 | Deploy Backend | 15 min |
| 2 | Deploy Admin | 5 min |
| 3 | Update Mobile | 10 min |
| 4 | Test | 10 min |
| **Total** | | **~40 menit** |

---

## Biaya

| Service | Plan | Biaya |
|---------|------|-------|
| Railway | Free Tier | $0 |
| Render | Free Tier | $0 |
| Fly.io | Free Tier | $0 |
| Vercel | Hobby | $0 |
| Netlify | Free | $0 |
| **Total** | | **$0** |

---

## URLs Setelah Deploy

```
Backend API:  https://trip-api.up.railway.app
Admin:        https://trip-admin.vercel.app
Mobile APK:   (install manual / Play Store)
```

---

## Troubleshooting

### Backend 500 Error
```bash
# Check logs di Railway/Render dashboard
# atau
pm2 logs
```

### CORS Error
Tambah di backend `src/index.js`:
```javascript
app.use(cors({
  origin: ['https://your-admin-url.vercel.app']
}));
```

### Mobile Build Failed
```bash
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
ionic cap sync android
```

---

*Quick start - untuk detail lengkap lihat Deployment-Guide.md*
