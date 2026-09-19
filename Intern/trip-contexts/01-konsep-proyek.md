# Konsep Sistem Informasi Angkutan Plantation

## 1. Pendahuluan

### 1.1 Latar Belakang Masalah

Pengelolaan Angkutan di kawasan perkebunan merupakan aktivitas kritikal dalam operasional harian. Angkutan adalah kendaraan pengangkut hasil bumi yang melewati jalur-jalur tertentu di dalam area perkebunan. Selama ini, pencatatan Angkutan dilakukan secara manual dengan menggunakan buku catatan atau kertas form.

Pendekatan manual ini menimbulkan beberapa permasalahan fundamental:

**Permasalahan Pencatatan Manual:**

| Masalah | Dampak |
|---------|--------|
| Ketergantungan pada kertas | Data dapat rusak, hilang, atau sulit dibaca |
| Pencatatan tidak konsisten | Setiap petugas memiliki cara pencatatan berbeda |
| Tidak ada validasi real-time | Kesalahan baru ditemukan saat pelaporan |
| Lambatnya pelaporan | Supervisor harus menunggu laporan fisik |
| Kesulitan audit | Telusuri data historis memakan waktu lama |
| Tidak ada kontrol akses | Siapa pun dapat mengubah catatan |

**Permasalahan Spesifik Lokasi:**

Kawasan perkebunan memiliki karakteristik unik yang memperumit implementasi sistem digital:

- Jaringan internet tidak stabil atau tidak tersedia di beberapa area
- Petugas bekerja di lapangan dengan perangkat mobile
- Perlu konfirmasi visual (foto) sebagai bukti pencatatan
- Koordinat GPS menjadi要素 kritikal untuk validasi lokasi
- Kebutuhan sinkronisasi data saat perangkat kembali ke area dengan koneksi

### 1.2 Tujuan Proyek

Berdasarkan permasalahan di atas, proyek ini bertujuan untuk:

1. **Mendigitalisasi** proses pencatatan Angkutan dari manual ke sistem terintegerasi
2. **Mempermudah** petugas lapangan dalam mencatat data dengan antarmuka yang intuitif
3. **Menjamin akurasi** data melalui validasi otomatis (GPS, foto, tarif)
4. **Memastikan ketersediaan** data even saat offline
5. **Mempercepat pelaporan** dengan sinkronisasi real-time
6. **Memberikan visualisasi** data bagi supervisor melalui dashboard

### 1.3 Ruang Lingkup

Sistem ini dirancang untuk ekosistem perkebunan dengan komponen sebagai berikut:

```
                    +-------------------+
                    |   Mobile App     |
                    |   (Petugas)      |
                    +--------+----------+
                             |
                    +--------v----------+
                    |     Web API      |
                    +--------+----------+
                             |
              +---------------+---------------+
              |                               |
    +---------v---------+         +---------v---------+
    |   Web Dashboard  |         |   Database       |
    |   (Supervisor/   |         |   Server        |
    |    Admin)        |         +-----------------+
    +-----------------+
```

**Komponen Sistem:**

1. **Mobile Application** - Aplikasi Android untuk petugas lapangan
2. **RESTful API** - Backend service untuk komunikasi data
3. **Web Dashboard** - Antarmuka web untuk supervisor dan admin
4. **Database Server** - Penyimpanan data terpusat

---

## 2. Kajian Konsep

### 2.1 Konsep Angkutan

#### 2.1.1 Definisi Angkutan

Angkutan dalam konteks ini merujuk pada kendaraan pengangkut hasil panen yang beroperasi di dalam kawasan perkebunan. Setiap Angkutan memiliki karakteristik:

- **Plat Nomor** - Identitas kendaraan yang unik
- **Jenis Kendaraan** - Truk, Mobil, atau Motor
- **Golongan** - Internal (milik perusahaan) atau Eksternal (milik kontraktor)
- **Status Muatan** - Dengan Muatan (ada barang) atau Tanpa Muatan (kosong)
- **Tarif** - Biaya yang dikenakan berdasarkan kombinasi faktor di atas

#### 2.1.2 Konteks Operasional

