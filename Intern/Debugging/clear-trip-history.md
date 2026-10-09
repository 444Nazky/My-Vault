# Clear Trip History — Script & Cheatsheet

> **Tanggal:** 30 September 2026 · **File:** `Aplikasi-Trip-Ionic/clear-trip-history.sh`
> Satu perintah untuk menghapus **seluruh riwayat trip** di **server (database)**
> **dan** di **aplikasi mobile (localStorage)**.

## 🎯 Ringkasan Cepat

```bash
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic

./clear-trip-history.sh --force      # bersihkan semuanya, tanpa tanya
./clear-trip-history.sh              # mode aman: konfirmasi dulu
./clear-trip-history.sh --help       # semua opsi
```

| Yang dibersihkan | Isi |
|---|---|
| **Server (SQLite `data/trip.db`)** | `trips` · `vehicles` · `trip_vehicles` · `plate_scans` |
| **Mobile (localStorage)** | `trip.trips.v1` · `trip.trips.v2` · `trip.pendingSync` · `trip.syncQueue.v1` |
| **Tetap aman** | `regions` · `dermagas` · `routes` · `officers` · `tariffs` · `vehicle_plates`, sesi login, token, tema |

---

## ⚙️ Opsi

| Perintah | Efek |
|---|---|
| `./clear-trip-history.sh` | Konfirmasi `yes` dulu → backup → hapus → restart backend → bersihkan localStorage |
| `--force` / `-f` | Tanpa konfirmasi (untuk otomasi) |
| `--no-db` | Hanya localStorage mobile (database disentuh) |
| `--no-mobile` | Hanya database |
| `--no-restart` | Jangan restart backend (hati-hati: lihat catatan di bawah) |
| `--all-keys` | Hapus **semua** key `trip.*` → sesi/login ikut hilang, perlu login ulang |
| `--help` / `-h` | Tampilkan bantuan |

---

## 🔁 Alur Kerja Script

```
1. Backup  →  data/backups/trip_backup_<YYYYMMDD_HHMMSS>.db   (selalu, tanpa syarat)
2. Hapus   →  trip_vehicles, vehicles, trips, plate_scans      (sql.js, dari folder backend/)
3. Restart →  backend :3000 (kill → npm start → cek /api/health)
4. Mobile  →  localStorage dibersihkan lewat Chrome DevTools Protocol (:9222)
              kalau tidak ada, script MENCETAK snippet untuk DevTools / chrome://inspect
5. Verifikasi & laporan (jumlah baris, key tersisa, cara memulihkan)
```

### ⚠️ Kenapa backend ikut direstart?

Backend memakai **sql.js (SQLite di memori)** dan menulis ulang `data/trip.db`
setiap kali ada perubahan. Bila script menghapus baris **saat backend masih jalan**,
data lama di memori bisa **menimpa hasil hapus** berikutnya — itulah sebabnya
riwayat kadang “bersih sebentar lalu muncul lagi”.

> [!warning] Gejala klasik
> Script dijalankan berkali-kali tapi data “tidak pernah habis”.
> Selalu pastikan langkah `🔁 Restart backend … ✅ backend hidup lagi (:3000)` muncul.

---

## 📱 Key localStorage Aplikasi Mobile

| Key | Fungsi | Dihapus script? |
|---|---|---|
| `trip.trips.v1` | **Riwayat trip** (sumber layar History) | ✅ |
| `trip.trips.v2` | Varian lama (legacy) | ✅ |
| `trip.pendingSync` / `trip.syncQueue.v1` | Antrean sinkron offline | ✅ |
| `trip.session.v1` · `trip.officerId.v1` · `trip.userType` | Sesi login petugas | ❌ (kecuali `--all-keys`) |
| `trip.auth.token.v1` · `trip.auth.officer.v1` · `trip.auth.dermaga.v1` · `trip.auth.routes.v1` | Autentikasi & akses rute | ❌ |
| `trip.officers.v1` · `trip.officers.cache.v1` · `trip.tariffs.v1` | Cache master data | ❌ |
| `trip.admin.theme.v1` · `trip.api.baseUrl.v1` | Tema & konfigurasi | ❌ |

