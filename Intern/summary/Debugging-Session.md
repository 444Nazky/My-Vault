# Debugging Session - Port 4200 Conflict

Tanggal: 25 September 2026

---

## Masalah

### Gejala
- Port 4200 sebelumnya running tapi men-serving mobile app (bukan React admin)
- Seharusnya port 4200 tidak digunakan sama sekali
- Setup yang benar adalah: 3000 (API), 5173 (Mobile), 8000 (Admin)

### Kesalahan yang Dilakukan

**Saya (Claude) memulai server Python di port 4200:**
```bash
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/www && python3 -m http.server 4200 &
```

**Mengapa ini salah:**
1. Port 4200 TIDAK ada dalam arsitektur proyek
2. Ini menyebabkan kebingungan karena ada service "tambahan" yang tidak diperlukan
3. User mengharapkan port 8000 untuk admin, tapi ada interference dari service port 4200

---

## Setup Port yang BENAR

| Service | Port | URL |
|---------|------|-----|
| Backend API | 3000 | http://localhost:3000 |
| Mobile App | 5173 | http://localhost:5173 |
| Admin Dashboard | 8000 | http://localhost:8000 |

**Port 4200 TIDAK PERNAH boleh running!**

---

## Cara Fix

### 1. Kill semua port yang tidak perlu

```bash
# Kill port 4200
pkill -f "python3 -m http.server 4200" 2>/dev/null

# Atau lebih spesifik
lsof -ti:4200 | xargs kill -9 2>/dev/null

# Verify port bersih
lsof -i :4200 || echo "Port 4200 sudah bersih"
```

### 2. Verifikasi semua port yang seharusnya running

```bash
echo "=== Status Semua Port ==="
curl -s http://localhost:3000/api/health && echo " - Backend API OK"
curl -s -o /dev/null -w "%{http_code}" http://localhost:5173 && echo " - Mobile App OK"
curl -s -o /dev/null -w "%{http_code}" http://localhost:8000 && echo " - Admin Dashboard OK"
```

---

## Lesson Learned

### 1. Jangan tambahkan service baru tanpa konfirmasi
**Sebelum:** Langsung jalankan service di port baru
**Sesudah:** Cek dulu arsitektur yang sudah ada, tanya user jika tidak yakin

### 2. Cek port sebelum mulai service baru
```bash
# Selalu cek dulu sebelum start
lsof -i :PORT_YANG_MAU_DIGUNAKAN
```

### 3. Dokumentasi adalah kebenaran
Jangan asumsikan port baru diperlukan. Arsitektur sudah fix:
- 3000 = API
- 5173 = Mobile
- 8000 = Admin

### 4. Jika service tidak jalan (port 4200 mati), jangan "perbaiki" dengan menambah service baru
Cek dulu kenapa service tidak jalan, bukan tambahkan service baru.

---

## Checklist Sebelum Debugging

- [ ] Cek port yang sedang running (`lsof -i :3000 -i :5173 -i :8000`)
- [ ] Verifikasi semua port yang seharusnya running
- [ ] Jangan start service baru tanpa konfirmasi arsitektur
- [ ] Jika port tidak jalan, tanya user - jangan assumsi

---

## Restart All Services (One Liner)

```bash
# Kill existing
pkill -f "node src/index.js" 2>/dev/null
pkill -f "php -S" 2>/dev/null
pkill -f "ng serve" 2>/dev/null
pkill -f "vite" 2>/dev/null
# Pastikan port 4200 TIDAK di-start
sleep 2

# Start backend (3000)
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/backend && npm start &
sleep 2

# Start mobile (5173)
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic && npm start &
sleep 3

# Start admin (8000)
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/admin-ci && php -S localhost:8000 &

# Verify
sleep 2
curl -s http://localhost:3000/api/health && echo " - API"
curl -s -o /dev/null -w "%{http_code}" http://localhost:5173 && echo " - Mobile"
curl -s -o /dev/null -w "%{http_code}" http://localhost:8000 && echo " - Admin"
```
