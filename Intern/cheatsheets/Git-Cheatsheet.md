# Git Cheatsheet — Trip Angkutan

Tanggal: 8 Oktober 2026  
Branch aktif: `mobile` (mobile app) / `endpoint` (backend API) / `admin` (dashboard)

---

## Cek Branch Aktif di VS Code

### Indicator Branch

Branch aktif ada di **status bar kiri-bawah** (Source Control icon), atau buka Command Palette → `>Git: Checkout to...` untuk lihat branch.

### Terminal

```bash
git branch --show-current   # nama branch saja
git branch -v             # cabang + commit
```

---

## Push ke Branch Tujuan

### Perintah Utama

```bash
# Push branch saat ini (menyebar ke remote)
git push

# Push + set upstream
git push -u origin <branch-name>
```

### Push ke Branch Berbeda

```bash
# Push branch lokal ke branch remote BERBEDA
git push -u origin <lokal-branch>:<remote-branch>
```

---

## Struktur Repository

### Clone & Worktree

| Folder | Branch | Fungsi |
|---|---|---|
| `mobile-trip Mobile Branch` | `mobile` | Mobile app (Ionic/React + Capacitor) — OTA publish |
| `endpoint-trip Endpoint Branch` | `endpoint` | Backend API Node/Express (deploy ke Railway) |
| `Trip-Dashboard Admin Branch` | `admin` | Dashboard admin |

### Start Script

```bash
# Semua service (API + mobile + admin)
./start-all.sh

# Mobile only
cd Aplikasi-Trip-Ionic && npm start           # :5173
cd Aplikasi-Trip-Ionic/backend && npm start     # :3000

# Admin only
cd admin-dashboard && npm run build:admin     # Build + sync ke admin-ci/
cd admin-dashboard/admin-ci && php -S localhost:8000  # Serve dashboard
```

---

## Deploy

| Komponen | Branch | Mekanisme | Catatan |
|---|---|---|---|
| Mobile (APK + OTA) | `mobile` | Capacitor + OTA (`npm run ota:publish`) | Publish aset ke branch `mobile` |
| Admin Dashboard | `admin` | Vercel (vercel.json, SPA rewrite) — sebelumnya Netlify | Build: `npm run build:admin`, Publish: `admin-ci` |
| Backend API | `endpoint` | Railway | `POST /trips/complete` upsert by `clientTripId` (2026-10-08) |

---

## Sinkronisasi Branch

```bash
# Update ref tanpa checkout
git fetch origin main:main
git fetch origin admin:admin

# Sinkronisasi service antara branch
# 1. Backend dengan auth admin → push dari admin/main ke main
# 2. Database trip.db → backup dulu, salin dari folder berbeda branch
```

---

## Login

- **Mobile** (`:5173`) → Akun petugas saja
- **Admin Dashboard** (`:8000`) → `admin/admin123` atau kredensial yang sudah diubah lewat **Pengaturan → Ganti Password**

---

*Diperbarui: 8 Oktober 2026*
