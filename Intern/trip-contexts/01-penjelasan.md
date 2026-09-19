# Sistem Informasi Angkutan Plantation - Penjelasan Lengkap

## Gambaran Umum Proyek

Proyek yang saya kerjakan adalah Sistem Informasi Angkutan Plantation, yaitu aplikasi digital untuk mencatat kendaraan Angkutan di kawasan perkebunan. Selama ini pencatatan dilakukan secara manual dengan buku catatan, dan tujuan proyek ini adalah mendigitalisasi proses tersebut.

Angkutan sendiri adalah kendaraan pengangkut hasil bumi yang melewati jalur-jalur tertentu di dalam kawasan perkebunan. Setiap kendaraan yang lewat harus dicatat informasinya seperti plat nomor, jenis kendaraan, golongan, status muatan, dilengkapi dengan foto dan lokasi GPS.

## Masalah yang Dihadapi

Ada beberapa permasalahan dengan cara pencatatan manual yang lama. Pertama, ketergantungan pada kertas membuat data mudah rusak atau hilang. Kedua, setiap petugas memiliki cara pencatatan yang berbeda sehingga data tidak konsisten. Ketiga, kesalahan baru ketahuan saat pelaporan, tidak ada validasi real-time. Keempat, laporan membutuhkan waktu berhari-hari karena harus menunggu laporan fisik dari petugas. Kelima, tidak ada kontrol siapa yang mengubah data. Dan yang terakhir, tidak ada bukti visual yang memperkuat pencatatan.

Selain permasalahan umum tersebut, kawasan perkebunan memiliki tantangan khusus yaitu sinyal internet yang tidak stabil di beberapa area, petugas bekerja bergerak di lapangan, dan membutuhkan konfirmasi visual berupa foto untuk setiap pencatatan.

## Solusi yang Ditawarkan

Untuk mengatasi masalah-masalah tersebut, saya membangun sistem yang terdiri dari tiga komponen utama. Komponen pertama adalah aplikasi mobile untuk petugas lapangan menggunakan Flutter. Komponen kedua adalah RESTful API sebagai backend service. Komponen ketiga adalah web dashboard untuk supervisor dan admin menggunakan Vue.js.

## Arsitektur Sistem

Secara arsitektur, sistem ini menggunakan pendekatan tiga layer. Layer presentasi terdiri dari mobile app dan web dashboard. Layer business terdiri dari service layer dan REST API. Layer data terdiri dari local storage menggunakan Hive di mobile dan PostgreSQL di server, serta Firebase untuk autentikasi dan penyimpanan file.

Yang unik dari sistem ini adalah desain offline-first, artinya aplikasi dirancang untuk bekerja optimal saat offline. Data disimpan terlebih dahulu di penyimpanan lokal perangkat, kemudian disinkronkan ke server saat koneksi tersedia. Ini penting sekali karena kawasan perkebunan memang memiliki masalah konektivitas.

## Aplikasi Mobile

Aplikasi mobile yang saya bangun menggunakan Flutter untuk Android. Berikut alur kerjanya.

### Login

Petugas membuka aplikasi dan memasukkan PIN 6 digit. PIN di-hash dengan SHA-256, lalu dikirim ke backend bersama dengan ID perangkat. Backend memvalidasi PIN dan device ID, kemudian mengembalikan Firebase token jika valid. Token disimpan di perangkat dan dipakai untuk session.

### Membuat Trip Baru

Trip adalah satu sesi pencatatan yang dimulai saat petugas membuat pencatatan baru dan berakhir saat petugas menyelesaikan sesi tersebut. Saat membuat trip, petugas memilih status muatan, apakah Ada Muatan atau Kosong. Jika Kosong, wajib mengisi keterangan dan foto kondisi kosong sebagai bukti.

Petugas juga harus memastikan lokasi GPS-nya valid. Sistem mengambil koordinat GPS saat itu dan memvalidasi apakah koordinat tersebut berada dalam batas region yang sudah ditentukan. Ini yang disebut geofencing, yaitu validasi lokasi berdasarkan batas koordinat.

