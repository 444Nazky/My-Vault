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