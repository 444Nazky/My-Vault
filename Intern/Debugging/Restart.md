# Script Automasi Restart Layanan (restart-all.sh)

Script bash ini digunakan untuk menghentikan seluruh layanan yang sedang berjalan, menyalakannya kembali secara berurutan beserta direktori kerjanya, lalu melakukan verifikasi otomatis terhadap status kesehatan server (*health check*).

```bash
#!/bin/bash

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

echo "Verification..."
curl -s http://localhost:3000/api/health | grep -q "ok" && echo "API: OK" || echo "API: FAIL"
curl -s http://localhost:5173 | grep -q "Trip Angkutan" && echo "Mobile: OK" || echo "Mobile: FAIL"
curl -s http://localhost:8000 | grep -q "Trip Angkutan" && echo "Admin: OK" || echo "Admin: FAIL"

echo "Logs: tail -f backend.log mobile.log admin.log"

```

### Cara Setup

1. Simpan kode di atas ke dalam file `restart-all.sh`.
2. Berikan izin eksekusi melalui terminal:
```bash
chmod +x restart-all.sh

```


3. Jalankan script:
```bash
./restart-all.sh

```



---

## 2. Perintah Tambahan Debugging & Log

### Cek Port Aktif

Gunakan jika port `3000`, `5173`, atau `8000` masih tersangkut:

```bash
sudo lsof -i :3000
sudo lsof -i :5173
sudo lsof -i :8000

```

### Hentikan Paksa Port (Kill Port)

```bash
sudo fuser -k 3000/tcp
sudo fuser -k 5173/tcp
sudo fuser -k 8000/tcp

```

### Pantau Log Real-Time

```bash
# Pantau semua log sekaligus
tail -f backend.log mobile.log admin.log

# Pantau spesifik
tail -f backend.log
tail -f mobile.log
tail -f admin.log

```