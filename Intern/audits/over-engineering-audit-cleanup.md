---
title: Repo-Wide Over-Engineering Audit & Cleanup
date: 2026-10-12
tags: [audit, over-engineering, dead-code, dependencies, backend, cleanup, react, ionic, ponytail]
status: completed
---

# Repo-Wide Over-Engineering Audit & Cleanup

## Overview

Audit seluruh repo Aplikasi-Trip (4 checkout branch) dengan standar **ponytail / over-engineering review**: cari apa yang bisa dihapus, bukan apa yang bisa ditambah. Seluruh temuan yang terbukti benar dieksekusi langsung (file mati, export mati, route backend mati, dependency tidak terpakai, asset duplikat), sementara temuan yang terbukti salah setelah diverifikasi ulang dicatat dan **tidak** dieksekusi.

Prinsip kerja: **behavior tidak boleh berubah**. Setiap penghapusan digate dengan `tsc --noEmit`, `ng build --configuration development`, `ng lint`, dan test runner — tidak ada perubahan yang lolos jika salah satu gagal.

## Scope

| Checkout | Repo / Branch | Peran |
|---|---|---|
| `Aplikasi-Trip-Main Branch/` | Aplikasi-Trip-Ionic · `main` | Source utama mobile + backend |
| `mobile-trip Mobile Branch/` | Aplikasi-Trip-Ionic · `mobile` | Payload OTA (served via raw GitHub) |
| `endpoint-trip Endpoint Branch/` | Aplikasi-Trip-Ionic · `endpoint` | Backend Railway + Firebase `functions/` |
| `Trip-Dashboard Admin Branch/` | Trip-Dashboard · `main` | Admin web (Netlify `admin-ci`, Firebase `www`) |

Keduanya adalah React + Vite app yang dibangun oleh Angular CLI (`ng build`, entry `src/main.tsx`).

## Method

Tooling yang dipakai (dibuat di `/tmp/opencode/`):

- `depcheck.mjs` — daftar dependency vs import nyata
- `unusedexports.mjs` — cek export yang nol referensi luar, **termasuk file test** (penting: pass pertama tanpa test menghasilkan false positive)
- `clscheck.cjs` — cek class/utility yang didefinisikan vs pemakaian (dipakai untuk memotong `global.scss`)
- `rmsymbol.mjs` — hapus blok deklarasi per symbol dengan brace/paren scanning

Gate verifikasi per tree:

```
npx tsc --noEmit -p tsconfig.app.json
npx ng build --configuration development
npm run lint            # ng lint
npm test / test:unit    # vitest (A: 12 test, mobile: 41 test)
node --check backend/src/**/*.js
```

> Catatan: `ng build` mode **production** gagal hanya di tahap *font inlining* (`fonts.googleapis.com` tidak terjangkau dari jaringan lokal). Ini pre-existing / environmental, bukan akibat perubahan.

---

## Findings & Removals

### 1. File mati & artifact build

| Tree | Dihapus |
|---|---|
| Semua | `config.xml`, `ionic.config.json`, `ionic.starter.json`, `vite.config.ts`, `tsconfig.spec.json`, `start-all.sh`, `restart-all.sh`, `scripts/clear-trip-history.js` |
| Semua | `archive/` (±1381 file di A & mobile), `graphify-out/` (per-tree copy) |
| A | `ota-downloader.ts` (769 bl), `version-checker.ts` (713 bl), `scripts/publish-ota-version.js`, 125 artifact build di root (`chunk-*.js`, `main-*.js`, `index.html`, `sw.js`, `version.json`, …), stray `UpdateNotifier.tsx.tmp.*` |
| mobile | `settings-preview/`, `Trip-Aplikasi-release-20261009.apk` (16 MB) |
| Trip-Dashboard | `src/services/officers.ts`, `src/pages/admin/components/Toast.tsx`, `src/pages/admin/tabs/index.ts` (barrel), `yes/index.html`, `clear-trip-history.sh`, `resources/` (icon/splash Cordova), `public/` |

`.gitignore` diperbarui di A, mobile, Trip-Dashboard supaya artifact build & output direktori tidak masuk repo lagi.

### 2. Route backend mati (−972 baris, 4 tree)

Verifikasi: nol referensi di seluruh frontend, backend, HTML, dan CI.

