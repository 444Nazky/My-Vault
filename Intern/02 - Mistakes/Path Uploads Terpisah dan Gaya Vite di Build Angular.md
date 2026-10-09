# Mistake — Path `__dirname` yang Dibedakan & Gaya Vite di Build Angular

> **Tanggal:** 30 September 2026 · **Dampak:** semua foto dokumentasi 404
> **dan** dashboard admin blank sampai kedua akar masalah diperbaiki.

## Jebakan 1 — `path.join(__dirname, '..', 'uploads')` di dua level berbeda

```js
// backend/src/index.js        → __dirname = backend/src         → backend/uploads      ✓
// backend/src/routes/trips.js → __dirname = backend/src/routes  → backend/src/uploads  ✌ salah
```

Kodenya **terlihat sama**, tapi hasilnya beda folder. Gejalanya klasik dan gampang
disalahartikan: file *ada* di disk, API melaporkan upload sukses, tetapi `GET /uploads/...`
membalas **404** dan gambar di dashboard rusak.

**Pelajaran:** lokasi penyimpanan bersama jangan dihitung ulang tiap file —
pakai satu modul (`backend/src/uploads-dir.js`) yang dipakai static server dan multer.

## Jebakan 2 — `import.meta.env` / `VITE_API_URL` di build Angular

```ts
const BASE_URL = (import.meta as { env: { VITE_API_URL?: string } }).env.VITE_API_URL
                 || 'http://localhost:3001'
```

- `import.meta.env` adalah idiom **Vite**. Angular CLI memakai esbuild dan tidak
  mendefinisikannya, jadi ekspresinya `undefined` → `TypeError` saat modul dievaluasi.
- Karena terjadi di **module top-level**, seluruh React app gagal mount:
  `#root` kosong, halaman admin terlihat "tidak ada apa-apa" (padahal JS 200 OK).
- Fallback `3001` juga salah — backend berjalan di **3000**.

**Pelajaran:** di proyek ini semua URL API diambil dari
`getApiBaseUrl()` (`src/services/api.ts`), dan foto dari `resolvePhotoUrl()`.
Jangan menyalin pola konfigurasi Vite ke build Angular.

## Jebakan 3 (bonus) — `pkill -f` yang membunuh shell sendiri

```bash
pkill -f 'src/index.js' && node --check backend/src/index.js   # ❌ shell ikut mati
```

`pkill -f` mencocokkan seluruh command line **termasuk perintah yang sedang berjalan**,
jadi kata kunci yang juga muncul di perintah Anda membuat proses sendiri terbunuh.
Pakai pola regex `[n]g serve` / `src/index[.]js`, atau lebih aman: ambil PID dari
`ss -ltnp | grep :3000` lalu `kill $pid`.

Terkait: [[../01 - Fixes/Foto Dokumentasi Admin Dashboard Tidak Muncul]] · [[tr]]
