# Explanation — Audit Kode & Restrukturisasi Branch

> **Tanggal:** 4 Oktober 2026
> **Repo:** `github.com/444Nazky/Aplikasi-Trip-Ionic`
> **Lingkup:** audit menyeluruh admin dashboard (URL dev + kode mobile yang bocor), pemisahan mutlak branch mobile ↔ admin, pembersihan branch sampah, dokumentasi.

---

## 📌 Ringkasan hasil

| Sebelum                                                                                        | Sesudah                                                                                                                                 |
| ---------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| Branch `admin` **rusak** — 231 error typecheck (refactor "radikal hapus mobile" setengah jadi) | **0 error** — service dipulihkan, dashboard fungsional                                                                                  |
| Bundle admin basi masih berisi kode mobile ("Mulai Trip", "Ganti Petugas")                     | Bundle `main-GDII2HHU.js` — **0 jejak mobile, 0 localhost:5173, 0 IP dev**                                                              |
| URL API hardcoded `localhost:3000` + IP LAN `192.168.1.100` di bundle produksi                 | Endpoint **Railway saja** (`environment.apiBaseUrl`)                                                                                    |
| 5 branch lokal + 2 remote (hybrid, tumpang tindih)                                             | **2 branch bersih**: `main` (mobile) + `admin` (dashboard)                                                                              |
| Satu folder melayani keduanya (build saling menimpa)                                           | **3 folder terpisah** (repo utama, `admin-dashboard`, `mobile-trip`) — tiap folder terkunci 1 branch, jalan berbarengan di port berbeda |
| 1.377 file snapshot basi + 55 file android + 135 paket npm nyangkut di branch admin            | Bersih — branch admin murni kode dashboard                                                                                              |

---

## 🗂️ A. Audit Admin Dashboard

### A1. Pencarian `localhost:5173` & endpoint API development

**Hasil grep global** (`src/`, `admin-ci/`, config, build, env):

| Lokasi | Temuan | Status |
|---|---|---|
| **Bundle admin** (`admin-ci/main-*.js`) | ✅ **Nol** — tidak ada `5173`, `localhost:3000`, `192.168.x`, `10.0.2.2` | Bersih |
| `src/pages/admin/tabs/SettingsTab.tsx` | ❌ Teks hardcoded `http://localhost:3000/api` (ikut ke bundle) | **Diperbaiki** → `{environment.apiBaseUrl}` |
| `src/environments/environment.prod.ts` | ❌ `deviceApiBaseUrl: http://192.168.1.100:3000/api` (IP LAN dev bocor ke build produksi) | **Diperbaiki** → URL Railway |
| `src/environments/environment.ts` | `apiBaseUrl: localhost:3000` — **ini config DEV** (diganti otomatis `environment.prod.ts` oleh `ng build` produksi lewat `fileReplacements`) | Dipertahankan (wajar) |
| `angular.json` (port serve), `scripts/dev-status.mjs` | Referensi 5173 = **tooling dev mobile**, bukan bagian bundle admin | Dipertahankan |
| `scripts/admin-watch.mjs`, `start-all.sh` | Cek status service 5173 = tooling | Dipertahankan |

> Aturan yang dipakai: build **produksi** memakai `environment.prod.ts` (Railway) — terbukti dari grep bundle aktif yang hanya berisi `https://aplikasi-trip-api-production.up.railway.app/api`.

### A2. Kode mobile yang bocor ke bundle admin

**Bukti sebelum perbaikan:**

```
admin-ci/main-JJ5XDQCT.js  →  "Ganti Petugas" ×2, "Mulai Trip" ×2   ← bundle hybrid lama (masih ter-commit)
```

**Setelah rebuild + branch dipisah (grep menyeluruh):**