- `GET /reports/recap`
- `GET /reports/trips/export`
- `GET /auth/officers/:regionCode`
- `GET /auth/verify`
- `POST /trips/:tripId/vehicles`
- `GET /trips/:id`
- `POST /trips` — **hanya di Trip-Dashboard**; di `endpoint-trip` route ini LIVE (`public/index.html:221` memanggilnya)
- File utuh `backend/src/routes/vehicles.js` + `backend/src/routes/upload.js` (0 pemanggil global) beserta baris `require` / `app.use` di `backend/src/index.js`

### 3. Export frontend mati

**Trip-Dashboard (~30 symbol + anggota class):**

- `services/trips.ts` → `fetchTripDetail`
- `services/api.ts` → `postMultipart`, `uploadPhoto`, `setApiBaseUrl`, `refreshBaseUrl`, `isAuthenticated`, `LoginResponse`, `OfficerInfo`, `Dermaga`, `Route`
- `services/dermagas.ts` → `createDermaga`, `updateDermaga`, `deleteDermaga`, `assignOfficerDermagas`, re-export `Region`/`Dermaga`/`Route`
- `services/geofences.ts` → `deleteGeofencePointsForRoute`, `GeofenceConfig`
- `services/plates.ts` → `checkPlate`, `PlateCheck`
- `services/sync.ts` → `initializeSync`
- `services/auth.ts` → `AdminSessionResult` (dipertimbangkan ulang — ternyata dipakai, **dikembalikan**)
- `App.tsx` → `isAdminBuild`, `clearSession`
- `pages/types.ts` → `AppMode`, `UserType`, `MobileScreen`
- `pages/admin/components/types.ts` → `Toast`

**A (~30) & mobile (~38):**

- `plates.ts` → `createPlate`, `updatePlate`, `deletePlate`, `fetchPlates`, `PlateRecord`
- `location.ts` (A) → `coordinatesMatch`, `distanceToTarget`, `getConfiguredGeofenceLocations`, `updateGeofenceConfig`
- `geofence.ts` (mobile) → `addGeofencePoint`, `updateGeofencePoint`, `deleteGeofencePoint`, `toggleGeofencePoint`, `resetGeofenceToDefaults`, `getDistanceToNearestPoint`, `GeofenceState`
- `auth.ts` → `regionLogin`, `isLoggedIn`, `clearDermagaOfficersFromDb`, `getDermagaOfficersFromStorage`, `RegionInfo`, `RegionOfficer`
- `ota.ts` → `auditOta`, `clearPersistFlag`, `hasPersistFlag`, `clearCache`, `ensurePersistedBundleActive`
- `sync.ts` → `getLastSyncError`, `isSyncInProgress`, `getMaskedApiUrl`, `OTA_MANIFEST_URL`
- `adminPull.ts` → `AdminOfficer`; `offlineDb.ts` → `getBackend`
- `components/UpdateNotifier.tsx` → `useUpdateNotifier`
- `pages/types.ts` → `AppMode`, `UserType`, `AdminTab`
- `pages/store.tsx` → anggota context mati: `commitTrip`, `saveTariffs`, `markTripSynced`, `activeDermagaId`

### 4. CSS & config mati

- `global.scss` dipotong **896 → 40 baris** di 3 tree: 29 class komponen mati + utility copy yang sudah disediakan Tailwind (diverifikasi via `clscheck.cjs`, 41 class didefinisikan / 29 mati / 12 live semuanya milik Tailwind).
- `Trip-Dashboard/src/index.css` **246 → 174 baris** (mobile-transition CSS tak terpakai).
- `angular.json` di 3 tree: target `test`, `schematicCollections`, dan entry asset `Assets/` dihapus.
- **A & mobile**: cabang custom-API-URL (`API_BASE_URL_KEY`) dihapus karena tidak ada lagi writer setelah `setApiBaseUrl` dihapus.
- **mobile**: `isMobileDevice()` + `deviceApiBaseUrl` dihapus — kedua file environment menunjuk URL Railway yang sama, jadi branching-nya dead config. Base URL di-hardcode ke `environment.apiBaseUrl`.
- `src/environments/*` di **A TIDAK disentuh** (dev = localhost, prod = Railway → `fileReplacements` benar-benar beda).

### 5. Asset mati

**A & mobile** — dihapus (semua 0 referensi di `src/`):

