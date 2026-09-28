# Mistake — Dev Server Masih Berjalan dari Folder yang Sudah Terhapus

> **Tanggal:** 28 September 2026 · **Dampak:** semua edit UI di `:5173` seolah "tidak masuk"
> **Gejala:** kode sudah diubah & build sukses, tapi browser tetap menampilkan UI lama

## Kejadian

Saat menguji redesain form Input Kendaraan, uji E2E menampilkan UI **versi lain**
(tombol "Ambil Foto Dokumentasi Dahulu", padahal tidak ada di `src/` mana pun).

Penyebabnya:

```
$ readlink /proc/8773/cwd
/home/nazky/.local/share/Trash/files/Intern/Aplikasi-Trip-Ionic
$ tr '\0' ' ' < /proc/8773/cmdline
ng serve --port 5173 (app)
```

`ng serve` sudah berjalan sejak proyek **terpindah/terhapus ke trash** — prosesnya
tidak mati, hanya kehilangan file sumbernya, lalu tetap menyajikan isi folder trash
(baseline versi lama) di `localhost:5173`.

## Pelajaran

1. **Dev server ≠ folder kerja.** Saat hasil di browser tidak cocok dengan kode,
   jangan langsung curiga kode/HMR — **cek dulu `readlink /proc/<pid>/cwd`**.
   Dev server yang dijalankan berjam-jam bahkan hari sebelumnya bisa menunjuk
   folder lama (hasil `mv`, restore, atau hapus-pulih).
2. **Folder proyek sempat terhapus/terpindah** pada 28 Sep pagi. Proses panjang
   seperti `ng serve`, `php -S`, `node backend` **harus di-restart setelah**
   proyek dipindah/dipulihkan.
3. Cara memastikan: `ls -l /proc/<pid>/cwd` lalu bandingkan dengan folder yang
   sedang diedit. Kalau beda → kill & start ulang dari folder yang benar.

## Perbaikan

```bash
kill 8773
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic
npx ng serve --port 5173   # cwd = folder yang benar
```

Setelah restart, uji E2E langsung menampilkan kode terkini (form 4/4 wajib,
tabel laporan gaya spreadsheet).

## Tanda-tanda serupa

- Edit file tidak muncul walau `ng build`/`tsc` sukses.
- Teks UI yang tak ditemukan di `grep -r` folder kerja.
- Proses lama punya `cwd` di lokasi aneh (trash, worktree, backup).