Setelah itu, sistem secara otomatis membuat nomor trip dengan format TRP-DDMMYY-SEQ, misalnya TRP-120524-001 yang berarti Trip tanggal 12 Mei 2024, urutan pertama pada hari itu.

### Input Kendaraan

Setelah trip dibuat, petugas dapat mulai memasukkan kendaraan. Untuk setiap kendaraan, input yang diperlukan adalah plat nomor, golongan apakah Internal atau Eksternal, jenis kendaraan apakah Truk Mobil atau Motor, status muatan, foto selfie kendaraan, dan lokasi GPS saat itu juga.

Foto selfie ini wajib karena menjadi bukti bahwa pencatatan dilakukan oleh petugas yang melihat langsung kendaraan tersebut. Setelah foto diambil, sistem juga mengambil koordinat GPS saat itu untuk memastikan lokasi input valid.

Tarif dihitung secara otomatis oleh sistem berdasarkan kombinasi golongan, jenis kendaraan, dan status muatan. Misalnya Truk Eksternal Dengan Muatan mungkin dikenakan Rp120.000, sementara Mobil Eksternal Tanpa Muatan Rp60.000. Sistem mencari tarif ini dari tabel master tariff yang sudah ditentukan oleh admin.

### Penyelesaian Trip

Setelah selesai memasukkan semua kendaraan, petugas menekan tombol selesai. Sistem memvalidasi bahwa minimal ada satu kendaraan yang diinput, mengambil koordinat endpoint, menampilkan ringkasan trip, dan menunggu konfirmasi. Setelah dikonfirmasi, trip ditandai sebagai selesai dan siap disinkronkan.

## Konsep Offline-First

Ini adalah bagian paling penting dari sistem ini. Offline-first berarti aplikasi dirancang untuk bekerja optimal saat offline, bukan sebaliknya.

### Penyimpanan Lokal

Aplikasi menggunakan Hive, yaitu database lokal yang ringan dan cepat untuk Flutter. Setiap data yang diinput petugas langsung disimpan ke Hive. Data ditandai dengan status isSynced, jika false berarti belum dikirim ke server.

### Sinkronisasi

Sinkronisasi terjadi dalam beberapa kondisi. Pertama secara otomatis setiap 15 menit jika perangkat online. Kedua saat koneksi internet terdeteksi kembali. Ketiga secara manual oleh petugas jika diinginkan.

Proses sinkronisasinya adalah aplikasi mengambil data dari queue, mengupload foto terlebih dahulu, kemudian mengirim data JSON ke API, dan jika berhasil, menghapus data dari queue lokal. Jika gagal, akan dilakukan retry dengan exponential backoff, yaitu penundaan yang semakin lama setiap kali gagal. Maksimal 5 kali retry, setelah itu ditandai sebagai gagal dan butuh intervensi manual.

### Conflict Resolution

Jika data yang sama diedit di beberapa tempat, sistem menggunakan strategi eventual consistency. Untuk data trip header, server menang karena mungkin supervisor sudah mengakses. Untuk data kendaraan, digunakan last-write-wins karena tidak ada konflik logis. Untuk master data seperti tariff, server adalah satu-satunya sumber kebenaran.

## Keamanan

Sistem keamanan terdiri dari beberapa lapisan. Untuk autentikasi, menggunakan PIN 6 digit yang di-hash dengan SHA-256. PIN tidak pernah disimpan dalam bentuk plain text. Token memiliki masa berlaku 7 hari dan bisa di-refresh secara otomatis.

Setiap user juga dikunci ke satu perangkat tertentu berdasarkan device ID. Jika petugas mencoba login dari perangkat lain, sistem akan menolak. Untuk mengubah perangkat, harus melalui admin yang akan mereset device binding.

Dari sisi authorization, terdapat tiga role. Petugas hanya bisa input data melalui mobile app. Supervisor bisa melihat laporan dan monitoring melalui web dashboard. Admin memiliki akses penuh termasuk manajemen user dan tariff.

Untuk keamanan data, semua komunikasi menggunakan HTTPS. Input data di-sanitize untuk mencegah SQL injection dan XSS. Rate limiting diterapkan yaitu maksimal 100 request per menit per user.

