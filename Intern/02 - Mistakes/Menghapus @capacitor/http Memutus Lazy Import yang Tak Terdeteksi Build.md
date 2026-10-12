---
title: "Menghapus @capacitor/http Memutus Lazy Import yang Tak Terdeteksi Build"
date: 2026-10-12
tags: [capacitor, vitest, dynamic-import, unit-test, false-negative, dependency]
status: resolved
related:
  - "[[audits/dependency-reaudit-and-vitest-fix]]"
  - "[[audits/over-engineering-audit-cleanup]]"
---

# Kesalahan: Menghapus `@capacitor/http` Memutus Lazy Import yang Terlewat Build

## Apa yang terjadi

Setelah pruning dependency (termasuk `@capacitor/http` — deprecated sejak Capacitor 5, digabung ke `@capacitor/core` sebagai `CapacitorHttp`), semua gate lulus: `tsc --noEmit` exit 0, `ng build` sukses, `ng lint` bersih. Saya mengira aman.

Ketika menjalankan `npm run test:unit` (mobile-trip) untuk audit ulang, ternyata:

```
Test Files  1 failed | 4 passed (5)
FAIL  src/services/ota.test.ts
Error: Failed to resolve import "@capacitor/http" from "src/services/ota.ts". Does the file exist?
```

## Akar masalah

`ota.ts` masih memuat lazy import:

```ts
const m = await import('@capacitor/http')   // ❌ paket sudah dihapus
```

Tiga hal yang membuatnya lolos dari semua check:

1. **La secara dinamis** — `await import(...)` di dalam blok `try/catch`, bukan import statis di atas file. Grep import statis tidak menangkapnya begitu kecolongan.
2. **try/catch melindungi TS & runtime** — `tsc` melihat *dynamic import dengan catch* sebagai "boleh gagal", jadi tidak error.
3. **`ng build` tidak memantulkan modul yang hanya dimuat saat test/di jalur belum dieksekusi** — bundle development tidak men-chunk file itu.

Tapi **Vite (vitest) menolak di fase resolusi modul — sebelum catch sempat dieksekusi** — baris error menunjuk `src/services/ota.ts:28:27`.

## Cara mengatasi

Ganti sumber import ke lokasi yang benar, bukan meng-suppress error:

```ts
// Sebelum (❌)
const m = await import('@capacitor/http')

// Sesudah (✅)
const core = await import('@capacitor/core')
_capacitorHttp = (core as any).CapacitorHttp ?? null
```

CapacitorHttp memang hasil merger dari `@capacitor/http` — perilaku sama, fallback `fetch` di web tetap utuh, interface `nativeFetch()` tak berubah.

## Verifikasi

```
npm run test:unit   → 5/5 suite, 41/41 tests, exit 0 (sebelum: 1 gagal, 38 tests)
npx tsc --noEmit    → exit 0
npm run build       → exit 0
grep '@capacitor/http' src/ → hanya komentar, 0 import aktif
```

## Pelajaran

1. **Hapus dependency setelah grep dua pola, bukan satu**: pola import statis `from 'x'` **dan** `import('x')` (dynamic).
2. **`tsc --noEmit` + `ng build` = dua gate itu TIDAK cukup untuk memvalidasi penghapusan dep.** Test suite (vitest) yang membuka lebar semua module graph adalah gate ketiga yang benar-benar membongkar masalah ini.
3. Paket deprecated yang "digabung ke paket lain" tugasnya dua arah: nama lama hilang dari `package.json` belum tentu hilang dari kode — sumber referensi terakhir harus di `src/`, bukan `package.json`.
4. try/catch di dynamic import hanya mengelola *runtime* failure, bukan *bundler* failure; dua dunia berbeda.

## Rujukan

- [[audits/over-engineering-audit-cleanup]] — sesi pruning awal lulus semua gate hal ini
- [[audits/dependency-reaudit-and-vitest-fix]] — sesi yang menangkap bug ini saat audit ulang
