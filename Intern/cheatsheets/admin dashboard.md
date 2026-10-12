# Admin Dashboard - Cheatsheet

## Update Terbaru: Fitur Geofencing di Master Rute

**Tanggal:** 12 Oktober 2026  
**URL:** https://aplikasi-trip.web.app

---

## Apa yang Ditambahkan

### Fitur Geofencing di Halaman Master Rute

1. **Tombol "Geofence"** di setiap baris tabel rute
2. **Modal Panel** untuk mengelola titik lokasi geofence
3. **Google Maps URL Parser** - otomatis extract koordinat dari short link maupun full URL
4. **Preview Peta** dari OpenStreetMap
5. Data tersimpan ke tabel `geofences` di backend

---

## Cara Penggunaan

### 1. Menambah Titik Geofence

```
1. Buka halaman Master Rute
2. Klik tombol "Geofence" (warna hijau) di baris rute
3. Klik "Tambah Titik Geofence"
4. Paste URL Google Maps, contoh:
   https://maps.app.goo.gl/1Gsfc4xo2wGbpf3k9
5. Klik "Isi Otomatis" → koordinat terisi otomatis
6. Atau isi manual: Latitude, Longitude
7. Isi Nama Lokasi dan Radius (meter)
8. Klik "Simpan"
```

### 2. Edit Titik Geofence

```
1. Buka panel geofence rute
2. Klik ikon pensil di titik yang ingin diedit
3. Modifikasi data
4. Klik "Simpan"
```

### 3. Hapus Titik Geofence

```
1. Buka panel geofence rute
2. Klik ikon trash di titik yang ingin dihapus
3. Konfirmasi penghapusan
```

---

## Struktur Data

### Tabel: `geofences`

| Kolom | Tipe | Deskripsi |
|-------|------|----------|
| `id` | TEXT | UUID unik |
| `location_name` | TEXT | Nama lokasi |
| `latitude` | REAL | Koordinat latitude |
| `longitude` | REAL | Koordinat longitude |
| `radius_meters` | INTEGER | Radius validasi (default: 100) |
| `allowed_route_codes` | TEXT | Kode rute yang diizinkan (koma-separated) |
| `allowed_directions` | TEXT | Arah rute (koma-separated) |
| `description` | TEXT | Keterangan opsional |

---

## URL Google Maps yang Didukung

### Short Link
```
https://maps.app.goo.gl/1Gsfc4xo2wGbpf3k9
```

### Full URL dengan Koordinat
```
https://www.google.com/maps/@-6.1891,106.8371,17z
```

### Place URL
```
https://www.google.com/maps/place/Nama+Lokasi/@-6.1891,106.8371,17z
```

### URL dengan Query
```
https://www.google.com/maps?q=-6.1891,106.8371
```

---

## File yang Dimodifikasi

### Frontend (Admin Dashboard)

| File | Perubahan |
|------|-----------|
| `src/pages/admin/tabs/RoutesTab.tsx` | +380 baris: modal panel geofence |
| `src/pages/admin/components/types.ts` | Tipe `GeofencePoint` dan `RouteFormState` extended |
| `src/services/geofences.ts` | Fungsi CRUD untuk route-linked geofence |
| `src/services/geo.ts` | Parser URL Google Maps (sudah ada) |

### Backend (Sudah Ada, Tidak Diubah)

| Endpoint | Method | Deskripsi |
|----------|--------|-----------|
| `/api/geofences` | GET | Ambil semua titik geofence |
| `/api/geofences` | POST | Tambah titik baru (admin) |
| `/api/geofences/:id` | PUT | Update titik (admin) |
| `/api/geofences/:id` | DELETE | Hapus titik (admin) |

---

## Sinkronisasi Mobile

Data geofence otomatis tersedia untuk mobile app melalui:
- Endpoint: `GET /api/geofences` (publik untuk petugas)
- Mobile menarik via `syncGeofenceConfig()`
- Tersimpan offline: `trip.geofence.config.v1`
- Validasi geofence berjalan offline-first

---

## Command Deployment

```bash
# 1. Build
cd "/home/nazky/RPL/Intern/Trip-Dashboard Admin Branch"
npm run build

# 2. Deploy ke Firebase
npx firebase deploy --only hosting

# 3. Verifikasi TypeScript
npx tsc --noEmit

# 4. Update Graph (code knowledge)
graphify update .
```

---

## Troubleshooting

### "Short link gagal di-resolve"
- Buka link di browser baru
- Copy URL penuh dari address bar
- Paste URL penuh ke form

### Data tidak tampil di mobile
- Pastikan endpoint `/api/geofences` mengembalikan data
- Cek tabel `geofences` di database backend
- Mobile perlu pull data baru saat online

### Error TypeScript
```bash
npx tsc --noEmit
```
Pastikan tidak ada error sebelum build.

---

## Referensi

- README.md - Struktur project
- `src/services/geo.ts` - Parser URL Google Maps
- `src/services/geofences.ts` - Service API
- `src/pages/admin/tabs/RoutesTab.tsx` - UI Component
- `endpoint-trip/src/routes/geofences.js` - Backend API
