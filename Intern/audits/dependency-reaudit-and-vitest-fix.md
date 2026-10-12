---
title: "Re-audit Dependency Pasca-Cleanup & Perbaikan Vitest (@capacitor/http)"
date: 2026-10-12
tags: [audit, dependencies, vitest, capacitor, ota, cleanup, false-positive]
status: completed
related:
  - "[[audits/over-engineering-audit-cleanup]]"
  - "[[log book/2026-10-12]]"
---

# Re-audit Dependency Pasca-Cleanup & Perbaikan Vitest

## Konteks

Setelah komunikasi awal berisi klaim "removable deps (~40)" (React app shipping Angular runtime, Ionic stack, Capacitor plugin tak terpakai, tesseract.js, firebase+railway, jsdom+vitest, uuid ×2, dll.), sebagian besar sudah dieksekusi via [[audits/over-engineering-audit-cleanup]]. Permintaan selanjutnya: **audit ulang** untuk memastikan sisa klaim mana yang benar-benar masih bisa dihapus dan mana yang terbukti false positive.

## Metode

Seluruh klaim diverifikasi dengan bukti perintah nyata, bukan memory:

1. `cat` kelima `package.json` (3 app + 4 backend + `functions/`)
2. `grep -rE` per pola di semua `src/`, `angular.json`, `scripts/*.mjs`:
   - `@angular/(common|forms|platform-browser|router|http|upgrade)`
   - `from ['"]rxjs`, `tslib`, `@ionic/*`, `ionicons`, `react-router`
   - `@capacitor/(preferences|haptics|keyboard|status-bar)`
   - `uuid`, `firebase-functions-test`, `tesseract`
3. `capacitor.config.ts` (Main & mobile) — dipastikan tidak mendaftar plugin apa pun
4. `git ls-files` + `du` untuk menghitung artifak yang masih bisa dibuang
5. Eksekusi test suite untuk memvalidasi setup vitest

## Temuan: klaim yang TERBUKTI SUDAH BERES

Terifikasi 0 match di semua tree:

| Klaim awal | Bukti |
|---|---|
| Angular runtime `common/forms/platform-browser(-dynamic)/http/router` | 0 import; hanya `@angular/build`+`@angular/cli` sebagai tooling (wajib) |
| `@ionic/angular|react|react-router|storage-angular`, `ionicons` | 0 referensi di `src/` + config |
| `react-router`, `react-router-dom` | 0 import |
| Capacitor `preferences|haptics|keyboard|status-bar` | 0 referensi; tersisa hanya yang diimpor: core, app, camera, filesystem, geolocation, network, ios, android, `@capacitor-community/sqlite` |
| `uuid` ×2 backend | diganti `crypto.randomUUID()` — lihat `endpoint-trip/backend/src/db.js:4` |
| `@angular/language-service`, `@ionic/angular-toolkit` | sudah keluar dari devDependencies |
| `firebase` (runtime), `railway` (CLI dep) | sudah keluar |
| `firebase-functions-test` | sudah keluar dari `functions/` |

## Temuan: klaim yang TERBUKTI FALSE POSITIVE (jangan dihapus)

| Klaim awal | Faktanya |
|---|---|
| `vitest`, `jsdom`, `fake-indexeddb` "no tests" | Ada 6 file test aktif (`sync`, `ota`, `localDb`, `auth`, `store.merge` test) + `vitest.config.ts` dengan `environment: 'jsdom'` + `vitest.setup.ts`. Ini suite nyata (`npm run test:unit` — 41 test) |
| `tesseract.js` "no OCR" | Diimpor `mobile-trip/src/services/ocr.ts` (`createWorker`) — fitur OCR plat aktif |
| `rxjs` bisa dibuang | Peer sahabat `@angular/core`/builder; `ng build` gagal tanpanya |
| `tslib` ×2 | `importHelpers: true` + kebutuhan Angular builder |
| `@capacitor/assets` | Tooling generate icon/splash dari `resources/` |
| `graphify-out/` masih "referenced" | Sebaliknya: **0 referensi** di script/config/project → 65 MB aman dihapus (55 MB mobile + 9.8 MB Dashboard), belum dieksekusi |
| `uuid` di 4 backend | Sudah di-hapus manual lebih dulu oleh saya; grep 0 match |

## Bug yang KETANGKAP saat menjalankan test suite

`npm run test:unit` (mobile-trip): **4 pass / 1 gagal-load** — `ota.test.ts` error:

```
Error: Failed to resolve import "@capacitor/http" from "src/services/ota.ts".
```

**Akar masalah:** `ota.ts` masih punya lazy import `await import('@capacitor/http')`. Paket itu deprecated sejak Capacitor 5 (digabung ke `@capacitor/core` sebagai `CapacitorHttp`) dan sudah lama dihapus dari `package.json`. Blok `try/catch` di runtime tidak menolong — Vite menolak di tahap resolusi modul, sebelum catch dieksekusi.

**Fix:**

```ts
// src/services/ota.ts
let _capacitorHttp: any = null
async function getCapacitorHttp(): Promise<any> {
  if (_capacitorHttp) return _capacitorHttp
  try {
    const core = await import('@capacitor/core')
    _capacitorHttp = (core as any).CapacitorHttp ?? null
  } catch {
    _capacitorHttp = null
  }
  return _capacitorHttp
}
```

Fallback `fetch` di web tetap utuh; interface `nativeFetch()` tidak berubah.

## Hasil

| Check | Sebelum | Sesudah |
|---|---|---|
| `npm run test:unit` (mobile-trip) | 4 pass, 1 error load (38 tests) | **5/5 suite, 41/41 tests, exit 0** |
| `npx tsc --noEmit` | exit 0 | exit 0 |
| `npm run build` | exit 0 | exit 0 |
| Import `@capacitor/http` | 1 (via dynamic import) | 0 (tinggal komentar) |

## Sisa yang masih lazat dibersihkan (belum dieksekusi)

```
mobile-trip/graphify-out/           55 MB   (0 referensi)
Trip-Dashboard/graphify-out/        9.8 MB  (0 referensi)
www/ di 3 app                       ±13 MB  (regenerate via ng build)
mobile-trip root: 3rdpartylicenses.txt, prerendered-routes.json, index.html lama  ~50 KB
```

`android/` (313 MB total, 79 file tracked) — **tidak** direkomendasikan dihapus: native project siap-build.

## Pelajaran

1. **Klaim "X bisa dihapus" harus diverifikasi greb nyata sebelum dieksekusi** — sebagian kecil klaim awal false positive (vitest/tesseract/rxjs/tslib).
2. **Menghapus dependency bisa memutus lazy import** yang hanya terlihat saat module dimuat runtime/test — bukan saat build. Test suite penangkapnya.
3. `tsc --noEmit` saja TIDAK menjamin aman menghapus dep: dynamic import `await import('@capacitor/http')` sliding melalui try/catch di TS, tapi gagal di resolusi Vite.
