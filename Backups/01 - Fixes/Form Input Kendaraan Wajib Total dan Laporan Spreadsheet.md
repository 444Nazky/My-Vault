# Fix — Form Input Kendaraan Wajib Total & Laporan ala Spreadsheet

> **Tanggal:** 28 September 2026
> **File:** `src/pages/mobile/VehicleFormScreen.tsx` · `src/pages/admin/AdminDashboard.tsx`

## 1. Input Kendaraan: minimalis + semua field wajib

### Sebelumnya
Empat kartu terpisah berborder (foto, plat, jenis, kategori) dengan grid tombol —
terasa ramai. Kategori & jenis memang sudah ada, tapi tidak ada penanda progres
dan label "opsional/tidak" tiap field tidak konsisten.

### Sesudahnya
- **Satu kartu** dengan baris-baris dipisah garis tipis (`divide-y`) — tanpa
  kotak bertumpuk. Foto jadi baris pratinjau (thumbnail + "Ulangi"), plat satu
  baris dengan tombol **Scan** inline, jenis & kategori berupa **`<select>`**
  dengan placeholder `Pilih jenis kendaraan` / `Pilih kategori`.
- **Penanda progres `N/4`** di header — tiap field terisi bertambah.
- **Tombol simpan terkunci** sampai 4/4, dengan alasan dinamis
  ("Ambil Foto Dahulu" → "Isi Nomor Plat" → "Pilih Jenis Kendaraan" →
  "Pilih Kategori" → "Simpan Kendaraan").
- **Guard keras di `pushVehicle()`**: `if (!isFormComplete) return false` —
  tombol modal "Lanjut Trip" / "Tambah Lagi" juga tidak bisa menyisipkan data
  kosong, jadi tidak ada kendaraan tersimpan dengan field terlewat.
- Kategori & jenis **bukan opsional**: select placeholder = nilai kosong tak
  diterima `isFormComplete`.

### Verifikasi E2E (Chromium)
```
0/4 → isi plat 1/4 → pilih jenis 2/4 (kategori masih kosong → terkunci)
    → pilih kategori 3/4 (foto belum → terkunci)
    → jepret kamera 4/4 → tombol "Simpan Kendaraan" aktif
    → modal → "Tambah Lagi" → form reset 0/4, tersimpan (1), terkunci lagi
Grid tombol lama: 0 · select wajib: 2
```

## 2. Laporan Trip: tampilan spreadsheet modern

### Sebelumnya
Daftar kartu accordion per trip — padat tapi bukan tabel, kolom sulit dipindai,
tidak ada baris total.

### Sesudahnya
Tabel sungguhan dengan gaya spreadsheet modern:
- **Header kolom tetap** (`# · No Trip · Tanggal · Jam · Tempat/Wilayah · Rute ·
  Petugas · Muatan · Unit · Pendapatan`) — `sticky`, uppercase, abu.
- **Baris zebra + garis grid tipis**, angka rata kanan `tabular-nums`,
  badge muatan tetap.
- **Expand per baris** → detail jadi baris `colSpan={11}` berlatar `slate-50`
  (info tempat/rute/tanggal/kategori/petugas + tabel kendaraan).
- **Baris total di `tfoot`**: `Total N trip · N unit` + total pendapatan.
- **Filter Golongan & Jenis Kendaraan TETAP di atas** (permintaan dipertahankan),
  diikuti tombol Reset + hitungan trip.

### Verifikasi E2E (Chromium, `:8000`)
```
headers : ['#','No Trip','Tanggal','Jam','Tempat / Wilayah','Rute','Petugas','Muatan','Unit','Pendapatan']
rows    : 17 · tfoot: "Total 17 trip · 33 unit · Rp 5.880.000"
filter  : ada di ATAS tabel (filtersAbove: true)
expand  : baris detail colSpan=11 + "Tempat:" ✓
filter golongan I : 21 baris → 6 baris (server-side) ✓
```

## Kualitas
`npx tsc --noEmit` 0 error · `ng lint` pass · `ng build` sukses ·
`www/` → `admin-ci/` tersinkron (`main-FBS25PNS.js`).

## Catatan terkait
Uji sempat menampilkan UI lama karena **`ng serve` masih berjalan dari folder
trash** — lihat [[Dev Server Masih Berjalan dari Folder Terhapus]].
