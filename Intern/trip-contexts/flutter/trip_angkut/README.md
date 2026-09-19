# Trip Angkut - Flutter Mobile App

Sistem Informasi Angkutan Plantation - Aplikasi mobile untuk mencatat kendaraan angkutan di kawasan perkebunan dengan dukungan **offline-first**.

## 🚀 Fitur Utama

### 1. **Autentikasi PIN**
- Login dengan PIN 6 digit
- Hash SHA-256 untuk keamanan
- Device binding (satu perangkat per user)
- Firebase Auth integration

### 2. **Manajemen Trip**
- Buat trip baru dengan status muatan (Ada Muatan/Kosong)
- Generate nomor trip otomatis (TRP-DDMMYY-SEQ)
- Validasi GPS lokasi (geofencing)
- Selesaikan trip dengan ringkasan

### 3. **Input Kendaraan**
- Input plat nomor, golongan, jenis kendaraan
- Foto selfie kendaraan (wajib)
- GPS lokasi otomatis
- Perhitungan tarif otomatis

### 4. **Offline-First**
- Data tersimpan lokal dengan Hive
- Sinkronisasi otomatis saat online
- Retry dengan exponential backoff
- Background sync dengan Workmanager

## 📁 Struktur Proyek

```
lib/
├── main.dart                          # Entry point
├── core/
│   ├── constants/
│   │   ├── app_constants.dart         # App-wide constants
│   │   └── api_constants.dart         # API endpoints
│   ├── services/
│   │   ├── location_service.dart      # GPS & geofencing
│   │   ├── camera_service.dart        # Photo capture
│   │   ├── storage_service.dart       # Hive local storage
│   │   ├── auth_service.dart          # Firebase auth
│   │   ├── connectivity_service.dart  # Network status
│   │   └── sync_service.dart         # Background sync
│   └── utils/
│       ├── pin_hash.dart              # PIN hashing
│       └── trip_number_generator.dart # Trip number generation
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── trip_model.dart
│   │   ├── vehicle_model.dart
│   │   ├── tariff_model.dart
│   │   ├── region_model.dart
│   │   └── adapters.dart             # Hive adapters
│   └── repositories/
│       ├── auth_repository.dart
│       ├── trip_repository.dart
│       └── tariff_repository.dart
├── features/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── auth_provider.dart
│   ├── trip/
│   │   ├── home_screen.dart
│   │   ├── create_trip_screen.dart
│   │   ├── trip_history_screen.dart
│   │   ├── trip_detail_screen.dart
│   │   └── trip_provider.dart
│   └── vehicle/
│       ├── input_vehicle_screen.dart
│       ├── vehicle_provider.dart
│       └── trip_summary_screen.dart
└── widgets/
    ├── loading_indicator.dart
    ├── offline_indicator.dart
    └── trip_card.dart
```

## 🛠️ Teknologi

| Komponen | Teknologi |
|----------|-----------|
| Framework | Flutter 3.x |
| State Management | Provider |
| Local Storage | Hive |
| Authentication | Firebase Auth |
| Location | Geolocator |
| Camera | Image Picker |
| Background Sync | Workmanager |
| Network | Dio |

## 📋 Persyaratan

- Flutter SDK >= 3.2.0
- Dart SDK >= 3.2.0
- Android SDK (minSdkVersion 21)
- Firebase project setup

## 🚀 Setup

### 1. Clone Repository
```bash
git clone <repository-url>
cd trip_angkut
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Hive Adapters
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Firebase Setup
```bash
flutterfire configure
```

### 5. Run Aplikasi
```bash
flutter run
```

## 🔧 Konfigurasi

### Environment Variables
Buat file `.env` di root project:
```
API_BASE_URL=https://api.tripangkut.com/v1
FIREBASE_API_KEY=your_api_key
```

### Android Setup
Pastikan `android/app/build.gradle` memiliki:
```gradle
minSdkVersion 21
```

## 📱 Alur Aplikasi

### Login
1. Buka aplikasi
2. Masukkan PIN 6 digit
3. Sistem hash PIN dengan SHA-256
4. Kirim ke backend untuk validasi
5. Dapatkan Firebase token
6. Simpan token untuk session

### Buat Trip
1. Tekan "Buat Trip Baru"
2. Pilih status muatan
3. Jika Kosong: isi keterangan + foto
4. Sistem ambil lokasi GPS
5. Generate nomor trip otomatis
6. Simpan ke local storage

### Input Kendaraan
1. Pada trip aktif, tekan "Tambah Kendaraan"
2. Isi plat nomor kendaraan
3. Pilih golongan, jenis, status muatan
4. Ambil foto selfie kendaraan
5. Lokasi GPS otomatis terambil
6. Tarif dihitung otomatis
7. Simpan data

### Sinkronisasi
- **Otomatis**: Setiap 15 menit jika online
- **Manual**: Tekan tombol sync
- **On-connectivity**: Saat koneksi tersedia

## 🐛 Troubleshooting

### GPS Tidak Aktif
- Pastikan layanan lokasi aktif di perangkat
- Berikan izin lokasi ke aplikasi

### Foto Tidak Bisa Diambil
- Pastikan izin kamera diberikan
- Cek ruang penyimpanan perangkat

### Sync Gagal
- Cek koneksi internet
- Data akan retry otomatis
- Maksimal 5 kali retry

## 📄 Dokumentasi

Lihat dokumentasi lengkap di folder `trip-contexts/`:
- `01-penjelasan.md` - Penjelasan lengkap proyek
- `02-konsep.md` - Konsep dan arsitektur
- `flutter/` - Dokumentasi Flutter

## 👥 Tim

- **Mobile Development**: Flutter
- **Backend**: Laravel/Node.js
- **Web Dashboard**: Vue.js

## 📝 Lisensi

Proprietary - Untuk penggunaan internal