- `src/assets/shapes.svg`, `src/assets/karyamas_clean.svg`, `src/assets/karyamasv.svg`
- root `Assets/karyamasv.svg` + entry asset terkait di `angular.json`
- `public/` (`logo.svg`, `version.json`, duplikat `karyamas_clean.*`)

Dipertahankan (LIVE): `guest-profile.jpeg` → `ProfileScreen.tsx`, `icon/favicon.png` → `src/index.html:32`, `karyamas_clean.png` → `LoginPage.tsx`.

**Trip-Dashboard** — dihapus:

- `src/assets/shapes.svg`, `src/assets/guest-profile.jpeg`, `src/assets/icon/favicon.png` (admin tree tidak punya `ProfileScreen`, `src/index.html` memakai SVG sebagai icon)
- root `Assets/*` kecuali `karyamasv.svg` (di-serve ke `/Assets/karyamasv.svg` oleh `AdminDashboard.tsx:160`), `resources/` (icon/splash Cordova), `public/`, `clear-trip-history.sh`

> ⚠️ **Regresi yang ketangkap waktu final rebuild**: `src/assets/karyamasv.svg` sempat ikut terhapus padahal direferensikan `src/index.html:37` (`<link rel="icon" href="assets/karyamasv.svg">`). Ketahuan karena `www/` hasil build tidak punya file-nya → **direstore** dan build ulang bersih. Pelajaran: grep referensi asset harus mencakup `src/index.html`, bukan hanya kode TS/TSX.

**Tidak disentuh**: root `assets/js|css` + `ota/` di mobile — itu payload OTA yang di-regenerate `npm run ota:publish`.

### 6. Dependency pruning

| Tree | deps | devDeps |
|---|---|---|
| A (main) | 33 → **17** (−16) | 18 → **15** (−3) |
| mobile | 24 → **19** (−5) | 19 → **17** (−2) |
| Trip-Dashboard | 14 → **7** (−7) | 16 → **12** (−4) |
| backend ×4 | 7 → **6** (−1) | — |
| functions | — | −1 (`firebase-functions-test`) |
| **Total** | **−28** | **−9** (+1 backend ×4, +1 functions) |

Yang dibuang: seluruh `@angular/*` yang tidak dipakai (kecuali `core` + `compiler` yang **wajib** agar `ng build` jalan — tanpa keduanya error `It appears that "@angular/core" is missing as a dependency`), `@ionic/*`, `ionicons`, `react-router(-dom)`, `tesseract.js`, `firebase`, `railway`, `@capacitor/{haptics,keyboard,preferences,status-bar}`, `jsdom`, `vitest` (Trip-Dashboard), `@angular/language-service`, `@ionic/angular-toolkit`.

Tidak disentuh: stack lint (`eslint`, `angular-eslint`, `typescript-eslint`, `eslint-config-google`) — `ng lint` lolos di semua tree, jadi ini safety net yang berfungsi.

Ditambahkan: `lucide-react` di A — di-import 18× tapi tidak pernah dideklarasikan (bug packaging).

Script `ota:publish:api` (A & mobile) dan `test` (mobile & Trip-Dashboard, script rusak/tidak ada target) dihapus. `tslib` dipertahankan (`tsconfig.importHelpers: true`).

### 7. `uuid` → `node:crypto`

42 site `require('uuid')` di 4 backend diganti `const { randomUUID } = require('crypto')` + `uuidv4()` → `randomUUID()` (format identik, UUID v4). Dependency `uuid` dihapus dari 4 `backend/package.json` + lock file. Format ID yang sudah ada di DB tidak berubah.

---

## Findings Rejected (terbukti salah)

Dicatat supaya tidak diaudit ulang:

| Temuan awal | Faktanya |
|---|---|
| `ReportSheet.tsx` dead | **LIVE** — `ReportsTab.tsx:179` dan `:184` set `window.location.hash = '#/sheet'` |
| `src/theme/variables.scss` dead | **LIVE** — dipakai `global.scss` (`var(--font-sans)` dll, `:root` di `variables.scss:7`) |
| `endpoint-trip backend/` bisa dihapus | **LIVE deploy** — `railway.json` → `backend/Dockerfile` |
| `endpoint-trip functions/` + `public/` | **LIVE** — tersambung ke `.github/workflows/firebase-hosting-merge.yml` + `firebase.json` rewrites |
| `src/services/xlsx.ts` harus diganti CSV | Export `.xlsx` berfungsi & dipakai ReportsTab/ReportSheet; CSV = perubahan behavior, npm `xlsx` = dependency baru |
| `src/environments/*` (A) bisa dilebur | Dev/prod URL beda, `fileReplacements` fungsional |
| Stack lint (`eslint`, `angular-eslint`, `typescript-eslint`) | `ng lint` lolos di semua tree — safety net yang berfungsi |
| `data/backups/*.db` (Trip-Dashboard) | Data asli — tidak disentuh |

