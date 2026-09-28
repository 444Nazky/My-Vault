# Akun Wilayah & Pegawai — Trip Angkutan

> Terakhir diperbarui: **28 September 2026** · Sesuai Revisi #4 (login region) & #3 (Master Rute)

## Alur Login (2 langkah)

1. **Login Wilayah** — kode wilayah + password wilayah (contoh: `BADAU` / `badau123`)
2. **Pilih Petugas** — daftar petugas **aktif milik wilayah tersebut** (berbeda tiap wilayah)
3. **Verifikasi PIN** — PIN masing-masing petugas → masuk aplikasi

> Login username/password lama (`budi/123456`) sudah tidak dipakai untuk petugas.
> Mode **Administrator** masih ada lewat tautan "Login Administrator" di bawah kartu login.

## Kredensial Wilayah

Password default = `<kode-wilayah huruf kecil>123` (disimpan bcrypt, bisa diganti admin).

| Kode | Nama Wilayah | Password Default | Petugas Aktif |
| ---- | ------------ | ---------------- | ------------- |
| `BADAU` | Badau | `badau123` | Budi Santoso, Andi Pratama, Siti Rahayu, Dewi Kusuma |
| `BELITUNG` | Belitung | `belitung123` | Agung Suntoso, Rahmat Hidayat |
| `KELAPAKAMPIT` | Kelapa Kampit | `kelapakampit123` | Hendra Gunawan, Maya Sari |

> Region lama `SJRE` (Sijangkung), `SBDZ` (Sabadi), `ENTIKONG` (Entikong) masih ada di DB
> untuk data trip lama — punya password default juga, tapi tanpa Master Rute spec.

## Kredensial Petugas — semua PIN `123456`

| Nama | Wilayah | Akses Dermaga | Rute yang Tampil |
| ---- | ------- | ------------- | ---------------- |
| Budi Santoso | BADAU | D1 | SJRE ↔ SBDZ |
| Andi Pratama | BADAU | D2 | AAAA ↔ BBBB |
| Siti Rahayu | BADAU | D1 | SJRE ↔ SBDZ |
| Dewi Kusuma | BADAU | **D1 + D2 (dual)** | SJRE ↔ SBDZ **dan** AAAA ↔ BBBB |
| Agung Suntoso | BELITUNG | D1 | CCCC ↔ DDDD |
| Rahmat Hidayat | BELITUNG | D2 | EEEE ↔ FFFF |
| Hendra Gunawan | KELAPAKAMPIT | D1 | GGGG ↔ HHHH |
| Maya Sari | KELAPAKAMPIT | D2 | IIII ↔ JJJJ |
| Rizky Maulana | ENTIKONG | — | rute lama (`A→B`) |

**Aturan trip kosong:** pilihan rute dikunci hanya `SJRE → SBDZ` — bila dermaga petugas
tak punya rute itu, aplikasi memakai rute statis cadangan.

## Master Rute (Revisi #3)

Dikelola dinamis lewat dashboard admin → tab **Master Rute**. Hasil edit langsung terpakai
oleh aplikasi petugas saat layar Pilih Rute dibuka (endpoint `GET /api/routes/mine`), tanpa perlu logout/login ulang.

| Wilayah | Dermaga 1 | Dermaga 2 |
| ------- | --------- | --------- |
| Badau | SJRE → SBDZ · SBDZ → SJRE | AAAA → BBBB · BBBB → AAAA |
| Belitung | CCCC → DDDD · DDDD → CCCC | EEEE → FFFF · FFFF → EEEE |
| Kelapa Kampit | GGGG → HHHH · HHHH → GGGG | IIII → JJJJ · JJJJ → IIII |

## Admin Dashboard

| Role | Username | Password |
| ---- | -------- | -------- |
| Admin | `admin` | `admin123` |

## Catatan Teknis

- Relasi petugas ↔ dermaga: tabel junction **`officer_dermagas`** (banyak-ke-banyak).
- Relasi petugas ↔ wilayah: tabel junction **`officer_regions`**.
- Status aktif/nonaktif petugas & pemindahan wilayah dikelola di tab **Petugas** admin;
  perubahan langsung memengaruhi login mobile (refresh JWT / daftar petugas region).

Terkait: [[Revisi]] · [[01 - Fixes/Master Rute Wilayah dan Login Region]]
