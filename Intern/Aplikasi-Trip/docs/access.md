# Master Dashboard — Akses Wilayah, Dermaga & Rute

> Terakhir diperbarui: 28 September 2026 · data sesuai Revisi #3 (Master Rute) & #4 (login wilayah)

## 1 - Struktur Wilayah dan Rute

| Wilayah | Dermaga | Rute Tersedia |
| :--- | :--- | :--- |
| **Badau** (`BADAU`) | Dermaga 1 (`D1`) | SJRE → SBDZ · SBDZ → SJRE |
| **Badau** (`BADAU`) | Dermaga 2 (`D2`) | AAAA → BBBB · BBBB → AAAA |
| **Belitung** (`BELITUNG`) | Dermaga 1 (`D1`) | CCCC → DDDD · DDDD → CCCC |
| **Belitung** (`BELITUNG`) | Dermaga 2 (`D2`) | EEEE → FFFF · FFFF → EEEE |
| **Kelapa Kampit** (`KELAPAKAMPIT`) | Dermaga 1 (`D1`) | GGGG → HHHH · HHHH → GGGG |
| **Kelapa Kampit** (`KELAPAKAMPIT`) | Dermaga 2 (`D2`) | IIII → JJJJ · JJJJ → IIII |

> Nama rute bisa diubah dinamis dari dashboard admin → tab **Master Rute**.
> Relasi disimpan di tabel `dermagas` + junction `officer_dermagas`.

## 2 - User Mobile Access Rule

* Pegawai hanya melihat rute dari **dermaga yang diaksesnya** — diambil dari
  `GET /api/routes/mine` saat layar Pilih Rute dibuka.
* Contoh: Budi Santoso diset di Badau **Dermaga 1**, maka hanya melihat
  `SJRE → SBDZ` dan `SBDZ → SJRE`. Rute Dermaga 2 wilayah lain **tidak tampil**.
* **Trip kosong** (tanpa muatan): rute dikunci hanya `SJRE → SBDZ` —
  bila dermaga petugas tak punya rute itu, aplikasi memakai rute statis cadangan.

## 3 - Double Access (akses ganda)

* Petugas dengan dua dermaga (mis. **Dewi Kusuma** = Badau D1 + D2) melihat
  **semua rute kedua dermaga** di layar Pilih Rute (`/routes/mine` mengembalikan 4 rute).
* Saat alur **Ganti Petugas** (`PinVerifyScreen` → `DermagaSelectScreen`),
  pemimpin sistem menanyakan dermaga mana yang dipakai untuk sesi aktif
  (`POST /auth/select-dermaga`).

## 4 - Tahap Percobaan (Dummy Users)

| No | Nama | Wilayah | Dermaga | Akses Rute | PIN |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Budi Santoso | Badau | D1 | SJRE ⇄ SBDZ | 123456 |
| 2 | Andi Pratama | Badau | D2 | AAAA ⇄ BBBB | 123456 |
| 3 | Dewi Kusuma | Badau | D1 & D2 (dual) | SJRE ⇄ SBDZ, AAAA ⇄ BBBB | 123456 |
| 4 | Siti Rahayu | Badau | D1 | SJRE ⇄ SBDZ | 123456 |
| 5 | Agung Suntoso | Belitung | D1 | CCCC ⇄ DDDD | 123456 |
| 6 | Rahmat Hidayat | Belitung | D2 | EEEE ⇄ FFFF | 123456 |
| 7 | Hendra Gunawan | Kelapa Kampit | D1 | GGGG ⇄ HHHH | 123456 |
| 8 | Maya Sari | Kelapa Kampit | D2 | IIII ⇄ JJJJ | 123456 |

Login sekarang 2 langkah: **wilayah + password** → pilih petugas → **PIN**.

## 5 - UI Mobile & Credentials

* Tombol di halaman profil memakai **Logout** (bukan "Ganti Petugas");
  pergantian petugas dilakukan lewat layar **Ganti Petugas** di shell mobile.
* Kredensial wilayah & petugas lengkap ada di:
  **`Intern/accounts and regions.md`** (file lama `summary/Accounts.md` sudah tidak dipakai).

Terkait: [[../accounts and regions]] · [[../Revisi]]
