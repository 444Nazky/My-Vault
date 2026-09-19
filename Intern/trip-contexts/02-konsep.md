# Konsep Sistem Informasi Angkutan Plantation

## 1. Pendahuluan

### 1.1 Latar Belakang Masalah

Pengelolaan Angkutan di kawasan perkebunan merupakan aktivitas kritikal dalam operasional harian. Angkutan adalah kendaraan pengangkut hasil bumi yang melewati jalur-jalur tertentu di dalam area perkebunan. Selama ini, pencatatan Angkutan dilakukan secara manual dengan menggunakan buku catatan atau kertas form.

### 1.2 Permasalahan

| Masalah | Dampak |
|---------|--------|
| Ketergantungan pada kertas | Data dapat rusak, hilang, atau sulit dibaca |
| Pencatatan tidak konsisten | Setiap petugas memiliki cara pencatatan berbeda |
| Tidak ada validasi real-time | Kesalahan baru ditemukan saat pelaporan |
| Lambatnya pelaporan | Supervisor harus menunggu laporan fisik |
| Kesulitan audit | Telusuri data historis memakan waktu lama |
| Tidak ada bukti visual | Tidak ada konfirmasi foto |

### 1.3 Tantangan Area Perkebunan

- Jaringan internet tidak stabil atau tidak tersedia
- Petugas bekerja di lapangan dengan perangkat mobile
- Perlu konfirmasi visual (foto) sebagai bukti pencatatan
- Koordinat GPS menjadi要素 kritikal untuk validasi lokasi

## 2. Kajian Konsep

### 2.1 Konsep Angkutan

Angkutan adalah kendaraan pengangkut hasil panen yang beroperasi di dalam kawasan perkebunan. Setiap Angkutan memiliki:

- **Plat Nomor** - Identitas kendaraan yang unik
- **Jenis Kendaraan** - Truk, Mobil, atau Motor
- **Golongan** - Internal (milik perusahaan) atau Eksternal (kontraktor)
- **Status Muatan** - Dengan Muatan atau Tanpa Muatan
- **Tarif** - Biaya berdasarkan kombinasi faktor

### 2.2 Konsep Trip

Trip adalah satu sesi pencatatan yang dimulai saat petugas membuat pencatatan baru dan berakhir saat petugas menyelesaikan sesi tersebut.

```
Siklus Hidup Trip:
[Dimulai] --> [Aktif] --> [Kendaraan ke-1] --> [Kendaraan ke-N]
                  |              |                    |
                  v              v                    v
             [Input GPS]    [Input Foto]          [Input Foto]
                  |              |                    |
                  +--------------+--------------------+
                                 |
                                 v
                          [Konfirmasi]
                                 |
                    +------------+------------+
                    |                         |
                    v                         v
              [Lanjut]                [Selesai]
```

### 2.3 Validasi Lokasi (Geofencing)

Sistem menggunakan konsep geofencing untuk memastikan pencatatan hanya dilakukan di area yang benar. Setiap region memiliki batas koordinat (latitude/longitude) yang didefinisikan saat setup.

### 2.4 Validasi Visual (Foto)

Foto selfie menjadi bukti bahwa pencatatan dilakukan secara langsung oleh petugas dengan melihat langsung kendaraan.

## 3. Offline-First Architecture

### 3.1 Paradigma Offline-First

Offline-first adalah pendekatan desain di mana aplikasi mengasumsikan bahwa koneksi internet tidak selalu tersedia dan dirancang untuk bekerja secara optimal dalam kondisi offline.

| Aspek | Online-First | Offline-First |
|-------|--------------|---------------|
| Asumsi awal | Online | Offline |
| Data lokal | Cache | Primary storage |
| Sinkronisasi | Push to server | Pull dari server, push saat online |
| UX offline | Terbatas | Full functionality |

### 3.2 Arsitektur Offline-First

```
                    LOCAL STORAGE
                    +------------+
                    |   HIVE     |
                    | (Primary) |
                    +------+-----+
                           |
           +---------------+---------------+
           |                               |
           v                               v
    [WRITE PATH]                   [READ PATH]
    User input -->                 Local first
    Validate -->                   If miss -->
    Store local -->                Fetch from server
    Queue sync -->                 Update local
           |                               |
           +---------------+---------------+
                           |
                           v
                    SYNC TRIGGER
                    - Periodic (background)
                    - On connectivity
                    - On demand
```

### 3.3 Eventual Consistency

Sistem menggunakan konsep eventual consistency - data akan konsisten di semua tempat pada akhirnya.

## 4. Arsitektur Sistem

### 4.1 Arsitektur三层

```
+----------------------------------------------------------+
|                    PRESENTATION LAYER                       |
|  +------------------+      +---------------------------+   |
|  |  Mobile App     |      |    Web Dashboard         |   |
|  |  (Flutter)      |      |    (Vue.js)              |   |
|  +------------------+      +---------------------------+   |
+----------------------------------------------------------+
|                      BUSINESS LAYER                         |
|  +------------------+      +---------------------------+   |
|  |  Service Layer  |      |    RESTful API          |   |
|  |  - LocationSvc   |      |    /auth/*, /trips/*   |   |
|  |  - CameraSvc     |      |    /vehicles/*         |   |
|  |  - SyncSvc       |      |    /reports/*          |   |
|  +------------------+      +---------------------------+   |
+----------------------------------------------------------+
|                       DATA LAYER                           |
|  +------------------+      +---------------------------+   |
|  |  Local Storage   |      |    Remote Database       |   |
|  |  (Hive)         |      |    (PostgreSQL)        |   |
|  +------------------+      +---------------------------+   |
|  +------------------+      +---------------------------+   |
|  |  Firebase       |      |    Firebase Storage     |   |
|  |  Firestore      |      |    (Photos)            |   |
|  +------------------+      +---------------------------+   |
+----------------------------------------------------------+
```

### 4.2 Database Schema

```
users (1) -----> (N) trips
regions (1) ----> (N) users
regions (1) ----> (N) trips
trips (1) ------> (N) trip_kendaraan
tariffs (1) ----> (N) trip_kendaraan
```

### 4.3 Teknologi

| Komponen | Teknologi |
|----------|----------|
| Mobile App | Flutter (Android) |
| Backend API | Laravel / Node.js |
| Database | PostgreSQL |
| Authentication | Firebase Auth |
| Maps | Google Maps API |
| Web Dashboard | Vue.js |
| Local Storage | Hive |

## 5. Security

### 5.1 Authentication

```
Login Flow:
1. Input PIN --> Hash SHA-256
2. Kirim ke backend bersama device_id
3. Backend validasi dengan database
4. Generate Firebase Custom Token
5. Mobile sign in dengan token
6. Session aktif
```

### 5.2 Authorization Roles

| Role | Access |
|------|--------|
| Petugas | Input data via mobile |
| Supervisor | View reports, monitoring |
| Admin | Full access |

## 6. Terminologi

| Istilah | Definisi |
|---------|----------|
| **Trip** | Satu sesi pencatatan dari mulai hingga selesai |
| **Angkutan** | Kendaraan pengangkut hasil di kawasan perkebunan |
| **Geofencing** | Validasi lokasi berdasarkan batas koordinat |
| **Offline-First** | Paradigma desain dengan asumsi offline sebagai default |
| **Eventual Consistency** | Kondisi data yang konsisten pada akhirnya |
| **Background Sync** | Sinkronisasi yang berjalan di latar belakang |
