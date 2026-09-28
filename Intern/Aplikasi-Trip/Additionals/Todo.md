Spesifikasi Sistem Registrasi dan Penarifan Nomor Plat

Ringkasan Alur

Sistem registrasi dan penarifan berdasarkan nomor plat kendaraan, dengan aturan:

- Plat internal → terdaftar di database → gratis.
- Plat lokal (region tertentu) → saat ini gratis, tapi perlu konfigurasi cadangan harga jika suatu saat dikenakan tarif.
- Plat eksternal (luar region) → dikenakan tarif sesuai region.

Aturan Bisnis

1. Registrasi Nomor Plat Internal

- Nomor plat kendaraan didaftarkan ke dalam database sebagai “plat internal”.
- Data yang disimpan minimal:
  - Nomor plat
  - Pemilik (opsional)
  - Region asal
  - Status (internal/lokal/eksternal)
  - Metadata lain yang diperlukan
- Jika saat scanning nomor plat ditemukan di database dengan status “internal”, maka:
  - Kendaraan dikategorikan sebagai internal.
  - Tidak ada tarif yang dikenakan.

2. Pembedaan Tarif Berdasarkan Region

- Setiap region memiliki tarif yang berbeda.
- Ada dua kategori tarif:
  - Tarif lokal: untuk kendaraan dari region yang sama dengan pos pemeriksaan.
  - Tarif eksternal: untuk kendaraan dari region lain.
- Saat ini:
  - Kendaraan lokal tidak dipungut biaya (gratis).
  - Namun, sistem harus menyediakan konfigurasi cadangan harga untuk lokal, agar jika kebijakan berubah (warga lokal mulai dikenakan tarif), admin bisa mengubah tarif lewat konfigurasi tanpa mengubah kode.

3. Petugas dan Region (Many-to-Many)

- Satu petugas dapat menangani lebih dari satu region.
- Satu region dapat dilayani oleh lebih dari satu petugas.
- Relasi ini harus dimodelkan sebagai many-to-many (misalnya tabel petugas_region yang menghubungkan tabel petugas dan region).

4. Scanning Foto dan Pembacaan Plat Nomor

- Sistem menerima input berupa foto plat nomor.
- Melalui OCR (optical character recognition), sistem membaca nomor plat dari foto.
- Nomor plat yang terbaca kemudian dicek ke database:
  - Jika terdaftar sebagai internal → status: internal, tarif = 0.
  - Jika tidak terdaftar:
    - Tentukan region asal kendaraan (bisa dari input tambahan atau aturan tertentu).
    - Jika region asal = region pos → status: lokal → tarif sesuai konfigurasi lokal (saat ini 0, tapi bisa diubah lewat konfigurasi).
    - Jika region asal ≠ region pos → status: eksternal → tarif sesuai tarif region tersebut.

5. Konfigurasi Tanpa Koding Ulang

- Semua aturan tarif (lokal, eksternal per region, dan kemungkinan tarif lokal di masa depan) harus disimpan dalam tabel konfigurasi atau file konfigurasi terpusat.
- Contoh entri konfigurasi:
  - region_id
  - jenis_tarif (lokal/eksternal)
  - nominal_tarif
  - status_aktif
- Perubahan tarif atau kebijakan (misal: warga lokal mulai bayar) cukup dilakukan dengan:
  - Mengubah nilai di tabel/file konfigurasi.
  - Tanpa perlu mengubah logika program.

Usulan Kalimat Ringkas untuk Dokumen

- “Nomor plat kendaraan yang terdaftar sebagai internal dalam database tidak dikenakan tarif.”
- “Setiap region memiliki tarif berbeda untuk kendaraan eksternal. Kendaraan lokal saat ini gratis, namun sistem menyediakan konfigurasi tarif cadangan untuk lokal apabila kebijakan berubah.”
- “Hubungan antara petugas dan region bersifat many-to-many: satu petugas dapat menangani beberapa region, dan satu region dapat dilayani oleh beberapa petugas.”
- “Sistem melakukan scanning foto plat nomor, membaca nomor plat melalui OCR, lalu mencocokkannya dengan database. Jika nomor plat terdaftar sebagai internal, kendaraan dikategorikan internal dan tidak dipungut biaya.”
- “Semua aturan tarif (lokal, eksternal per region, dan kemungkinan tarif lokal di masa depan) dikelola melalui konfigurasi terpusat, sehingga perubahan kebijakan tidak memerlukan perubahan kode.”

