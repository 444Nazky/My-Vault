# Agent Explanation - Aplikasi Trip Ionic

## Masalah Routing Server yang Saya Bingungkan

### Kesalahan Pemahaman Awal

Saya sebelumnya bingung dengan arsitektur aplikasi karena tidak memahami bagaimana file-file di-serve ke browser. Berikut penjelasannya:

### Arsitektur Aplikasi

```
Aplikasi-Trip-Ionic/
├── src/                    # Source code React/TypeScript
│   ├── pages/
│   │   └── admin/
│   │       ├── AdminDashboard.tsx    # Admin dashboard component
│   │       └── ReportSheet.tsx       # Spreadsheet laporan
│   └── services/
├── www/                    # Built output (production build)
├── admin-ci/                # Production build untuk admin dashboard
└── archive/
    └── admin-ci/           # Original PHP-style admin (deprecated)
```

### Port Configuration

| Port | Service | Description |
|------|---------|-------------|
| **3000** | Backend API | Node.js/Express API server |
| **5173** | Mobile Dev | Angular dev server untuk mobile app |
| **8000** | Admin Dashboard | PHP static file server untuk admin-ci build |

### Bagaimana Admin Dashboard Bekerja

1. **Build Process**: `npm run build` meng-compile React/TypeScript di `src/` ke folder `www/`
2. **Admin Build**: File di `www/` di-copy ke `admin-ci/`
3. **PHP Wrapper**: `admin-ci/index.php` menambahkan atribut `data-admin` ke HTML dan serve static files
4. **React Detection**: App.tsx mengecek `document.querySelector('[data-admin]')` untuk memutuskan apakah menampilkan AdminDashboard atau MobileApp

### Script Restart All Services

```bash
# Backend API (port 3000)
cd backend && npm start

# Mobile Dev Server (port 5173)
npm start

# Admin Dashboard (port 8000)
cd admin-ci && php -S localhost:8000
```

### Key Files

- **AdminDashboard.tsx** - Main admin component dengan sidebar dan tabs
- **ReportSheet.tsx** - Spreadsheet laporan dengan thumbnail foto dan tautan Maps
- **index.php** (admin-ci) - PHP wrapper yang menambahkan `data-admin` attribute

### Kesimpulan

Admin dashboard adalah **single React app** yang:
1. Di-build ke folder `www/`
2. Di-copy ke `admin-ci/`
3. Di-serve oleh PHP server di port 8000
4. PHP menambahkan `data-admin` attribute agar React tahu ini mode admin
5. React component AdminDashboard.tsx dirender berdasarkan attribute tersebut

---

## Apa yang Saya Pelajari

1. **Single Page Application dengan Multiple Entry Points**: Satu codebase React serve ke mobile dan admin
2. **Server-side Detection**: PHP menambahkan HTML attribute yang dibaca client-side JavaScript
3. **Build Pipeline**: Build output perlu di-copy manual antar folder untuk deployment
4. **Port Configuration**: Setiap service (API, mobile, admin) berjalan di port berbeda

---

## Update ReportSheet.tsx

### Fitur yang Ditambahkan

1. **Kolom Foto** - Thumbnail 28x28px dengan lightbox modal
2. **Kolom Lokasi** - Koordinat GPS dengan tautan Google Maps

### Changes Made

- Added `ThumbnailCell` component untuk render foto sebagai thumbnail
- Added `fotoUrl()` helper function
- Added `fmtCoords()` untuk format koordinat
- Added `gmapsUrl()` untuk generate Google Maps link
- Updated `vehHeader` dengan kolom 'Foto' dan 'Lokasi'
- Updated `vehMatrix` dengan data foto dan koordinat
- Updated CSS untuk lightbox modal

### Files Modified

- `/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/src/pages/admin/ReportSheet.tsx`
- `/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/src/pages/admin/AdminDashboard.tsx` (minor fixes)

### Build Process

```bash
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic
npm run build  # Build ke www/
cp -r www/* admin-ci/  # Copy ke admin-ci untuk deployment
```

---

## Kesalahan Agent & Perbaikan (2026-10-12) — Audit Geofence/Petugas/OTA