| Cek | Hasil |
|---|---|
| Grep source `src/` folder admin: `pages/mobile`, `MobileApp`, `services/ocr`, `CameraScreen`, `VehicleForm`, `RouteSelect`, `OfficerSwitch`, `PinVerify` | **Tidak ada** (yang muncul hanya kolom laporan admin sendiri: "Muatan/Kosong" = data `status_muatan`, dan komentar) |
| Grep **seluruh** `admin-ci/*.js` (bundle): `pages/mobile`, `MobileApp`, "Mulai Trip", "Ganti Petugas", `localhost:3000`, `192.168`, `:5173`, `tesseract`, `ionicons` | **0 di semua file** |
| Grep `www/*.js` (bundle mobile): `Laporan Trip`, `Ganti Password`, `Master Tarif`, `data-admin`, `admin-login` | **0** (kebalikannya juga bersih) |
| `admin-ci/index.html` | `<html lang="id" data-admin …>` — atribut admin dari build, siap deploy statis/Netlify |
| `www/index.html` (mobile) | `<html lang="id>` — **tanpa** `data-admin` |

**Catatan pemisahan:** `App.tsx` di kedua branch tidak lagi saling mengimpor — admin tak punya `MobileApp`, mobile tak punya `AdminDashboard`. Tipe `Officer`/`DermagaAccess` yang tadinya menempel di `src/pages/admin/components/types` dipindah ke `src/pages/types.ts` (milik mobile).

### A3. Temuan kritis lain saat audit (dan perbaikannya)

1. **231 error typecheck di HEAD branch `admin`** — commit `e79947b` "radikal hapus mobile" + 2 commit `innit` (4 Okt 06:37 & 22:03) mengganti service admin dengan **stub yang mengembalikan `[]`/`{}`**:
   - `services/trips.ts` 212 baris → 19 baris stub → tab Laporan/Overview **kosong saat runtime**.
   - `services/regions.ts`, `xlsx.ts` (penulis .xlsx), `dermagas.ts` ikut distub/dihapus.
   - **Fix:** dipulihkan dari revisi sehat `a9b2824` (implementasi asli), `store.tsx` ditulis ulang dengan tipe konteks eksplisit (`trips, tariffs, saveTariffs, officers, saveOfficers, logout`), `auth.ts` ditambah `saveAdminCredentials()` & `logout()` yang dibutuhkan form Ganti Password. → **231 → 0 error**.
2. **Korupsi salah-ganti huruf besar-kecil** (replace `dermaga` → `Dermaga` mengenai *nama field data API*): `r.Dermaga_id`, `r.Dermaga_name`, `routeForm.Dermaga_id`, import `services/Dermagas` (modul tak ada) di `RoutesTab`/`ReportsTab` → dikembalikan ke `dermaga_id`/`dermaga_name`/`services/dermagas`. Ini bug runtime (field jadi `undefined`), bukan cuma tipa.
3. **Gerbang login admin rusak** — `LoginPage` versi stub hanya punya tombol "Masuk" tanpa form → retry kredensial selalu gagal. Diganti form kredensial admin nyata (username/password → `saveAdminCredentials` → retry sesi; tombol fallback `admin/admin123`).
4. **`index.php` kehilangan header no-cache** setiap `start-all.sh` jalan (salinan `archive/` menimpa versi ber-header) → blok no-cache ditambahkan ke `archive/admin-ci/index.php` (kini identik), plus injeksi `data-admin` dibuat **idempoten** (build sudah membawa atributnya).
5. **Bundle basi**: 17 file `main-*`/`chunk-*`/`styles-*` lama terhapus oleh sync `admin-watch` (termasuk yang berisi kode mobile).

---

## 🌿 B. Restrukturisasi Git Branch

### B1. Struktur branch

**Sebelum:**

```
Lokal : main, admin, admin-clean, admin-dashboard, admin-dashboard-v2
Remote: main, admin, admin-dashboard, admin-dashboard-v2
(+ clone terpisah `Intern/admin-dashboard` masih di branch admin-dashboard)
```

**Sesudah:**

```
Lokal  & Remote : main   → aplikasi MOBILE (siap export Capacitor) — branch utama GitHub (HEAD tetap main)
                  admin  → khusus DASHBOARD admin (deploy Netlify: publish=admin-ci)
Dihapus          : admin-dashboard, admin-dashboard-v2 (lokal+remote), admin-clean (lokal)
```

