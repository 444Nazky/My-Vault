





# updates
terdaapat error/bug di setelah update, karena jika pengguna menarik update kedua tidak ada perubahan, jadi user harus clear data dulu baru bisa update ke versi terbaru. aplikasi hanya bisa update sekali, pada update kedua terjadi error karena tidak ada perubahan. mohon untuk di setting setelah update versi, versi lama di hapus. dan untuk versi chunk buat jadi versi yang dapat di lihat manusia seperti 1.0.1 atau 1.0.2 bukan 1920938


# double pic
Bertindaklah sebagai Senior Frontend Developer untuk merombak total halaman _Ringkasan Trip_ di aplikasi _mobile_ agar menghapus mutlak elemen kartu swafoto penutup yang masih muncul ganda atau redundan, sehingga hanya tersisa tepat satu komponen kartu interaktif yang dinamis—berubah menjadi status hijau dengan pratinjau foto setelah diambil dan mengaktifkan tombol _'Kirim Saja'_ menuju halaman trip selesai tanpa ada sisa elemen DOM yang bertumpuk.



### **Pembersihan Total UI Trip Kosong (Hapus Detail Kendaraan & Slot Foto Kosong Redundan)**

> "Bertindaklah sebagai Senior Frontend & UI/UX Developer. Lakukan perbaikan logika render secara tuntas pada komponen halaman detail riwayat dan ringkasan trip (_Trip Detail / History Screen_) di aplikasi _mobile_ Ionic/React pada direktori `/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic` dengan instruksi mutlak berikut:
> 
> 1. **Sembunyikan Total Bagian Kendaraan untuk Trip Kosong:** Jika kondisi trip bernilai **'Kosong'**, pastikan blok komponen atau kartu yang bertuliskan _"Detail Kendaraan"_ beserta seluruh elemen turunannya **tidak dirender sama sekali** dari DOM. Trip kosong murni hanya mencatat rute, waktu, dan bukti foto kondisi kapal.
>     
> 2. **Hapus Slot Placeholder Foto Redundan:** Pada bagian _Foto Dokumentasi_, hapus mutlak kotak placeholder atau kotak kosong berlabel angka ganjil seperti `-1 — BELUM ADA FOTO`.
>     
> 3. **Tampilkan Foto Bukti Tunggal Secara Bersih:** Pastikan hanya foto bukti valid kondisi kapal kosong yang benar-benar ada isinya saja yang dirender secara rapi dan proporsional tanpa ada kotak kosong sisa _looping_ array yang rusak."
>


















# Revisi (aktif)
lokasi kode = /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic


setelah trip berhasil diisi, hilangkan "belum ada foto di trip kosong". serta hilangkan detail kendaraan juga, karena ini trip kosong. intinya kalau trip kosong hanya muncul bukti foto kalau memang benar2 kosong kapalnya, tidak ada kendaraan

hilangkan informasi internet online / offline di detail trip yang sudah terkirim, karena fitur ini sudah ada sebelumnya di bagian kanan atas

hilangkan fitur scan plat di halaman input kendaraan

# 1
Tolong rancang, perbaiki, dan implementasikan arsitektur logika aplikasi mobile Trip Angkutan agar beroperasi secara dominan offline-first berdasarkan alur kerja dan validasi berikut:

1. **Inisialisasi & Tarik Data Awal (Kondisi: Online):**
   - Saat perangkat terhubung ke internet, aplikasi wajib menarik seluruh data master (pengguna, dermaga, rute, dan konfigurasi) dari Web Admin ke penyimpanan lokal perangkat (IndexedDB/SQLite/LocalStorage)[cite: 9].

2. **Autentikasi Pengguna (Kondisi: Offline):**
   - Proses Login & Pass divalidasi secara lokal dengan mencocokkan *scope* akses (Dermaga dan Rute) yang sudah tersimpan di penyimpanan lokal perangkat[cite: 9].

3. **Alur Trip - Muatan Kosong (Kondisi: Offline):**
   - Validasi geofencing dan penyesuaian rute dilakukan secara offline[cite: 9].
   - Hapus durasi, wajib mengambil foto bukti, lalu lakukan *submit* (selesai) tanpa perlu memicu proses *end trip* yang rumit secara langsung[cite: 9].

4. **Alur Trip - Ada Muatan (Kondisi: Offline):**
   - Validasi geofencing dan rute berjalan secara lokal[cite: 9].
   - Input data kendaraan, ambil foto bukti, dan sediakan opsi pengulangan (looping) input data kendaraan beserta foto jika diperlukan[cite: 9].
   - Setelah semua selesai, wajib melakukan swafoto (*selfie* wajib), baru kemudian jalankan fungsi *End Trip* secara lokal[cite: 9].

5. **Manajemen Riwayat / History (Kondisi: Offline):**
   - Tampilkan data riwayat trip dari basis data lokal (pastikan penanganan state data trip yang belum tampil sepenuhnya dapat dimuat dengan benar dari cache lokal)[cite: 9].

6. **Sinkronisasi Akhir (Kondisi: Online):**
   - Saat koneksi internet kembali aktif (*Online*), jalankan sinkronisasi dua arah: mengambil perubahan data master terbaru dari web serta mengunggah (*upload*) seluruh antrean data lokal mobile ke web admin[cite: 9].