### Context
Sesi ini: audit penuh untuk menyelesaikan 3 masalah dari README (`current problem`) — geofencing master, sinkronisasi petugas baru, dan overhaul OTA. Kesalahan-kesalahan di bawah terjadi saat implementasi, dan cara mengatasinya dicatat agar tidak terulang.

### Kesalahan 1: Sintaks TS di file JS backend
- **Apa yang salah**: menulis `new Set<string>()` di `endpoint-trip/backend/src/routes/officers.js` (JavaScript murni, CommonJS). Sintaks generic TypeScript langsung `SyntaxError` saat `node --check`.
- **Penyebab**: kebiasaan menulis di file `.ts` mobile; tidak memeriksa ekstensi/ekosistem file target.
- **Cara mengatasi**: hapus generic → `new Set()`; sejak itu selalu tandai ekosistem target (TS vs JS, ESM vs CommonJS) sebelum edit, dan jalankan `node --check` untuk setiap file JS yang diedit sebagai gerbang minimum.

### Kesalahan 2: Fitur baru tidak terhubung (missing glue)
- **Apa yang salah**: `syncGeofenceConfig()` dibuat di mobile `geofence.ts`, tapi tidak ada pemanggil apa pun — config hasil sync tidak pernah dipakai `location.ts`. Typecheck lulus, fitur mati secara diam-diam.
- **Penyebab**: berhenti di “kode compiles” tanpa menelusuri alur pemakaian end-to-end.- **Cara mengatasi**: tanya ulang sebelum klaim selesai: “siapa yang memanggil fungsi baru ini dan kapan?” Fix: panggil dari `adminPull.syncOnResume()` dan refactor `location.ts` dari konstanta statis ke pembacaan config hasil sync (`activeConfig()`).

### Kesalahan 3: Path bug pada `cd` beruntun
- **Apa yang salah**: `cd "A" && x ; cd "B" && y` — `cd "B"` dieksekusi relatif dari dalam A, bukan project root → “No such file or directory” pada beberapa command verifikasi.
- **Cara mengatasi**: gunakan path absolut untuk cd beruntun (`/home/nazky/RPL/Intern/...`) atau pecah command verifikasi per direktori.

### Kesalahan 4: Typo heading README (paste artifact)
- **Apa yang salah**: heading README sempat memuat karakter non-Latin dari paste.
- **Cara mengatasi**: koreksi segera + verifikasi via grep. Pelajaran: selalu baca ulang file hasil edit besar sebelum menyatakan selesai.

### Kesalahan 5 (proses): lupa verifikasi berulang pasca-repair
- Setiap kali ada file yang direvisi setelah pengecekan awal (mis. `location.ts` setelah tsc lulus pertama), hasil lama TIDAK lagi berlaku — jalankan ulang check yang terdampak (tsc/vitest/node-check). Sesi ini tsc final dijalankan ulang 2× karena ada edit berlanjut.

### Kesimpulan pola
1. **Cek ekosistem file** sebelum menulis (TS/JS, ESM/CJS) — berlaku untuk semua backend poliglot.
2. **Ikuti alur end-to-end**, bukan hanya make it compile: fungsi tanpa caller = fitur tidak ada.
3. **Verifikasi ulang setiap edit berikutnya** — hasil check lama tidak berlaku surut untuk file yang berubah.
4. **Path absolut** untuk `cd` beruntun di script verifikasi.

---

## Hardware & Resource Optimization (2026-10-12)

### System Profile
- **OS**: Arch Linux
- **RAM**: 15 GB (13 GB used, 2.1 GB available)
- **Swap**: 4 GB (fully utilized - WARNING)
- **GPU**: NVIDIA RTX 5050 Laptop (8 GB VRAM)
- **Display**: Hyprland (Wayland)
- **DE**: VS Code + Chromium-based editors

### Critical Issues Found

#### 1. Swappiness Mismatch
- **Konfigurasi file** (`/etc/sysctl.d/99-ram-optimization.conf`): `vm.swappiness = 10`
- **Aktual system**: `vm.swappiness = 180` ❌
- **Dampak**: Sistem menggunakan swap secara agresif → OOM crash risk tinggi
- **Solusi**: Jalankan `sudo sysctl --system` atau reboot untuk apply konfigurasi