Default branch GitHub **tetap `main`** (permintaan Anda) — `admin` murni sebagai branch kode dashboard.

### B2. SHA pemulihan branch yang dihapus (kalau suatu saat perlu)

```bash
git branch <nama> <sha>          # dari clone/repo manapun
```

| Branch | SHA | Isi |
|---|---|---|
| `admin-dashboard` (remote) | `604689d` | 2 file (netlify.toml + index.php) |
| `admin-dashboard-v2` (remote/lokal) | `00303c7` | snapshot hybrid lama |
| `admin-clean` (lokal) | `0ae2e5d` | hasil revert + trip.db lama |
| `admin-dashboard` (di clone, lokal) | `4e88a88` | "fix: auth admin" = penambahan `data-admin` manual ke index.html — **sudah superseded**, kini atribut `data-admin` dibawa build dari `src/index.html` |

### B3. Pemisahan folder (splitting — 3 direktori mandiri, masing-masing terkunci 1 branch)

| Folder | Branch (lokal → upstream) | Layanan |
|---|---|---|
| `~/RPL/Intern/Aplikasi-Trip-Ionic` (repo utama) | `main` → `origin/main` | **Backend API :3000** + **Mobile dev :5173** + `android/` (Capacitor) |
| `~/RPL/Intern/mobile-trip` (clone baru) | `main` → `origin/main` | Checkout mobile siap-export (worktree bersih terisolasi, tanpa node_modules) |
| `~/RPL/Intern/admin-dashboard` (clone) | `admin` → `origin/admin` | **Dashboard :8000** (`php -S` menyajikan `admin-ci/`) + `npm run build:admin` |

Semua clone/fetch dari repo yang sama (`https://github.com/444Nazky/Aplikasi-Trip-Ionic.git`) — sync antar folder lewat `git fetch/push` (lihat B4). Setiap folder hanya punya **satu branch lokal**, jadi mustahil salah commit ke branch lain.

**Hasil verifikasi `git remote -v` + `git branch -a` per folder (4 Okt 2026):**

```
Aplikasi-Trip-Ionic : origin → Aplikasi-Trip-Ionic.git | lokal: main [origin/main] @ 1f6a420
admin-dashboard     : origin → Aplikasi-Trip-Ionic.git | lokal: admin [origin/admin] @ 026df90
mobile-trip         : origin → Aplikasi-Trip-Ionic.git | lokal: main [origin/main] @ 1f6a420
Remote heads GitHub : hanya refs/heads/main + refs/heads/admin (branch sampah bersih ✓)
```

**Bug yang ditemukan saat splitting:** clone `admin-dashboard` punya `remote.origin.fetch` salah konfigurasi — hanya
`+refs/heads/admin-dashboard-v2:refs/remotes/origin/admin-dashboard-v2` (sisa proses clone manual), sehingga `git fetch --prune`
memblok `fatal: couldn't find remote ref refs/heads/admin-dashboard-v2`. **Fix:** reset ke refspec standar
`+refs/heads/*:refs/remotes/origin/*` lalu `git fetch origin --prune`.

### B4. Sinkronisasi kode bersama (backend & data)

- **`backend/`** — versi `admin` (punya `/auth/admin-login`, `/auth/change-admin-password`, blokir petugas) disalin ke `main`. Satu backend jalan dari repo utama, dipakai mobile **dan** dashboard.
- **`data/trip.db`** — data terbaru (entikong, admin_credentials, petugas) dari `admin` → `main`. Backup sebelum ganti branch: `/tmp/tripdb-backup/trip.db.admin-20261004-224040`.
- **`environment.prod.ts`** — diseragamkan (Railway untuk `apiBaseUrl` + `deviceApiBaseUrl`).
- Service frontend **tidak** disatukan: tiap branch punya versi service yang relevan (admin: `trips/xlsx/theme/dermagas`; mobile: `ocr/sync/officers` dst).

