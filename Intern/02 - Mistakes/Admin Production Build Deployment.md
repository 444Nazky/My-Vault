# Mistake — Admin Dashboard di Port 8000 Bukan PHP Murni

> **Tanggal:** 2026-09-29 · **Dampak:** Build production admin tidak otomatis ter-update, edit tersimpan tapi UI lama terus tampil

## Kejadian

Berjam-jam mengedit `archive/admin/index.php` (PHP standalone) — menambahkan kolom Foto & Lokasi — sementara admin dashboard production tidak pernah berubah. Setiap rebuild Angular mengoutput ke `www/` tapi build folder `admin-ci/` tidak pernah di-copy, PHP server terus menyajikan build lama. Edit di `src/pages/admin/AdminDashboard.tsx` tidak pernah sampai ke browser.

## Root Cause

Arsitektur deployment yang tidak baku:

```
npm run build  → www/ (dev default)
PHP serve      → www/ (www/index.html)

 Tapi admin di :8000 → tidak menggunakan www/ untuk production.
```

Admin dashboard production hidup di folder terpisah (`admin-ci/`) dengan PHP wrapper. Build perlu di-copy manual setiap kali Angular merebuild.

## Tanda-Tanda Serupa

- Edit di `src/` sudah masuk source map/build output
- `ng build` menghasilkan bundle baru (hash berbeda)
- Browser masih menampilkan UI lama

## Perbaikan

Proses deployment admin production manual tapi sederhana:

```bash
# 1. Setiap selesai build Angular:
cp -r www/* admin-ci/
cp archive/admin-ci/index.php admin-ci/

# 2. Server PHP sudah otomatis serve dari admin-ci/ karena polling file stat.
#    Atau restart manual:
pkill -f "php -S localhost:8000"
cd admin-ci && php -S localhost:8000
```

## Pelajaran

1. **ARC system tidak ada deployment otomatis** — build perlu didistribusikan manual
2. PHP serve polling filesystem tapi polling tidak otomatis memicu page reload
3. Untuk production, script build perlu copy output ke folder deployment
4. Frontend rebuild ≠ deployment — deployment perlu di-trigger manual
5. Selalu verify: `ls admin-ci/*.js` vs `ls www/*.js` — hash bundle harus sama
