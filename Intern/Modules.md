# Dokumentasi Lengkap Alur Aplikasi Trip Angkutan

## 1. Aktivitas Mobile (Petugas Lapangan)

- **Menu & Memulai Trip**: Petugas melakukan _login_ ke aplikasi dan menekan tombol **Mulai Trip** untuk memulai pencatatan perjalanan baru.
    
      
    
- **Pilih Kondisi & Rute**: Memilih status kondisi angkutan (**Angkutan Kosong** atau **Ada Muatan**) beserta rute perjalanan yang sesuai.
    
      
    
- **Proses Kondisional**:
    
      
    - _Jika Angkutan Kosong_: Petugas wajib mengambil foto bukti fisik kondisi angkutan yang kosong. Berdasarkan validasi sistem, rute perjalanan dikunci secara default ke `SJRE - SBDZ` (sementara `SBDZ - SJRE` dinonaktifkan) dan wajib mengisi keterangan tambahan.
        
          
        
    - _Jika Ada Muatan_: Sistem mengonfirmasi pilihan dan mengarahkan petugas masuk ke Form Pengisian Data Kendaraan.
        
          
        
- **Simpan & Selesai Trip**: Sistem secara otomatis mencatat koordinat lokasi, waktu pengerjaan, serta nama petugas yang bertugas.
    
      
    

## 2. Alur Pengisian Data Kendaraan (Jika Ada Muatan)

- **Isi Data Kendaraan**: Petugas menginput data kendaraan, memilih golongan (Internal, Eksternal dengan Tarif, atau Eksternal tanpa Tarif), serta mengambil foto _selfie_ bersama seluruh kendaraan di atas angkutan.
    
      
    
- **Simpan Data**: Sistem menyimpan data kendaraan beserta foto, koordinat, dan identitas petugas.
    
      
    
- **Pemeriksaan Kendaraan Lain**:
    
      
    - _Jika Ya_: Form data kendaraan akan dibersihkan secara otomatis, lalu petugas mengulangi proses input untuk kendaraan berikutnya.
        
          
        
    - _Jika Tidak_: Proses input selesai, form ditutup, dan angkutan siap dijalankan. Data trip otomatis tersimpan dan masuk ke _Menu List Trip_ serta _Report Web_.
        
          
        

## 3. Pelaporan Web (Administrasi)

Pusat data dan analisis mendalam bagi admin untuk memantau operasional perusahaan, mencakup:

  

- **Rekap per Tanggal**: Memuat ringkasan trip dan total pendapatan harian.
    
      
    
- **Detail per Tanggal**: Menampilkan daftar lengkap kendaraan yang beroperasi setiap harinya.
    
      
    
- **Rekap per Golongan**: Pengelompokan data berdasarkan jenis kendaraan seperti _Truck_, _Mobil_, dan _Motor_.
    
      
    
- **Detail per Golongan**: Rincian nominal harga dan tarif.
    
      
    
- **Tabel Tarif**: Digunakan sebagai acuan resmi perusahaan.
    
      
    

_(Membuang muka ke samping dengan gaya songong)_ _Nah, tuh udah komplit dari A sampai Z. Gak ada alasan buat malas-malesan rapihin catatan lagi. Sana beresin kodingannya, jangan bikin aku ngomel-ngomel mulu!_