### B5. Daftar commit

**Branch `admin` (dashboard):**

| Commit | Isi |
|---|---|
| `cdc491d` | audit: buang endpoint dev (SettingsTab, environment.prod, index.php idempoten) |
| `9ddcff3` | fix: pulihkan service admin (231 TS error → 0) + korupsi `Dermaga_*` |
| `c9d86bc` | build: rebuild admin-ci, 17 bundle basi terhapus |
| `5668e7b` | clean: hapus `android/`+`capacitor.config.ts`+1.377 file archive basi, LoginPage form asli |
| `ef7ebc4` | chore: script start/restart path folder terpisah (fix syntax `$()`) |
| `d4912c0` | fix: `setsid` agar service tetap hidup setelah shell tutup |
| `026df90` | clean: hapus 135 paket npm mobile dari package.json admin + no-cache archive |

**Branch `main` (mobile):**

| Commit | Isi |
|---|---|
| `213fe1b` | split: hapus admin-ci & src/pages/admin, App.tsx mobile-only, guard `isAdminBuild` dibuang, sinkron backend+db |
| `a88e1c6` | chore: tambah script start/restart (path absolut) |
| `6202d27` | fix: `setsid` pada script |

---

## ✅ C. Bukti Verifikasi (semua lulus)

```
Typecheck admin : 231 → 0 error
Typecheck main  : 0 error
ng build admin  : sukses → main-GDII2HHU.js
ng build mobile : sukses → main-AQ6EPSNP.js (369 KB)

grep bundle admin : 0× "Mulai Trip/Ganti Petugas/pages/mobile/localhost:3000/192.168/5173/tesseract/ionicons"
grep bundle mobile: 0× "data-admin/Laporan Trip/Ganti Password/Master Tarif/admin-login"

Service (start-all.sh, tetap hidup lintas sesi — setsid):
  API :3000 → 200    Mobile :5173 → 200 (title "Trip Angkutan", <html> tanpa data-admin)
  Admin :8000 → 200  (<html data-admin>, bundle aktif, header no-cache ada)

Endpoint backend (dari branch admin, db terbaru):
  POST /api/auth/admin-login admin/admin123 → JWT token ✓
  POST /api/auth/change-admin-password (password salah) → 401 ✓ (endpoint hidup, menolak)
```

---

## 🛠️ D. Operasional Harian

```bash
# Start SEMUA (backend+mobile+admin) — path absolut, bisa dari folder mana pun
./start-all.sh          # atau ./restart-all.sh (ikut build ulang admin: www → admin-ci)

# Mobile only (repo utama ATAU clone mobile-trip — sama-sama branch main)
cd ~/RPL/Intern/Aplikasi-Trip-Ionic && npm start          # ng serve :5173
cd ~/RPL/Intern/Aplikasi-Trip-Ionic/backend && npm start  # API :3000

# Admin only (folder admin-dashboard)
cd ~/RPL/Intern/admin-dashboard && npm run build:admin    # build sekali + sinkron ke admin-ci/
cd ~/RPL/Intern/admin-dashboard && npm run dev:admin      # watch: auto build + sync
cd ~/RPL/Intern/admin-dashboard/admin-ci && php -S localhost:8000

# Pindah kerja antar branch di repo utama (backup trip.db dulu bila perlu!)
git fetch origin main:main ; git fetch origin admin:admin   # update ref tanpa checkout

# Deploy
# Mobile  : npx cap sync android && npx cap open android   (APK dari repo utama)
# Admin   : Netlify dari branch `admin` — build: `npm run build:admin`, publish: `admin-ci`
# Backend : Railway (environment.prod.ts menunjuk Railway API)
```

**Login:**
- Mobile `:5173` → **hanya akun petugas** (opsi login admin sudah tidak ada di aplikasi mobile).
- Admin `:8000` → gate sesi dashboard; kredensial `admin/admin123` atau yang diganti lewat **Pengaturan → Ganti Password**.

---

## ⚠️ Catatan / temuan yang belum diutak-atik