```
Area Perbatasan
+----------------------------------------------------------+
|                                                          |
|    [Region A]          [Region B]          [Region C]   |
|    Badau               Sanggau              Sejiang       |
|                                                          |
|    +---------+            +---------+                      |
|    |Gerbang |----------->|Gerbang |-----------> Outlet   |
|    |Masuk   |            |Keluar  |                     |
|    +---------+            +---------+                     |
|         |                     |                           |
|         v                     v                           |
|    [Titik             [Titik                             |
|     Entry GPS]         Exit GPS]                          |
|                                                          |
+----------------------------------------------------------+
```

Petugas mencatat setiap Angkutan yang masuk dan keluar melalui titik-titik gerbang yang telah ditentukan. Satu perjalanan dari gerbang masuk ke gerbang keluar disebut sebagai **Trip**.

### 2.2 Konsep Trip

#### 2.2.1 Definisi Trip

Trip adalah satu sesi pencatatan yang dimulai saat petugas membuat pencatatan baru dan berakhir saat petugas menyelesaikan sesi tersebut. Dalam satu trip:

- Did记录 semua Angkutan yang melewati
- Setiap Angkutan memiliki detail lengkap (plat, jenis, golongan, muatan)
- Koordinat GPS titik awal dan akhir dicatat
- Foto selfie menjadi bukti visual

#### 2.2.2 Siklus Hidup Trip

```
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
              (Input kendaraan         (Trip ditutup,
               berikutnya)              sync ke server)
```

### 2.3 Konsep Validasi

#### 2.3.1 Validasi Lokasi (Geofencing)

Sistem menggunakan konsep geofencing untuk memastikan pencatatan hanya dilakukan di area yang benar:

```
    Batas Region
    +--------------------+
    |                    |
    |    AREA VALID     |
    |                    |
    |   +----------+     |
    |   | Titik   |-----> Jika GPS di dalam, valid
    |   | Input   |     |
    |   +----------+     |
    |                    |
    +--------------------+
           |
           +-------------> Jika GPS di luar, peringatan
```

Setiap region memiliki batas koordinat (latitude/longitude) yang didefinisikan saat setup. Aplikasi memvalidasi bahwa koordinat GPS saat input berada dalam batas region.

#### 2.3.2 Validasi Visual (Foto)

Foto selfie menjadi bukti bahwa pencatatan dilakukan secara langsung oleh petugas dengan melihat langsung kendaraan:

```
Validasi Foto:
1. File exists (foto diambil)
2. Format valid (JPEG/PNG)
3. Ukuran sesuai (< 10MB)
4. EXIF metadata ada (waktu pengambilan)
5. Koordinat dalam foto match dengan GPS device
```

### 2.4 Konsep Offline-First

#### 2.4.1 Paradigma Offline-First

Offline-first adalah pendekatan desain di mana aplikasi mengasumsikan bahwa koneksi internet tidak selalu tersedia dan dirancang untuk bekerja secara optimal dalam kondisi offline.

**Perbandingan:**

| Aspek | Online-First | Offline-First |
|-------|--------------|---------------|
| Asumsi awal | Online | Offline |
| Data lokal | Cache | Primary storage |
| Sinkronisasi | Push to server | Pull dari server, push saat online |
| Konflik | Server wins | Context-dependent |
| UX offline | Terbatas | Full functionality |

#### 2.4.2 Arsitektur Offline-First

```
                    LOCAL STORAGE
                    +------------+
                    |   HIVE     |
                    | (Primary)  |
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
                           |
                           v
                    SERVER STORAGE
```

### 2.5 Konsep Sinkronisasi

#### 2.5.1 Eventual Consistency

Sistem menggunakan konsep eventual consistency - data akan konsisten di semua tempat pada akhirnya, meskipun mungkin ada delay singkat saat offline:

```
Timeline:
T0: User input di mobile (offline)
    -> Local: Trip A, Vehicle 1 (status: pending)

T1: User input lagi (offline)
    -> Local: Trip A, Vehicle 1, 2 (status: pending)

T2: Koneksi tersedia, sync dimulai
    -> Server: Trip A, Vehicle 1 (status: synced)

T3: Sync selesai
    -> Server: Trip A, Vehicle 1, 2 (status: synced)
    -> Local: status updated to synced
```

#### 2.5.2 Conflict Resolution