> Riwayat di layar History **hanya** dibaca dari `trip.trips.v1`
> (`src/pages/store.tsx` → `load(LS.trips, …)`), jadi menghapus key itu langsung
> mengosongkan History. Data **server** (laporan admin) dibersihkan lewat langkah database.

---

## 📲 Perangkat Fisik / Tanpa Chrome Debug (port 9222)

Script mencetak snippet ini — jalankan di **DevTools** (`F12 → Console`) saat aplikasi
terbuka, atau lewat `chrome://inspect` untuk perangkat Android/iOS:

```js
Object.keys(localStorage)
  .filter(k => /^trip\.(trips\.v\d+|pendingSync|syncQueue\.v\d+)$/.test(k))
  .forEach(k => localStorage.removeItem(k));
location.reload();
```

Bersihkan **semua** key (termasuk sesi → perlu login ulang):

```js
Object.keys(localStorage).filter(k => k.startsWith('trip.')).forEach(k => localStorage.removeItem(k));
location.reload();
```

### Alternatif dari dalam aplikasi
**Pengaturan → Reset Data Trip Lokal** (tombol merah):
menghapus riwayat, antrean sinkron, cache tarif & petugas lalu reload otomatis.

---

## 🩹 Memulihkan Data

```bash
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic
ls -t data/backups/*.db | head          # pilih yang berisi
cp data/backups/trip_backup_20260930_095018.db data/trip.db
./restart-all.sh                        # backend muat ulang database
```

Inventaris backup (30 Sep 2026, terbaru di atas):

| Backup | Isi |
|---|---|
| `…_102029.db` | 0 trip · 28 scan (sebelum langkah scan dibersihkan) |
| `…_101844.db` | 1 trip (uji coba) |
| `…_095018.db` | **35 trip · 54 kendaraan** ← data paling lengkap |
| `…_093725.db` · `…_092125.db` · `…_092107.db` | 34 trip · 54 kendaraan |
| `data/trip.db.bak-20260928-105358` | 18 trip (riwayat lama) |

---

## 🐛 Debugging — Riwayat "masih muncul"

| Gejala | Penyebab | Solusi |
|---|---|---|
| History mobile masih terisi | Tab belum di-reload | Refresh tab / buka ulang aplikasi |
| Data muncul lagi setelah beberapa saat | Backend **tidak direstart** (sql.js in-memory menimpa file) | Jalankan ulang tanpa `--no-restart` |
| Laporan admin masih ada isinya | Hanya localStorage yang dibersihkan | Tambah langkah database (hapus `--no-db`) |
| Script bilang "tidak ada tab browser" | Chrome DevTools (:9222) mati | Pakai snippet di atas / DevTools |
| Petugas lain masih lihat trip | Data milik petugas itu di device lain | Jalankan `--no-db`+snippet di device tersebut, atau bersihkan server |
| Salah hapus | — | Restore dari `data/backups/` (lihat atas) |

---

## ✅ Hasil Uji (30 Sep 2026)

| Uji | Hasil |
|---|---|
| `--help` & `bash -n` (sintaks) | ✅ |
| `--no-db --force` → CDP | ✅ 1 key (`trip.trips.v1`) terhapus; sesi/token/tarif **tetap ada** |
| `--force` (penuh) | ✅ backup dibuat → `trips/vehicles/trip_vehicles/plate_scans = 0` → backend restart & `/api/health` ok → localStorage bersih |
| Master data aman | ✅ `regions=6` · `officers=9` |
| `npx tsc --noEmit` · `ng lint` | ✅ 0 error · all files pass |

**Terkait:** [[tr]] (cheatsheet server & hot reload) · `restart-all.sh` (nyalakan semua layanan)
