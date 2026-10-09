# Production Build Tree-Shaking Issue

**Tanggal:** 29 September 2026

## Masalah
Function `memberLogin` tidak muncul di bundle production build (`npm run build`), sehingga login page baru tidak berfungsi di browser.

## Gejala
- Source code benar (ada `memberLogin` di LoginPage.tsx)
- Build sukses tanpa error
- Tapi browser masih menampilkan halaman lama

## Root Cause
Angular production build pakai `optimization: true` yang tree-shake code yang tidak dipakai. Function yang di-import tapi belum terpakai bisa ikut terbuang.

## Solusi
Untuk development build, gunakan:

```bash
npx ng build --configuration=development
npx cap sync android
```

Bukan `npm run build` yang production.

## Pencegahan
Selalu verify bundle setelah build:
```bash
grep -c "memberLogin" www/main.js
```
Development build: hasilnya > 0
Production build: hasilnya mungkin 0