Ketika data yang sama diedit di beberapa tempat, strategi resolusi konflik diterapkan:

| Data Type | Strategy | Alasan |
|-----------|----------|---------|
| Trip header | Server wins | Supervisor mungkin sudah akses |
| Vehicle data | Last-write-wins | Tidak ada konflik logis |
| User settings | Client wins | Preferensi lokal |
| Master data (tarif) | Server wins | Single source of truth |

### 2.6 Konsep Keamanan

#### 2.6.1 Authentication

Sistem menggunakan PIN 6 digit untuk autentikasi mobile app dengan pertimbangan:

- Petugas lapangan membutuhkan cara cepat untuk login
- PIN mudah diingat dan cepat diinput
- Device binding mencegah akses dari perangkat lain
- Firebase Auth menyediakan infrastruktur yang robust

```
Login Flow:
1. Input PIN --> Hash SHA-256
2. Kirim ke backend bersama device_id
3. Backend validasi dengan database
4. Generate Firebase Custom Token
5. Mobile sign in dengan token
6. Session aktif
```

#### 2.6.2 Authorization

Multi-level authorization berdasarkan peran:

```
                    +------------------+
                    |     ADMIN        |
                    |  (Full Access)  |
                    +--------+---------+
                             |
              +--------------+--------------+
              |                             |
    +---------v---------+         +---------v---------+
    |   SUPERVISOR      |         |     PETUGAS      |
    | (Read + Report)   |         |   (Input Only)  |
    +-------------------+         +------------------+
```

---

## 3. Arsitektur Sistem

### 3.1 Arsitektur三层

```
+----------------------------------------------------------+
|                    PRESENTATION LAYER                       |
|  +------------------+      +---------------------------+   |
|  |  Mobile App     |      |    Web Dashboard         |   |
|  |  (Flutter)      |      |    (Vue.js/React)        |   |
|  +------------------+      +---------------------------+   |
+----------------------------------------------------------+
|                      BUSINESS LAYER                        |
|  +------------------+      +---------------------------+   |
|  |  Service Layer  |      |    RESTful API           |   |
|  |  - LocationSvc  |      |    - /auth/*            |   |
|  |  - CameraSvc    |      |    - /trips/*           |   |
|  |  - SyncSvc      |      |    - /vehicles/*        |   |
|  |  - StorageSvc   |      |    - /reports/*        |   |
|  +------------------+      +---------------------------+   |
+----------------------------------------------------------+
|                       DATA LAYER                           |
|  +------------------+      +---------------------------+   |
|  |  Local Storage   |      |    Remote Database       |   |
|  |  (Hive)         |      |    (PostgreSQL)          |   |
|  +------------------+      +---------------------------+   |
|  +------------------+      +---------------------------+   |
|  |  Firebase       |      |    Firebase Storage      |   |
|  |  Firestore      |      |    (Photos)              |   |
|  +------------------+      +---------------------------+   |
+----------------------------------------------------------+
```

### 3.2 Arsitektur Data

```
                    POSTGRESQL
              +-------------------+
              |     users         |
              |     regions       |
              |     tariffs       |
              |     trips         |
              |  trip_kendaraan   |
              +-------------------+
                        ^
                        | Replication
                        |
+-----------------------|---------------------+
|                       |                     |
v                       v                     v
+------------+   +------------+   +----------------+
|   HIVE     |   | FIREBASE  |   | FIREBASE      |
| (Mobile)   |   | FIRESTORE  |   | STORAGE       |
|            |   | (Backup)  |   | (Photos)      |
+------------+   +------------+   +----------------+
```

### 3.3 Arsitektur Komunikasi

```
Mobile App                          Backend API
     |                                   |
     | ---- Login (PIN + device_id) ----> |
     | <--- Token + User Data ----------- |
     |                                   |
     | ---- Create Trip ----------------> |
     | <--- Trip Confirmation ----------- |
     |                                   |
     | ---- Add Vehicle (multipart) ----> |
     |    - Data fields                 |
     |    - Photo file                  |
     | <--- Vehicle Created ------------ |
     |                                   |
     | [Offline: Queue locally]           |
     | [When online: Batch sync]         |
```

---

## 4. Alur Kerja Sistem

