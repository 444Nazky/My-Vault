# Mistake — Region Selection Dialog Tidak Diusahakan untuk Single-Access Officers (Belum Terverifikasi Parsial)

> **Tanggal:** 29 September 2026 · **Dampak:** Minor — officer single access tidak terpengaruh, tapi perlu memastikan tidak ada regresi

## Kejadian

Saat mengimplementasikan Region Select Screen untuk petugas multi-akses, terjadi penemuan bahwa logika `hasDualAccess` perlu diuji extra terhadap officer single-access. Jika logika salah, officer single-access juga akan melihat dialog region yang tidak relevan.

## Pelajaran

1. **Validasi type guard yang tepat** — Pastikan `hasDualAccess` check menggunakan optional chaining dan length check yang benar:
   ```ts
   const hasDualAccess = !!(officer.dermagaAccess && officer.dermagaAccess.length > 1)
   ```
   — Menggunakan `!!` (double negation) untuk memastikan boolean, dan `?.` untuk optional chaining menghindari runtime error jika `dermagaAccess` undefined.

2. **Jangan abaikan case single-access** — Meskipun fitur hanya dimaksudkan untuk minority (petugas dual access), pastikan `else` branch tetap berfungsi baik untuk mayoritas (single access). Regresi pada fitur lama tidak boleh terjadi.

3. **Documentasi boundary condition** — Catat kondisi batas (boundary condition) di dokumentasi, seperti "hanya muncul untuk officer dengan dermagaAccess.length > 1", agar developer yang datang tidak bingung jika melihat kondisi jika-else tersebut.

4. **Testing edge case** — Skenario test minimal: cek bahwa officer dengan `dermagaAccess = undefined`, `dermagaAccess = []`, dan `dermagaAccess = [singleItem]` semua berperilaku sesuai ekspektasi.

## Catatan

Masalah ini tidak mengganggu fitur utama karena logika sudah benar, tapi menjadi catatan untuk pengembangan masa depan agar feature tambahan tidak lupa mempertimbangkan kasus edge.

Terkait: [`01 - Fixes/Region Select Screen Untuk Petugas Multi-Akses.md`]