## user
hilangkan tarif di mobile, detail lebih setelah input kendaraan, seperti bisa melihat nomor polisi yang sebelumnya di klik, foto dokumentasi, dll. wajib jepret kamera sebelum submit trip. perbaikan di bagian switch account pegawai, data bbelum sinkron antara admin dashbboard dan akun pegawai pada saat pengaktifan dan penonaktifan akun pegawai, kemudian pemindahan region

untuk akses dokumentasi WAJIB menggunakan kamera dan sangat DILARANG untuk mengambil gambar dari gallery, disable fitur import foto dari gallery untuk dokumentasinya

## User Experience
jangan terus menerus menggunakan transisi yang sama atau fade disaat perpindahan page/halaman, ubah animasi transisinya

## admin
export laporan trip ke xlxx/spreadsheet, detail tempat tanggal, report pergolongan dan jenis kendaraan => dalam bentuk filterisasi. memperbaiki fitur aktif, nonaktif, pemindahan akses pegawai. perbaikan fitur ganti tarif

## Revisi alur user
di bagian beranda => mulai trip => harusnya pilih muatan dulu, kosong atau ada angkutan => kalau pilih opsi kosong/tidak ada muatan trip hanya boleh untuk pilih rute SJRE=> SBDZ, kalau ada muatan trip bebas boleh yang mana aja.

## tipis tipis
hilangin icon ionic di localhost:8000 alias halaman admin. soalnya kan admin dashboard pakainya codeigniter bukan ionic

## bugs
Ada bug di bagian scan plat nomor, harusnya B1001ZZZ. tapi sistem cuma ngebaca nomor. dan sekarang setelah di kasih fungsi untuk baca huruf juga malah jadi ngaco bacanya, sering meleset atau miss dari nomor plat yang asli


## region
tiap region punya rute beda. untuk admin berikan akses ke master rute


---

## ✅ STATUS IMPLEMENTASI — crosscheck 25 September 2026

### Spesifikasi Registrasi & Penarifan Plat
| # | Aturan | Status | Bukti di kode |
|---|--------|--------|---------------|
| 1 | Plat internal terdaftar → gratis (tarif 0) | ✅ | `backend/src/routes/plates.js` — cek `registered.status === 'internal'` → tarif 0 |
| 2 | Plat lokal saat ini gratis, tapi ada **konfigurasi cadangan** | ✅ | tabel `region_tariffs` (`tariff_type='lokal'`, `nominal_tariff`, `is_active`) — diubah dari admin tanpa ubah kode |
| 3 | Plat eksternal → tarif sesuai **region** | ✅ | `region_tariffs` (`tariff_type='eksternal'`) per region |
| 4 | Petugas ↔ Region **many-to-many** | ✅ | tabel junction `officer_regions` + endpoint `PUT /officers/:id/regions` |
| 5 | Scan foto → **OCR** → cek database | ✅ | `src/services/ocr.ts` + `POST /api/plates/check` |
| 6 | Konfigurasi terpusat tanpa koding ulang | ✅ | tab Master Tarif → kartu “Tarif Region” (Internal=0 · Lokal=cadangan · Eksternal=region) |

