# Use Case Diagram

## Aktor

| Aktor | Deskripsi |
|-------|----------|
| Petugas | Petugas lapangan yang input data Angkutan |
| Supervisor | Supervisor yang monitoring dan lihat laporan |
| Admin | Admin yang manage user, tariff, region |

## Use Case Mobile App (Petugas)

### UC-001: Login
- Input PIN 6 digit
- Validasi PIN dengan Firebase Auth
- Verifikasi device ID
- Generate session token

### UC-002: Buat Trip Baru
- Pilih status muatan (Ada Muatan / Kosong)
- Jika Kosong: wajib isi keterangan + foto kondisi
- Ambil koordinat GPS
- Generate nomor trip otomatis

### UC-003: Input Kendaraan
- Input nomor polisi
- Pilih golongan, jenis kendaraan, status muatan
- Ambil foto selfie kendaraan (wajib)
- Ambil koordinat GPS saat ini (wajib)
- Sistem hitung tarif otomatis
- Simpan data kendaraan

### UC-004: Selesaikan Trip
- Validasi minimal 1 kendaraan
- Ambil koordinat GPS endpoint
- Tampilkan ringkasan trip
- Konfirmasi selesai

### UC-005: Sinkronisasi Offline
- Cek koneksi internet
- Upload data tertunda
- Handle error/retry

## Use Case Web Dashboard (Supervisor)

### UC-101: Login Dashboard
- Input email + password
- Redirect ke dashboard

### UC-102: Dashboard Monitoring
- Statistik real-time
- Grafik trip per hari
- Map dengan marker trip

### UC-103: Generate Laporan
- Pilih tipe laporan (harian/bulanan/custom)
- Pilih periode tanggal
- Generate dan export laporan

## Use Case Web Dashboard (Admin)

### UC-201: Kelola User
- Tambah user baru
- Edit data user
- Reset PIN user
- Aktif/nonaktifkan user

### UC-202: Kelola Region
- Tambah region baru
- Edit batas geolocation
- Aktif/nonaktifkan region

### UC-203: Kelola Tarif
- Tambah/edit tarif
- Set tarif per region
