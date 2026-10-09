# Gambaran Umum Alur Aplikasi Trip Angkutan

## 1. Aktivitas Mobile (Petugas Lapangan)
* **Menu & Memulai Trip**: Petugas melakukan login dan klik **Mulai Trip** di aplikasi[cite: 3].
* **Pilih Kondisi & Rute**: Pilih kondisi "Angkutan Kosong" atau "Ada Muatan" beserta rutenya[cite: 3].
* **Proses Kondisional**:
  * **Jika Angkutan Kosong (3a)**: Ambil foto kondisi angkutan kosong[cite: 3].
  * **Jika Ada Muatan (3b)**: Masuk ke form pengisian data kendaraan[cite: 3].
* **Simpan Data & Selesai Trip**: Sistem mencatat koordinat, waktu, dan nama petugas secara otomatis[cite: 3].

## 2. Alur Pengisian Data Kendaraan (Jika Ada Muatan)
* **Isi Data Kendaraan**: Petugas mengisi data kendaraan[cite: 3].
* **Simpan Data**: Menyimpan data yang telah diinput[cite: 3].
* **Validasi Kendaraan Lain**:
  * Apakah ada kendaraan lain? Jika **Ya**, ulangi proses input[cite: 3].
  * Jika **Tidak**, selesai input dan kembali ke menu awal[cite: 3].

## 3. Pelaporan Web (Administrasi)
* **Rekap per Tanggal**: Menampilkan trip dan pendapatan[cite: 3].
* **Detail per Tanggal**: Daftar lengkap kendaraan[cite: 3].
* **Rekap per Golongan**: Pengelompokan berdasarkan truck, mobil, dan motor[cite: 3].
* **Detail per Golongan**: Rincian detail harga[cite: 3].
* **Tabel Tarif**: Sebagai acuan utama[cite: 3].

---

## Detail Alur Kondisi Angkutan Kosong (Mobile)
1. **Menu Awal Mobile**: Petugas membuka aplikasi dan memilih menu awal[cite: 3].
2. **Pilih Mulai Trip**: Menekan tombol Mulai Trip[cite: 3].
3. **Kondisi Angkutan**: Memilih status "Angkutan Kosong"[cite: 3].
4. **Pilih Rute Trip**: Menentukan rute (contoh: `SJRE - SBDZ`)[cite: 3].
5. **Ambil Foto**: Mengambil foto bukti fisik kondisi angkutan kosong[cite: 3].
6. **Simpan Data & Selesai Trip**: Menyimpan data trip lengkap dengan tanggal, waktu, dan koordinat[cite: 3].

* **Catatan Validasi**:
  1. Rute perjalanan selalu `SJRE - SBDZ` (rute sebaliknya `SBDZ - SJRE` dinonaktifkan)[cite: 3].
  2. Wajib menambahkan pengisian keterangan (*mandatory*)[cite: 3].

---

## Detail Alur Kondisi Angkutan Ada Muatan (Mobile)
### Tahap 1: Inisiasi Trip & Rute
1. **Menu Awal Mobile**: Membuka aplikasi dan memilih Mulai Trip[cite: 3].
2. **Kondisi Angkutan**: Memilih status "Ada Muatan"[cite: 3].
3. **Pilih Rute Trip**: Menentukan rute perjalanan (contoh: `SBDZ - SJRE`)[cite: 3].
4. **Konfirmasi Form**: Sistem mengarahkan petugas ke Form Pengisian Data Kendaraan[cite: 3].

### Tahap 2: Pengisian Data Kendaraan
5. **Isi Data Kendaraan**: Mengisi data kendaraan, memilih golongan (Internal, Eksternal dengan Tarif, atau Eksternal tanpa Tarif), serta mengambil foto bersama seluruh kendaraan di atas angkutan[cite: 3].
6. **Simpan Data**: Sistem menyimpan data kendaraan beserta foto, koordinat, dan identitas petugas[cite: 3].
7. **Lanjut Input Kendaraan Lain?**:
   * Jika **Ya (7A)**: Form dibersihkan otomatis untuk mengulangi proses input kendaraan berikutnya[cite: 3].
   * Jika **Tidak (7B)**: Form ditutup, angkutan siap dijalankan, dan lanjut ke proses Selesai Trip[cite: 3].
8. **Kembali ke Menu Awal**: Data trip otomatis tersimpan dan masuk ke Menu List Trip serta Report Web[cite: 3].