# Fix — Tab Petugas Master: Data Baru, Akses Dermaga & Rute (Revisi #5)

> **Tanggal:** 28 September 2026 · **Status:** selesai & terverifikasi E2E

## Masalah

1. **`GET /api/officers` tidak mengembalikan akses dermaga** — query `dermagaStmt`
   disiapkan di kode tapi **tidak pernah dipanggil**, jadi admin tak tahu petugas
   pegang D1/D2.
2. **`PUT /api/officers/:id/dermagas` tidak ada** (404) — padahal frontend sudah
   punya helper `assignOfficerDermagas()`.
3. Tab Petugas **tidak memuat daftar `regions`** saat dibuka → grup wilayah jatuh ke
   fallback statis `['BADAU','ENTIKONG']` — petugas Belitung/Kelapa Kampit tidak
   punya grup, dan data terlihat "lama".
4. Form petugas hanya bisa memilih **wilayah** — tak ada pilihan dermaga,
   padahal dermaga yang menentukan rute tampil di mobile.
5. `DELETE /officers/:id` meninggalkan baris junction yatim di `officer_dermagas`.

## Perbaikan

### Backend (`backend/src/routes/officers.js`)
- `GET /` → sematkan `dermagas[]` (`id, name, code, region_id`) tiap petugas.
- **Endpoint baru** `PUT /:id/dermagas` `{dermagaIds[]}` → ganti seluruh junction.
- `POST /` terima `dermagaIds[]` (link sekalian saat buat petugas).
- `DELETE /` ikut bersihkan `officer_dermagas`.

### Admin (`src/pages/admin/AdminDashboard.tsx`)
- **Kolom tabel baru:** `Nama · Dermaga · Rute yang Tampil · Status · Aksi`
  - **Dermaga** → chip `D1`/`D2`
  - **Rute** → chip turunan (`SJRE → SBDZ`, dst) dari rute dermaga petugas
- **Form Tambah:** select Wilayah + **checklist Dermaga** (opsi ikut wilayah; ganti
  wilayah → checklist di-reset).
- **Form Edit:** checklist Wilayah + **checklist Dermaga berlabel** `BADAU · Dermaga 1 (D1)`;
  saat Update → `PUT /regions` lalu `PUT /dermagas` (dermaga wilayah yang baru
  dicentang-batal otomatis tersaring).
- Tab memuat `regions` + `dermagas` + `routes` saat dibuka (grup wilayah lengkap:
  BADAU(4) · BELITUNG(2) · KELAPAKAMPIT(2) · ENTIKONG(1) · SBDZ(0) · SJRE(0)).
- `store.tsx`: tipe `Officer` ditambah `dermagaAccess[]`.

## Verifikasi E2E (Chromium + API)

| Uji | Hasil |
|---|---|
| Grup wilayah lengkap + header kolom Dermaga/Rute | ✅ |
| Rute per baris sesuai dermaga (Budi D1 → 2 rute, Dewi D1+D2 → 4 rute) | ✅ |
| Opsi dermaga form ikut wilayah terpilih | ✅ |
| Edit Andi: centang D1 → tabel `D1D2` + **`GET /routes/mine` ikut 4 rute** | ✅ |
| Revert → kembali `D2` + 2 rute | ✅ |
| Petugas uji dibersihkan dari DB setelah uji | ✅ (9 petugas) |
| `tsc` 0 error · `ng lint` pass · `ng build` sukses · `admin-ci` tersinkron | ✅ |

## Pelajaran

- Query yang "disiapkan tapi tidak dipakai" di kode = bug diam-diam; kalau lihat
  prepared statement tak pernah dieksekusi, kemungkinan besar field-nya memang hilang.
- Endpoint yang dipanggil frontend tapi tidak ada di backend **harus di-smoke-test
  lewat API** (dulu senyap 404 karena tak ada yang menguji).

Terkait: [[01 - Fixes/Master Rute Wilayah dan Login Region]] · [[accounts and regions]]
