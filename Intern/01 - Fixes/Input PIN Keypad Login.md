# Fix — Input PIN Login Diganti Keypad

> **Tanggal:** 28 September 2026 · **Status:** selesai & terverifikasi E2E

## Masalah

Langkah PIN di halaman login (setelah memilih petugas) masih berupa **input kolom
biasa** (`type="password"` + ikon mata) — tidak konsisten dengan layar
Verifikasi PIN di alur Ganti Petugas (`PinVerifyScreen`) yang sudah memakai numpad.

## Perbaikan (`src/pages/LoginPage.tsx`)

Desain keypad dipakai penuh di dalam kartu login:

- Ikon gembok di kotak gelap `#0F172A` + judul **"Verifikasi PIN"** + nama petugas target
- **6 dot indicator** kotak (`w-10 h-10`): terisi = `bg-blue-500` + titik putih,
  saat error = merah (`border-red-400 bg-red-50`)
- **Numpad 3×4** (`1-9`, `0`, `⌫`) — tekan `active:scale-95`, tombol hapus abu
- Tombol **Konfirmasi** gelap `#0F172A`, `disabled` sampai 6 digit + saat loading
- Tautan kecil **"Ganti petugas"** untuk kembali ke daftar
- Input kolom lama (`••••••`) dihapus dari layar ini

`PinVerifyScreen` (ganti petugas) sudah memakai desain yang sama sejak awal, jadi
kedua titik entry PIN kini seragam.

## Verifikasi E2E (Chromium)

| Uji | Hasil |
|---|---|
| Struktur: 11 tombol keypad, 6 dot, judul + nama petugas | ✅ |
| Input kolom lama tidak ada lagi | ✅ |
| 6 ketukan → dot terisi 6, Konfirmasi aktif | ✅ |
| PIN salah (`111111`) → error merah + digit di-reset | ✅ |
| PIN benar via keypad (`123456`) → dashboard "Siap bertugas?" | ✅ |
| `tsc` 0 error · `ng lint` pass · `ng build` sukses · `admin-ci` tersinkron | ✅ |

Terkait: [[Revisi]] · [[01 - Fixes/Petugas Master Akses Dermaga dan Rute]]