## Web Dashboard

Web dashboard dibangun untuk supervisor dan admin menggunakan Vue.js. Berikut fitur-fitur utamanya.

### Dashboard Monitoring

Halaman utama menampilkan statistik real-time yaitu total trip, total kendaraan, total pendapatan, dan jumlah data yang belum tersinkron. Terdapat juga grafik trip per hari untuk melihat tren, peta dengan marker lokasi trip menggunakan Google Maps, dan daftar trip terbaru.

### Laporan

Supervisor dapat membuat laporan dengan memilih periode tanggal dan filter seperti region atau golongan. Sistem memproses data dan menampilkan ringkasan. Laporan bisa di-export ke format PDF, Excel, atau CSV sesuai kebutuhan.

### Manajemen

Admin dapat mengelola user yaitu menambah, mengedit, mereset PIN, dan mengaktifkan atau menonaktifkan. Admin juga dapat mengatur tariff untuk setiap kombinasi golongan dan jenis kendaraan, bahkan bisa berbeda per region. Selain itu admin bisa mengatur region dengan batas-batas geografisnya.

## Teknologi yang Digunakan

Untuk mobile app, saya menggunakan Flutter karena bisa membuat satu codebase untuk Android dengan performa native. State management menggunakan Provider karena sederhana dan intuitif. Local storage menggunakan Hive yang ringan dan cepat. Location service menggunakan Geolocator untuk akses GPS, dan Workmanager untuk sinkronisasi di background.

Untuk backend, menggunakan Laravel atau Node.js dengan PostgreSQL sebagai database. Autentikasi menggunakan Firebase Auth untuk infrastruktur yang robust, dan Firebase Storage untuk menyimpan foto.

Untuk web dashboard, menggunakan Vue.js 3 karena learning curve-nya rendah dan dokumentasinya lengkap. Styling dengan Tailwind CSS untuk pengembangan cepat, dan Chart.js untuk visualisasi data.

## Alur Kerja Pengembangan

Proyek ini menggunakan metodologi Waterfall dengan durasi sekitar 14 minggu atau satu semester. Tahapannya adalah pengumpulan kebutuhan selama 2 minggu, desain selama 2 minggu, implementasi selama 6 minggu, pengujian selama 2 minggu, dan deployment serta pemeliharaan selama 2 minggu.

## Hasil yang Dicapai

Hasil yang diharapkan dari proyek ini adalah aplikasi mobile yang berfungsi lengkap untuk input data di lapangan, kemampuan offline yang memungkinkan petugas tetap produktif tanpa internet, sinkronisasi otomatis yang menjamin data tersimpan di server, web dashboard untuk monitoring dan pelaporan, serta dokumentasi lengkap meliputi spesifikasi kebutuhan, diagram use case, ERD, dan DFD.

## Manfaat Proyek

Manfaat bagi perusahaan adalah data yang akurat dan konsisten, pelaporan lebih cepat karena real-time, kemudahan audit karena semua data tersimpan digital, dan pengambilan keputusan berbasis data.

Manfaat bagi petugas adalah proses pencatatan lebih cepat karena langsung input via HP, tidak tergantung koneksi internet karena bisa offline, dan pengurangan kesalahan pencatatan karena ada validasi otomatis.

Manfaat bagi supervisor adalah akses ke data real-time melalui dashboard, kemampuan membuat laporan dalam berbagai format, dan visualisasi data yang jelas melalui grafik dan peta.

## Ringkasan

Jadi intinya, proyek ini membangun sistem digital end-to-end untuk mencatat kendaraan Angkutan di perkebunan dengan pendekatan offline-first. Petugas lapangan menggunakan aplikasi mobile untuk input data dilengkapi foto dan GPS, data disimpan lokal dan disinkronkan saat online, supervisor dapat monitoring melalui web dashboard, dan admin dapat mengelola master data. Sistem ini mengatasi masalah pencatatan manual dan memungkinkan operasional yang lebih efisien bahkan di area dengan konektivitas terbatas.