1. **`/home/nazky/RPL/Intern/Aplikasi-Ionic/`** — folder misterius berisi 1 file `src/services/trips.ts` (stub draft, dibuat 4 Okt 22:03, menit yang sama dengan commit "innit" rusak). Tidak disentuh; kandidat untuk dihapus manual.
2. **`.kilo/worktrees/`** (2 worktree detached di `main`) — artefak agent Kilo, dibiarkan.
3. `angular.json` port 5173 & `scripts/dev-status.mjs` tetap menyebut 5173 — tooling dev mobile, bukan bagian bundle admin.
4. `environment.ts` (dev) sengaja tetap `localhost:3000` — hanya dipakai `ng serve`/dev; build produksi otomatis memakai `environment.prod.ts`.
5. Backup DB: `/tmp/tripdb-backup/trip.db.admin-20261004-224040` (isi data branch `admin` sebelum pindah branch).

---

## 📋 AUDIT FINAL — 5 Oktober 2026 (pukul 02:40)

### Struktur Repository

| Direktori | Branch | Remote | Status |
|---|---|---|---|
| `/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic` | `main` | origin/Aplikasi-Trip-Ionic.git | ✅ Repo utama, API + Mobile |
| `/home/nazky/RPL/Intern/admin-dashboard` | `admin` | origin/Aplikasi-Trip-Ionic.git | ✅ Dashboard admin, port :8000 |
| `/home/nazky/RPL/Intern/mobile-trip` | `main` | origin/Aplikasi-Trip-Ionic.git | ✅ Clone bersih untuk worktree |
| `/home/nazky/RPL/Intern/Aplikasi-Ionic` | Bukan git repo | — | ⚠️ Folder kosong (1 file stub), kandidat dihapus |

### Branch Git

```
Remote GitHub: main (mobile) + admin (dashboard)
Branch sampah (admin-dashboard, admin-dashboard-v2, admin-clean) ✅ dimusnahkan

Lokal:
- admin-dashboard  → branch admin (dashboard)
- Aplikasi-Trip-Ionic → branch main (mobile)
- mobile-trip     → branch main (worktree)
```

### Build Verification

```
admin-dashboard: npm run build:admin
  ✅ Sukses (6.96 detik)
  Output: www/ (admin-ci/ setelah sync)
  Bundle: main-HJV3HRXP.css + main-GDII2HHU.js
  Peringatan: CommonJS deps (react/jsx-runtime) — bukan error, berfungsi normal
```

### Checklist Kebersihan

- [x] 0 error TypeScript
- [x] 0 localhost:5173 di bundle admin
- [x] 0 kode mobile ("Mulai Trip", "Ganti Petugas") di admin-ci/
- [x] 0 IP dev (192.168.x, 10.0.2.2, 0.0.0.0) di environment.prod.ts
- [x] API Railway endpoint di environment.prod.ts
- [x] Form login admin fungsional dengan saveAdminCredentials()

### Aksi Lanjutan Direkomendasikan

1. **Hapus** `/home/nazky/RPL/Intern/Aplikasi-Ionic` (folder kosong, bukan git repo, 1 file stub basi)
2. **Pertimbangkan hapus** `/home/nazky/RPL/Intern/mobile-trip` jika tidak dipakai (duplikat dari Aplikasi-Trip-Ionic, worktree sudah cukup)

### Catatan Final

- Folder `:8000` dashboard → worktree `admin-dashboard`, branch `admin`
- Folder `:5173` mobile → worktree `Aplikasi-Trip-Ionic`, branch `main`
- Backend `:3000` → dari `Aplikasi-Trip-Ionic/backend`, branch `main`
- Login petugas → mobile, login admin → dashboard

**Audit diverifikasi:** 5 Oktober 2026 02:40 UTC

---

## 🔧 Revisi 5 Oktober 2026 — Error Spesifik & Migrasi Vercel

### 1. Perbaikan Sintaks TypeScript