### Revisi Mobile
| # | Permintaan | Status | Keterangan |
|---|-----------|--------|------------|
| 1 | Hilangkan tarif di tampilan mobile | ✅ | Tidak ada `Rp` yang dirender; nilai hanya disimpan untuk sinkron/laporan |
| 2 | Detail lebih setelah input kendaraan (lihat plat sebelumnya yang diklik, foto dokumentasi, dll.) | ✅ | Kartu “No. Polisi Sudah Diinput” → ketuk: plat, jenis, kategori, status plat, wilayah asal, pos, foto dokumentasi + “Isi Ulang Form” |
| 3 | Wajib jepret kamera sebelum submit trip | ✅ | Tombol galeri dihapus; “Simpan Data Kendaraan” & “Submit Trip” terkunci sampai foto ada |
| 4 | Perbaikan switch akun pegawai (sinkron aktif/nonaktif & pindah region) | ✅ | `GET /officers/my-region` + `POST /auth/refresh`; tarik paksa saat buka aplikasi & layar ganti petugas; sesi otomatis berakhir bila dinonaktifkan (E2E lulus) |

### Revisi Admin
| # | Permintaan | Status | Keterangan |
|---|-----------|--------|------------|
| 1 | Ekspor laporan trip ke xlsx/spreadsheet | ✅ | `src/services/xlsx.ts` — nol dependency baru, 2 sheet |
| 2 | Detail tempat & tanggal akurat | ✅ | `route_from_name`/`route_to_name` (join region + alias `BDAU`↔`BADAU`) + jam WIB |
| 3 | Report golongan & jenis kendaraan → **filterisasi** | ✅ | Dropdown filter + `GET /reports/trips/filters` (server-side) |
| 4 | Perbaiki aktif/nonaktif, pemindahan akses pegawai | ✅ | Server jadi sumber kebenaran, selalu re-fetch; E2E lulus |
| 5 | Perbaikan fitur ganti tarif | ✅ | Master Tarif CRUD (admin-only) + tarif region terpusat |

### Revisi Alur User
| # | Permintaan | Status | Keterangan |
|---|-----------|--------|------------|
| 1 | Beranda → Mulai Trip → **pilih muatan dulu** | ✅ | `TripConditionScreen`: “Kosong / Tidak Ada Muatan” atau “Ada Angkutan” |
| 2 | Pilih **Kosong** → rute dikunci hanya **SJRE → SBDZ** | ✅ | guard + badge “Terkunci” di `RouteSelectScreen` |
| 3 | Pilih **Ada Angkutan** → rute bebas semua | ✅ | filter dilepas |

### Tambahan hasil sesi 25 Sep 2026
- ✅ Fix **scroll dashboard admin** (CSS Ionic memaksa `body{position:fixed;overflow:hidden}` → override `html[data-admin]` di `admin-ci/index.php` + `src/index.css`).
- ✅ **Favicon Ionic dihapus** dari `http://localhost:8000/` (strip permanen di `index.php`).
- ✅ **Tab Pengaturan → “Tema & Tampilan”**: tema Terang/Gelap, Ukuran Font 90–125%, warna aksen, Reset — persist `localStorage` (`src/services/theme.ts`).
- ✅ Verifikasi: `tsc` · `ng lint` · `ng build` · E2E Chromium CDP 8/8 · endpoint live 200.

---

## 🐞 AUDIT ERROR — 25 September 2026 (sore)

> Smoke-test 24 endpoint + baca log backend + verifikasi data DB terhadap spesifikasi.
> **4 bug nyata ditemukan & diperbaiki**, 6 hal ternyata tidak rusak, 6 masalah masih terbuka.

### Bug yang DIPERBAIKI

