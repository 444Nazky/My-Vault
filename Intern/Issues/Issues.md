# Issues & Current Status — September 2026

## Open Issues

### Pending Verification

1. **Sync Status UI E2E Test** — Belum diuji di emulator/device:
   - Pastikan badge "Terkirim" muncul setelah trip berhasil sync
   - Pastikan badge "Lokal" muncul saat offline
   - Pastikan ConnectionIndicator akurat saat switch network

2. **Admin Dashboard Deployment** — Build production perlu copy manual ke admin-ci setelah setiap perubahan.

## Recently Solved

### 2026-09-30

- ✅ Sync Status Notification di Mobile History
  - HistoryScreen: SyncBadge + ConnectionIndicator + summary stats
  - HistoryDetailScreen: enhanced sync status card + connection info
  - New icons: Wifi, WifiOff, Cloud, CloudOff dari lucide-react

- ✅ Admin Dashboard Blank Fix
  - PHP server harus dijalankan dengan router: `php -S localhost:8000 admin-ci/index.php`
  - Bukan `-t admin-ci` yang tidak menggunakan preprocessing PHP

### 2026-09-29

- ✅ ReportSheet Kolom Foto & Lokasi
- ✅ Region Select Screen untuk Multi-Access Officers
- ✅ Seed Trips removed dari data.ts

---

## Progress Summary

| Date | Feature | Status |
|-------|---------|--------|
| 28 Sep | Master Rute, Login Region, PIN Keypad | ✅ |
| 29 Sep | Region Select Screen, ReportSheet enhancements | ✅ |
| 30 Sep | Sync Status Notification, Admin Blank Fix | ✅ |

---

## Quick Reference

### Start Services
```bash
# Mobile dev
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic && npm start

# Admin production (dengan router!)
php -S localhost:8000 admin-ci/index.php

# Backend API
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/backend && npm start
```

### Rebuild Admin
```bash
npm run build
cp -r www/* admin-ci/
```