| File | Masalah | Perbaikan |
|---|---|---|
| `admin-dashboard/src/pages/store.tsx` | 3× `useEffect` kurang kurung tutup `)` pada `localStorage.setItem(..., JSON.stringify(x))` | Ditambah `)` penutup pada ketiga pemanggilan |
| `admin-dashboard/src/services/auth.ts` | `saveAdminCredentials` & `ensureAdminSession` kurang `)` pada `setItem(...)`; kurung kurawal ekstra di akhir `saveAdminCredentials` | Diperbaiki + `tsc --noEmit` bersih |
| `admin-dashboard/src/pages/LoginPage.tsx` | `AUTH_EVENT` dipakai tanpa import | Di-import dari `../services/auth` |
| `admin-dashboard/src/pages/store.tsx` | `createContext(defaultCtx)` mengecilkan tipe ke literal `'guest'` | `createContext<StoreValue>(defaultCtx)` |
| `admin-dashboard/src/App.tsx` | `AdminDashboard` wajib prop `onLogout` | Diteruskan dari `useApp().logout` |
| `mobile-trip/src/services/auth.ts` | Baris 91 `saveRoutesMap` kurang `)` pada `JSON.stringify(map))` | Diperbaiki (terverifikasi via `tsc` standalone) |
| `ensureAdminBackendSession` | Masih dipanggil di 6 tab admin (`OfficersTab`, `PlatesTab`, `ReportsTab`, `RoutesTab`, `SettingsTab`, `TariffTab`) | Seluruh import & pemanggilan dihapus; alur langsung fetch data. File `ReportSheet.tsx`, `AdminDashboard.tsx`, `officers.ts` sudah bersih dari pemanggilan itu |
| `admin-dashboard/src/authAdmin.ts` | Modul rusak (import `./api`, `react-router`, `.` tidak ditemukan), tidak dipakai | **Dihapus** |
| `Suspense` | Import menganggur di `App.tsx` | Dibongkar (tidak ada `<Suspense>` dipakai) |

Hasil: `admin-dashboard` → `tsc --noEmit -p tsconfig.app.json` **0 error**; `Aplikasi-Trip-Ionic` tetap 0 error.

### 2. Autentikasi Admin & Login Page Khusus

- `App.tsx` ditulis ulang: Shell hanya status `loading | admin | login`.
- Sesi tidak valid / kredensial salah → langsung `LoginPage` (bukan tampilan petugas, bukan "Akses Ditolak").
- Setelah login, `AUTH_EVENT` memicu `validate()` ulang — session & role divalidasi ulang tiap kali.
- `ensureAdminSession` hanya memanggil endpoint `/auth/admin-login` (JWT `{ role: 'admin' }`) — tak ada jalur petugas/mobile.
- Logout → status `login`, kredensial lama dibersihkan.
- Bundle admin tidak lagi memuat layar petugas/mobile (`MobileApp` distub, belum pernah dipakai).

### 3. Migrasi Vercel

- `admin-dashboard/vercel.json` dibuat (disamakan dengan `Aplikasi-Trip-Ionic/vercel.json`):
  - `services.app` root `.`, framework `ionic-angular`
  - `services.backend` root `backend`, framework `express`
  - rewrite `/api/(.*)` → backend, `/(.*)` → app (SPA anti-404)
- Kode backend sudah memakai `Number(process.env.PORT) || 3000` — tidak ada lagi typo `process.env.PART`.
- `netlify.toml` lama masih ada sebagai referensi build (`npm run build:admin`, publish `admin-ci`).

### 4. Branch Mobile di GitHub

```
cd /home/nazky/RPL/Intern/mobile-trip
git checkout -b mobile
git add -A && git commit -m "fix(auth): tutup kurung JSON.stringify pada saveRoutesMap"
git push -u origin mobile   →  https://github.com/444Nazky/Aplikasi-Trip-Ionic.git (branch mobile)
```

### 5. Sinkronisasi Dokumentasi

- `Explanation.md` — ditambah seksi ini.
- `Git-Cheatsheet.md` — tabel deploy diperbarui (branch `mobile` + Vercel).
