# Functional Requirements

## Mobile App (Flutter/Android)

### FR-001: Authentication
- Login dengan PIN 6 digit
- Validasi PIN dengan Firebase Auth
- Device binding validation
- Token management

### FR-002: Buat Trip Baru
- Generate nomor trip (TRP-DDMMYY-SEQ)
- Validasi GPS coordinates
- Jika Kosong: keterangan + foto kondisi wajib

### FR-003: Input Kendaraan
- Input: plat nomor, golongan, jenis, muatan
- Foto selfie wajib
- GPS coordinates wajib
- Tarif dihitung otomatis

### FR-004: Selesaikan Trip
- Minimal 1 kendaraan
- Koordinat endpoint wajib
- Tampilkan ringkasan

### FR-005: Sinkronisasi Offline
- Auto-sync saat online
- Retry dengan exponential backoff
- Conflict resolution

## Web Dashboard (Supervisor)

### FR-101: Dashboard Monitoring
- Statistik real-time
- Grafik interaktif
- Map dengan trip markers

### FR-102: Generate Laporan
- Laporan harian
- Laporan mingguan
- Laporan bulanan
- Export PDF/Excel/CSV

## Web Dashboard (Admin)

### FR-201: Kelola User
- CRUD user
- Reset PIN
- Device binding

### FR-202: Kelola Region
- CRUD region
- Set batas geolocation

### FR-203: Kelola Tarif
- CRUD tariff
- Region-specific tariffs