## Deliberately Skipped

- **`dbWrapper` dual DB API** (`backend/src/db.js`) — inkonsistensi gaya (shim better-sqlite3 vs `db.run` mentah), refactor bukan penghapusan, risiko tinggi.
- **Domain type triplicated** di beberapa file — refactor, bukan dead code.
- **`adminPull.ts` vs `credentialSync.ts`** — **bukan duplikat**: key localStorage berbeda, konsumen berbeda (`sync`/`App.tsx` vs `LocalOfficersScreen`), dua-duanya dipakai.
- **`seedData.ts` dead seed tables** — setelah pemeriksaan ulang semua table live (`SEED_ROUTES`, `SEED_GEOFENCE_POINTS`, `seedRoster*` dipakai `offlineDb.ts`/`auth.ts`). "Dead" di pass pertama berasal dari bug tool (regex `declOcc`).
- **Root `assets/js|css` + `ota/` di mobile** — payload OTA yang di-regenerate `npm run ota:publish`. Menghapusnya bisa memutus client lama antar-publish.
- **A: `dbClear` / `localDbBackend`** — nol pemanggil di A, tapi dibutuhkan `localDb.test.ts` di mobile; dipertahankan untuk paritas antar branch.

## Verification

| Tree | tsc | build (dev) | lint | tests |
|---|---|---|---|---|
| A (main) | ✅ | ✅ | ✅ | 12/12 |
| mobile | ✅ | ✅ | ✅ | 41/41 |
| Trip-Dashboard | ✅ | ✅ | ✅ | — (tanpa test target) |
| endpoint | — | — | — | `functions` lint: 70 error **style pre-existing** (tidak berubah) |

Backend ke-4: semua file lolos `node --check`.

## Totals

**Source code** (tidak termasuk `graphify-out/`, `archive/`, `package-lock.json`, `android/`, `www/`, `node_modules/`):

| Tree | File | +Baris | −Baris |
|---|---|---|---|
| A (main) | 165 | +66 | −5045 |
| mobile | 77 | +128 | −3913 |
| Trip-Dashboard | 137 | +66 | −2557 |
| endpoint | 17 | +36 | −352 |
| **Total** | **396** | **+296** | **−11.867** |

**Artifact/generated** (termasuk): A −1.420.224, mobile −1.934.933, Trip-Dashboard −222.587 baris — didominasi `graphify-out/graph.json` (±660k baris/file) dan `archive/`.

**Dependency**: −28 deps, −9 devDeps, −4 backend deps, −1 functions devDep.

> Angka mengikuti window baseline `12:39` → working tree, sehingga ikut memuat commit yang dibuat manual di 13:13–13:24.

## Files Modified

- `package.json` di 4 tree + `backend/package.json` ×4 + `functions/package.json` + semua `package-lock.json` terkait
- `angular.json` ×3, `.gitignore` ×3
- `backend/src/index.js` + `backend/src/routes/{trips,auth,reports}.js` ×4; `routes/{vehicles,upload}.js` dihapus ×4
- `src/services/{api,auth,plates,ota,sync,geofence,location,adminPull,offlineDb,localDb,dermagas,trips}.ts`, `src/pages/{store,types}.tsx`, `src/App.tsx`
- Trip-Dashboard: `src/pages/admin/AdminDashboard.tsx` (import barrel `./tabs` → 7 import langsung), `src/pages/admin/components/types.ts`
- `src/global.scss` ×3, `Trip-Dashboard/src/index.css`
- `src/environments/environment{,.prod}.ts` (mobile saja)

## Related Documentation

- `[[Session 2025-10-11 Audit & Fixes]]` — audit sesi sebelumnya
- `AUDIT_OVERHAUL_REPORT.md` di project root
- `[[audits/ota-full-bundle-migration]]`, `[[audits/geofencing-route-validation]]`, `[[audits/trip-lifecycle-ui-refactor]]`
