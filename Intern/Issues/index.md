# Issues & Current Status — September 2026

## Open Issues

1. **Region Select Screen E2E Test** — Belum diuji secara end-to-end di emulator/sebenarnya. Need verification that:
   - Dual-access officer sees dialog + can select region
   - Single-access officer does NOT see dialog
   - After selection, trip proceeds correctly to condition screen

2. **Performance Impact** — Dialog menambah 1 extra step sebelum trip memulai. Need benchmark apakah user experience terganggu bagi pengguna power users yang sering ganti region.

3. **Backend API Coverage** — Pastikan `GET /routes/mine` dan `POST /auth/region-login` sudah support region yang baru ditambahkan (Entikong D1/D2 beserta rutenya).

## Solved Issues (2026-10-01)

- ✅ Design admin dashboard "rollback" dipulihkan — `AdminDashboard.tsx` dikembalikan ke arsitektur split-tab (233 baris) dari `origin/main~1` (`3f8f9ec`)
- ✅ Header `Cache-Control: no-store` di `admin-ci/index.php` dipulihkan
- ✅ `tsc` 0 error · `ng lint` pass · `ng build` sukses · E2E `:8000` **13/13 PASS, 0 exception**
- ✅ Catatan: `git pull` tidak bisa memperbaiki ini karena commit rusak sudah ter-push — pulihkan **per-file** dari history
- Detail: [[../01 - Fixes/Restore Design Admin Dashboard dari Git History]] · [[../02 - Mistakes/Commit Angular Menimpa AdminDashboard Split-Tab]]

## Solved Issues (2026-09-29)

- ✅ RegionSelectScreen.tsx implemented dan compiles 0 error
- ✅ HomeScreen.tsx terintegrasi dengan logika hasDualAccess
- ✅ Double-check mitigasi ganda (region selection + confirm) bekerja sebagai expected
- ✅ TypeScript dan lint pass semua tab

## Progress Summary — 28-29 September 2026

| Hari | Fitur Utama | Status |
|------|-------------|--------|
| 28 Sep | Master Rute, Login Region, PIN Keypad | ✅ Selesai (lihat 01 - Fixes) |
| 29 Sep | Region Select Screen untuk Dual Access | ✅ Selesai (lihat ini) |
| 30 Sep | Offline-First, Prefetch Petugas, Rekap Wilayah | ✅ Selesai (lihat Finished ✅ #14) |
| 1 Okt | Restore design admin dashboard (anti-rollback) | ✅ Selesai (lihat 01 - Fixes) |

## Catatan Penting

- Fitur ini hanya mempengaruhi petugas dengan `dermagaAccess.length > 1`
- Mayoritas petugas (single access) tidak terpengaruh, alur tetap seperti sebelumnya
- Semua perbaikan terverifikasi `tsc 0 error · ng lint pass · ng build sukses`