### 4.1 Alur Petugas Lapangan

```
                    MULAI
                      |
                      v
            +-------------------+
            |    BUKA APP       |
            +-------------------+
                      |
                      v
            +-------------------+
            |    LOGIN PIN      |
            |    6 Digit       |
            +-------------------+
                      |
            +---------+---------+
            |                     |
            v                     v
      [PIN VALID]          [PIN INVALID]
            |                     |
            v                     v
      [LOAD DASHBOARD]    [SHOW ERROR]
            |                     |
            v                     v
      +----+----+             +
      |         |             |
      v         v             |
 [BUAT    [RIWAYAT]         |
  TRIP]    TRIP              |
   |          |               |
   +---+------+               |
       |                      |
       v                      |
  +-----------+               |
  | PILIH     |               |
  | STATUS    |               |
  | MUATAN   |               |
  +-----------+               |
       |                      |
  +----+----+                 |
  |         |                 |
  v         v                 |
[KOSONG] [ADA                 |
  |    MUATAN]                |
  |      |                    |
  v      |                    |
+--------+                    |
|WAJIB   |                    |
|KETERANG|                    |
|AN+FOTO |                    |
+--------+                    |
       |                      |
       v                      |
+------------------------+    |
|AMBIL KOORDINAT GPS    |    |
+------------------------+    |
       |                      |
       v                      |
+-------------------+        |
|  TRIP HEADER     |        |
|  TERSIMPAN       |        |
+-------------------+        |
       |                      |
       v                      |
+------------------------+    |
|   INPUT KENDARAAN    |    |
|   - Plat Nomor       |    |
|   - Golongan         |    |
|   - Jenis            |    |
|   - Status Muatan    |    |
|   - Foto Selfie      |    |
|   - GPS Koordinat    |    |
+------------------------+    |
       |                      |
       v                      |
+-------------------+        |
|  SIMPAN & SYNC   |        |
|  (atau QUEUE     |        |
|   jika offline)  |        |
+-------------------+        |
       |                      |
       v                      |
+------------------------+    |
|   DIALOG KONFIRMASI  |    |
|   "Lanjut/Selesai"  |    |
+------------------------+    |
       |                      |
  +----+----+                 |
  |         |                 |
  v         v                 |
[LANGKUT] [SELESAI]          |
   |          |               |
   |          v               |
   |   +---------------+      |
   |   | UPDATE STATUS |      |
   |   | TRIP=COMPLETE|      |
   |   +---------------+      |
   |          |              |
   |          v              |
   |   +---------------+      |
   +->|  KEMBALI HOME |      |
      +---------------+      |
```

### 4.2 Alur Sinkronisasi

```
                DETEKSI KONEKTIVITAS
                         |
            +------------+------------+
            |                         |
            v                         v
       [ONLINE]                  [OFFLINE]
            |                         |
            v                         |
    +------------------+             |
    |CEK SYNC QUEUE   |             |
    +------------------+             |
            |                         |
    +-------+-------+               |
    |               |               |
    v               v               |
[ADA DATA]     [TIDAK ADA]         |
  PENDING        DATA              |
    |               |               |
    v               v               |
+------------------+               |
|AMBIL DATA DARI |               |
|QUEUE (FIFO)   |               |
+------------------+               |
          |                        |
          v                        |
    +------------------+          |
    | UPLOAD KE SERVER |          |
    | - API Call       |          |
    | - Upload Photo   |          |
    +------------------+          |
          |                        |
    +-----+-----+                 |
    |           |                 |
    v           v                 |
[SUCCESS]   [FAILED]              |
    |           |                 |
    v           v                 |
[UPDATE     [INCREMENT           |
 STATUS]     RETRY COUNT]         |
    |           |                 |
    v           v                 |
[REMOVE FROM   |                 |
 QUEUE]        |                 |
    |           v                 |
    |    +-----------+           |
    +--->|RETRY LATER|<---------+
         |(EXPONENTIAL|
         | BACKOFF)  |
         +-----------+
```

---

## 5. Teknologi yang Digunakan

### 5.1 Mobile Application