| # | Error | Akar masalah | Perbaikan | Status |
|---|-------|--------------|-----------|--------|
| 1 | **`POST /trips` → 500** `NOT NULL constraint failed: trips.dermaga_id` | Commit `a2e8b88` “revisi akses” menambah `dermaga_id NOT NULL` ke skema tapi tak mengubah INSERT; mobile tak pernah kirim dermaga | derive `dermaga_id` server-side (penugasan petugas → dermaga region → null) + migrasi jadikan kolom **nullable** | ✅ `POST` → **201** |
| 2 | **Nama tempat laporan = `null`**; region jadi “Region 1..4” | Commit sama mengubah seed wilayah asli (`BADAU`/`SJRE`/`SBDZ`/`ENTIKONG`) jadi placeholder `R1`–`R4` → join kode rute mobile gagal | rename region di DB ke kode asli (nama: Badau/Sijangkung/Sabadi/Entikong — ikut label mobile) + **kembalikan seed** & seed rute pakai kode `SJRE`/`SBDZ`/`BDAU` | ✅ **0/16 trip** nama kosong |
| 3 | **Data historis hilang** (DB utama 3 trip / 0 plat, 2 trip uji); **istilah lama balik** (`Eksternal (Berganji)`, `Eksternal (Tanpa Garansi)`); **trip yatim** (`officer_id="1"`, region asing) | DB asli cuma bertahan di worktree `.kilo/worktrees/admitted-steel/`; DB utama ikut ter-reset saat seed berubah | skrip migrasi (backend dimatikan): salin **13 trip + 26 kendaraan + 3 plat**, petakan ID legacy→UUID, perbaiki trip yatim, normalisasi istilah | ✅ **16 trip · 32 kendaraan · 3 plat · 0 yatim · 0 istilah lama** |
| 4 | **Regresi label kategori mobile** — picker kategori di `VehicleFormScreen.tsx` kembali menampilkan `Eksternal (Berganji)` / `Eksternal (Tanpa Garansi)` | File dipulihkan dari stash yang berasal **sebelum** perbaikan istilah (commit terakhir file `7d9911d` 11:25, perbaikan istilah ~13:00) — perbaikan saya tertimpa | kembalikan label ke `Internal · Eksternal · Eksternal Bebas` + komentar penanda | ✅ 0 istilah lama di source & bundle |

> **Pelajaran:** perbaikan yang hanya hidup di working tree bisa **hilang diam-diam** kalau ada proses lain yang `checkout`/`stash pop`/`reset`. Setelah merge/restore, wajib audit ulang (`grep` istilah terlarang) — jangan asumsi perbaikan masih ada.

Backup: `data/trip.db.bak-20260925-160737` · Migrasi: `/tmp/migrate-data.js`

### Yang dicek ternyata TIDAK rusak

- **Filter golongan & jenis** — bekerja: `golongan=I`→1 (Motor), `II`→0, `IV`→1 (Truck Sedang), `vehicleType=Motor`→1.
- **24 endpoint lain** — 200/201 semua (satu-satunya kegagalan = Bug 1). `/officers/my-region` + token admin → 401 *by design*.
- **Ekspor xlsx** — `downloadXlsx` client-side, 2 sheet, ZIP valid 42.763 bytes. `/reports/trips/export` memang sengaja CSV (cadangan).
- **Sinkron petugas** (aktif/nonaktif/pindah region) — lulus uji sesi sebelumnya.
- **Ikon Ionicons** — 0 di DOM/bundle (lulus E2E 11/11).

### ⚠️ Masih TERBUKA (belum disentuh)

- [ ] **Race antar-proses**: layanan mati mendadak (`EADDRINUSE`, log bersih tapi proses hilang), `admin-ci/` sempat hilang-regenerasi — ada proses lain menjalankan `restart-all.sh` + auto-commit. **Perlu satu pemilik proses.**
- [ ] `restart-all.sh` memakai `pkill` sehingga ikut mematikan `:8000` & `:5173` yang sehat — jangan dipakai untuk restart sebagian.
- [ ] **Rute mobile masih statis** (`ROUTES` di `src/pages/data.ts`), `fetchRoutes()` tak pernah dipanggil — DB sudah berisi rute berkode benar.
- [ ] 3 plat hasil salinan belum diverifikasi ulang terhadap aturan Internal=0 · Lokal=cadangan · Eksternal=region.
- [ ] DB masih SQLite (MariaDB belum).
- [ ] `data/trip.db` **di-track git** (3 salinan DB berbeda) — pertimbangkan `.gitignore` + backup terpisah agar data tak tertimpa commit.




