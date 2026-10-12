 




# output trip
lakukan perbaikan di informasi trip. sebelumnya setelah kirim trip, lokasi dan kordinat akan muncul di dashboard admin di tabel Lokasi. tapi sekarang tidak muncul. 




# geofencing strict
buat geofencing jadi lebih strict, kalau gak ada di salah satu tempat atau radius kordinatnya, gabisa pilih


# redirect halaman
pastikan geofencing berjalan. dan jangan tampilkan rute sebelum geofencing berhasil mengecek titik lokasi atau kordinatnya. 

# geofencing master - halaman master rute
tambahkan setting di admin dashboard untuk mengatur titik lokasi atau kordinat seperti https://maps.app.goo.gl/1Gsfc4xo2wGbpf3k9 sekaligus mengatur semua titik lokasinya.

untuk halamannya pakai halaman master rute saja. tambahkan menu untuk atur titik lokasi kordinat di bagian edit. dalam bentuk dari url google maps seperti ini :  https://maps.app.goo.gl/1Gsfc4xo2wGbpf3k9 

# data petugas
data petugas yang baru gagal atau bahkan tidak terkirim ke mobile, menyebabkan pada saat admin menambahkan user dan password baru, tidak dapat di gunakan untuk login.

# updates
Arsitektur pembaruan aplikasi (_OTA update_) saat ini mengalami cacat fatal pada mekanisme pengelolaan _cache_ dan pengunduhan berkas, di mana sistem gagal mendeteksi pembaruan sekunder apabila struktur _chunk_ sebelumnya tidak mengalami perubahan mutlak, sehingga memaksa pengguna untuk melakukan _clear data_ secara manual di perangkat. Lebih parahnya lagi, logika pembaruan parsial atau setengah-setengah sering kali memicu galat integritas berkas di lapangan. Oleh karena itu, sistem manajemen OTA wajib dirombak secara total dengan menerapkan mekanisme unduhan paket penuh (_full-package update_) pada setiap siklus pembaruan. Setiap kali versi baru dirilis, skrip harus secara otomatis membersihkan (_auto-purge_) seluruh direktori _cache_ dan versi _bundle_ lama sebelum mengunduh dan menerapkan _full build_ yang baru. Pendekatan unduhan utuh ini dipilih demi meminimalisir celah kegagalan sinkronisasi, memastikan stabilitas absolut di sisi klien, serta menjamin bahwa pengguna dapat menerima pembaruan secara berkelanjutan tanpa hambatan teknis sekecil apa pun.

kalau masih di localhost atau debug di browser bisa hard refresh buat nampilin update terbaru, tapi kalau udah jadi versi mobile gabisa, terkadang setelah update pertama, update berikutnya selalu gagal dan tidak tampil




Rancang dan perbaiki total arsitektur OTA Update System (ota.ts, Service Worker, & Cache Engine) pada aplikasi mobile (Ionic/Capacitor) untuk menyelesaikan bug "Gagal Update Sekunder di APK Mobile Native" dengan pendekatan FULL-PACKAGE & PURGE-FIRST:

1. AKAR MASALAH YANG WAJIB DIPERBAIKI:
   - Webview Mobile Native mengagresi Cache Storage dan Filesystem, menyebabkan update sekunder (versi B ke C) gagal terdeteksi/terpanggil tanpa 'Clear Data' manual dari Setting Android.
   - Partial/Chunk update sering memicu mismatch integrity hash pada Webview mobile.

2. STRATEGI PEMBARUAN MUTLAK (PURGE-FIRST FULL DOWNLOAD):
   - Mekanisme Cek Versi: Ambil remote manifest (version.json) dengan parameter anti-cache (e.g. ?t=Date.now() & headers Cache-Control: no-cache).
   - Pembersihan Total Sebelum Unduh (Auto-Purge): Jika remote.version > local.version, JANGAN langsung download. Eksekusi fungsi resetOtaStorage() terlebih dahulu untuk menghapus SELURUH Cache Storage (caches.delete), membuang direktori OTA_DIR di Capacitor Filesystem, serta membersihkan localStorage versi lama.
   - Full Build Download: Unduh seluruh bundle/assets baru secara utuh setelah cache lama dibersihkan total.
   - Validasi & Verifikasi Integritas: Verifikasi seluruh file terunduh terhadap manifest integrity/hash. Jika ada 1 file gagal, batalkan update, purge ulang, dan kembalikan ke versi bundled default (fallback safe).
   - Aktivasi Otomatis (Atomic Reload): Setelah seluruh file terverifikasi utuh, perbarui versi aktif di storage, lalu paksa Webview untuk memuat ulang bundle baru (window.location.href / reload).

3. PENYESUAIAN PADA SERVICE WORKER & WEVIEW NATIVE:
   - Pastikan Service Worker tidak memblokir atau me-serve cache basi saat proses fetching manifest/bundle OTA baru berlangsung.
   - Sediakan fungsi pembersihan manual/fallback 'Reset App Cache' di UI UpdateNotifier untuk memfasilitasi jika terjadi network timeout di lapangan.

4. TARGET TESTING & VERIFIKASI:
   - Lakukan pengujian simulasi rilis beruntun di APK Mobile: V1.0.0 -> V1.0.1 (Update Pertama) -> V1.0.2 (Update Kedua tanpa clear data manual).
   - Pastikan V1.0.2 langsung terdeteksi, mengunduh bersih, dan tampil sempurna di layar mobile tanpa ada sisa chunk V1.0.1.







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