#### 2. zswap Disabled
- **Kernel cmdline**: `zswap.enabled=0`
- **Dampak**: Swap tidak dikompresi hardware → RAM pressure lebih tinggi
- **Solusi**: Edit GRUB_CMDLINE_LINUX di `/etc/default/grub` → reboot

#### 3. Swap Penuh (4 GB)
- **Swap used**: 4.0 GB / 4.0 GB (100%)
- **Dampak**: Tidak ada ruang swap tersisa → OOM saat spike
- **Solusi**: Tambah zram swap + optimalkan swappiness

### Konfigurasi yang Diterapkan

#### Memory Settings (`/etc/sysctl.d/99-ram-optimization.conf`)
```bash
# Optimized for 15GB+ RAM desktop system
vm.vfs_cache_pressure = 50     # Keep more file cache (default: 100)
vm.swappiness = 10              # Minimal swap usage (default: 60)
vm.dirty_ratio = 10             # Limit dirty page writeback
vm.dirty_background_ratio = 5
vm.zone_reclaim_mode = 0        # Disable NUMA zone reclaim
```

#### zram Configuration (`/etc/systemd/zram-generator.conf`)
```bash
[zram0]
zram-size = ram / 2            # 7.5 GB compressed swap
compression-algorithm = zstd   # Best compression ratio
```

#### VS Code Memory Optimization
```json
{
    "terminal.integrated.gpuAcceleration": "off",
    "files.watcherExclude": {
        "**/node_modules/**": true,
        "**/dist/**": true,
        "**/build/**": true,
        "**/.next/**": true
    },
    "search.maxResults": 10000,
    "terminal.integrated.scrollback": 1000,
    "editor.enablePreview": false
}
```

#### Node.js Memory Limits (package.json)
```json
{
    "scripts": {
        "dev": "NODE_OPTIONS='--max-old-space-size=3072' next dev",
        "build": "NODE_OPTIONS='--max-old-space-size=4096' next build"
    }
}
```

### Monitoring Scripts

#### `/home/nazky/bin/check-resources.sh`
```bash
#!/bin/bash
# Monitor RAM, zram, VRAM usage
./bin/check-resources.sh
```

#### `/home/nazky/bin/optimize-memory.sh`
```bash
#!/bin/bash
# Apply memory optimizations
sudo ./bin/optimize-memory.sh
```

### OOM Prevention Checklist

1. ✅ Set `vm.swappiness = 10` di `/etc/sysctl.d/99-ram-optimization.conf`
2. ✅ Configure zram dengan zstd compression
3. ✅ Add Node.js memory limits (`--max-old-space-size`)
4. ✅ Disable VS Code GPU acceleration
5. ⚠️ Enable zswap di kernel cmdline (butuh reboot)
6. ⚠️ Extend swap atau tambah RAM jika masih OOM

### VRAM Management (RTX 5050)

#### VS Code / Electron Flags (`~/.config/code-flags.conf`)
```
--enable-features=UseOzonePlatform
--ozone-platform=wayland
```

#### nvidia-smi Monitoring
```bash
nvidia-smi --query-gpu=memory.used,memory.total,utilization.gpu --format=csv
```

#### Recommended Flags untuk Electron
```bash
# Disable hardware video decode untuk hemat VRAM
--disable-gpu-video-decode

# Limit GPU memory
--enable-gpu-rasterization
--ignore-gpu-blocklist
```

### Troubleshooting

#### Jika OOM Terjadi:
1. Check `dmesg | grep -i oom` untuk proses penyebab
2. Jalankan `free -h` untuk status RAM
3. Check `check-resources.sh` untuk detail
4. Kill proses yang tidak perlu
5. Restart dengan `optimize-memory.sh`

#### Jika VRAM Leak:
1. Check `nvidia-smi` untuk proses GPU
2. Restart VS Code / Electron apps
3. Disable GPU acceleration di settings

---

Last Updated: 2026-10-12
