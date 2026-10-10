
# geofencing
Rancang dan implementasikan fitur validasi geofencing berbasis koordinat GPS secara ketat di sisi klien (_mobile application_) dengan batasan radius maksimal 100 meter dari titik lokasi rute yang telah ditentukan. Sebagai contoh implementasi awal untuk wilayah pengujian _Badau Dermaga 1_, sistem wajib mendeteksi posisi GPS pengguna secara _real-time_: apabila pengguna berada di titik koordinat area Rute 2 (`-6.1891005, 106.8371641`), aplikasi harus mengunci pilihan rute hanya pada trayek SJRE ke SBDZ dan melarang keras penginputan atau pengiriman formulir (_submit_) untuk rute lain. Sebaliknya, jika pengguna terdeteksi berada di area Rute 1 (`-6.2389899548617285, 106.97475839406252`), sistem hanya mengizinkan pengiriman formulir untuk trayek SBDZ ke SJRE dengan validasi mutlak tanpa kompromi. Selain itu, integrasikan modul pengaturan kustomisasi koordinat titik lokasi (_geofencing configuration_) ke dalam panel _Admin Dashboard_, sehingga supervisor memiliki hak akses penuh untuk menambah, mengubah, atau mengatur titik koordinat dan radius wilayah validasi secara dinamis tanpa perlu mengubah kode sumber secara manual.




# geofencing
// geofencing based on location coordinates, for example: if the user is within a certain radius of a specific location,
// the app can trigger certain actions or notifications. This can be useful for location-based services, such as sending alerts when a user enters or leaves a designated area.
// if the user is not on the specified area for example route 1. the userr cannot submit the form. and the only route exist is the one that on his current location. for example
// if the user was on the route2 or https://www.google.com/maps?q=-6.1891005,106.8371641. he can only submit the form on that route, SJRE -> SBDZ. he cant input another route while on his current lcoation

// and if the user was on the route1 https://www.google.com/maps?q=-6.2389899548617285,106.97475839406252. the user only can input on the route1 or SBDZ -> SJRE.
// and cannot submit the form on the route2 or https://www.google.com/maps?q=-6.1891005,106.8371641. he can only submit the form on that route, SBDZ -> SJRE.
// he cant input another route while on his current locaation.

for the maximum range is 100m. and make sure to make it strict


# data petugas
data petugas yang baru gagal atau bahkan tidak terkirim ke mobile, menyebabkan pada saat admin menambahkan user dan password baru, tidak dapat di gunakan untuk login.

# updates
Arsitektur pembaruan aplikasi (_OTA update_) saat ini mengalami cacat fatal pada mekanisme pengelolaan _cache_ dan pengunduhan berkas, di mana sistem gagal mendeteksi pembaruan sekunder apabila struktur _chunk_ sebelumnya tidak mengalami perubahan mutlak, sehingga memaksa pengguna untuk melakukan _clear data_ secara manual di perangkat. Lebih parahnya lagi, logika pembaruan parsial atau setengah-setengah sering kali memicu galat integritas berkas di lapangan. Oleh karena itu, sistem manajemen OTA wajib dirombak secara total dengan menerapkan mekanisme unduhan paket penuh (_full-package update_) pada setiap siklus pembaruan. Setiap kali versi baru dirilis, skrip harus secara otomatis membersihkan (_auto-purge_) seluruh direktori _cache_ dan versi _bundle_ lama sebelum mengunduh dan menerapkan _full build_ yang baru. Pendekatan unduhan utuh ini dipilih demi meminimalisir celah kegagalan sinkronisasi, memastikan stabilitas absolut di sisi klien, serta menjamin bahwa pengguna dapat menerima pembaruan secara berkelanjutan tanpa hambatan teknis sekecil apa pun.




# double pic
swafoto masih double. jadi setelah foto pertama malah di suruh ambil foto lagi sebelum submit/kirim trip. tolong perbaiki dan ubah hanya menjadi sekali foto saja. teks pertama yang muncul adalah foto bukti trip belum diambil, setelah berhasil foto muncul lagi dengan tulisan swafoto penutup belum diambil


# halaman settings
lakukan improvisasi halaman settings jangan terlalu banyak warna, sesuaikan tema dengan aplikasinya. untuk saat ini masih terlalu polos, tanpa gradient, kemudian tombol cek pembaruan tidak berfungsi

# scan
hilangkan tombol scan di samping nomor plat pada halaman inpuit kendaraan. kemudian pada halaman riwayat trip. serta hilangkan status koneksi "terhubung ke server" karena fitur itu sudah ada di kanan atas.



https://www.google.com/maps?q=-6.1891005,106.8371641


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










