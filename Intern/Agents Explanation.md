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

Last Updated: 2026-09-30