| Teknologi | Fungsi | Alasan Pemilihan |
|-----------|--------|-----------------|
| Flutter | Cross-platform framework | Single codebase untuk Android |
| Provider | State management | Sederhana dan intuitif |
| Hive | Local database | Fast, lightweight, offline-first |
| Geolocator | Location services | Reliable GPS access |
| Image Picker | Camera access | Mudah digunakan |
| Workmanager | Background tasks | Sinkronisasi otomatis |

### 5.2 Backend

| Teknologi | Fungsi | Alasan Pemilihan |
|-----------|--------|-----------------|
| Laravel | PHP Framework | Robust, banyak fitur built-in |
| PostgreSQL | Database | Relational yang kuat |
| Firebase Auth | Authentication | Managed service, secure |
| Firebase Storage | File storage | Scalable, CDN integration |

### 5.3 Web Dashboard

| Teknologi | Fungsi | Alasan Pemilihan |
|-----------|--------|-----------------|
| Vue.js 3 | Frontend framework | Reactive, component-based |
| Tailwind CSS | Styling | Utility-first, cepat |
| Chart.js | Data visualization | Easy to use, customizable |
| Google Maps | Map display | Industry standard |

---

## 6. Hasil dan Manfaat

### 6.1 Hasil yang Diharapkan

| Hasil | Indikator Keberhasilan |
|-------|----------------------|
| Aplikasi Mobile | Petugas dapat input data dengan mudah |
| Web Dashboard | Supervisor dapat melihat laporan real-time |
| Offline Capability | Sistem tetap bekerja tanpa internet |
| Data Accuracy | 100% data tervalidasi dengan GPS dan foto |
| Reporting | Laporan tersedia dalam berbagai format |

### 6.2 Manfaat Sistem

**Bagi Perusahaan:**
- Data yang akurat dan konsisten
- Pelaporan lebih cepat
- Kemudahan audit dan monitoring
- Pengambilan keputusan berbasis data

**Bagi Petugas:**
- Proses pencatatan lebih cepat
- Tidak tergantung koneksi internet
- Antarmuka yang intuitif
- Pengurangan kesalahan pencatatan

**Bagi Supervisor:**
- Akses real-time ke data
- Laporan otomatis
- Visualisasi data yang jelas
- Kemampuan analisis tren

### 6.3 Inovasi Proyek

Beberapa aspek inovatif dari proyek ini:

1. **Offline-First Architecture** - Sistem dirancang untuk bekerja di area dengan konektivitas terbatas
2. **Geofencing Validation** - Validasi otomatis berdasarkan lokasi GPS
3. **Visual Proof System** - Foto selfie sebagai bukti pencatatan
4. **Background Sync** - Sinkronisasi otomatis tanpa interupsi pengguna
5. **Multi-Role Dashboard** - Dashboard berbeda untuk supervisor dan admin

---

## 7. Kesimpulan

Sistem Informasi Angkutan Plantation merupakan solusi digital yang mengatasi berbagai permasalahan dalam pencatatan Angkutan manual. Dengan pendekatan offline-first, sistem ini memungkinkan petugas lapangan untuk tetap produktif meskipun di area dengan koneksi internet terbatas.

Arsitektur yang modular dan penggunaan teknologi modern seperti Flutter dan Firebase memberikan fondasi yang solid untuk pengembangan dan pemeliharaan sistem di masa depan. Hasil akhir proyek ini diharapkan dapat meningkatkan efisiensi operasional perkebunan melalui digitalisasi yang komprehensif.

---

## Lampiran: Terminologi

| Istilah | Definisi |
|---------|----------|
| **Trip** | Satu sesi pencatatan dari mulai hingga selesai |
| **Angkutan** | Kendaraan pengangkut hasil di kawasan perkebunan |
| **Geofencing** | Validasi lokasi berdasarkan batas koordinat |
| **Offline-First** | Paradigma desain dengan asumsi offline sebagai default |
| **Eventual Consistency** | Kondisi data yang konsisten pada akhirnya |
| **Background Sync** | Sinkronisasi yang berjalan di latar belakang |
| **Firebase Custom Token** | Token autentikasi yang dibuat di backend untuk Firebase |
| **Pin Hash** | Hasil hash SHA-256 dari PIN pengguna |
| **Device Binding** | Pengikatan akun ke perangkat tertentu |
