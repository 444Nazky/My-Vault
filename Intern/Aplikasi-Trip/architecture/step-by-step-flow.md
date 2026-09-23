# Step-by-Step Data Flow: Dari Mobile ke Admin Dashboard

Dokumen ini menjelaskan alur data lengkap dari input petugas lapangan di mobile hingga data terlihat di dashboard admin.

---

## Overview Sistem

```mermaid
graph LR
    subgraph Mobile["MOBILE (Ionic)"]
        M1[Login PIN]
        M2[Input Trip]
        M3[Input Kendaraan]
        M4[Sync]
    end

    subgraph Local["LOCAL STORAGE"]
        SQLite[(SQLite)]
    end

    subgraph Backend["BACKEND API"]
        API[REST API]
    end

    subgraph Database["DATABASE"]
        PG[(PostgreSQL)]
        FB[(Firebase)]
    end

    subgraph Web["WEB DASHBOARD"]
        W1[Dashboard]
        W2[Admin Panel]
    end

    M1 --> SQLite
    M2 --> SQLite
    M3 --> SQLite
    M4 --> API
    API --> PG
    API --> FB
    W1 --> API
    W2 --> API
```

---

## Fase 1: Admin Setup Master Data

### 1.1 Admin Membuat Region

```mermaid
sequenceDiagram
    participant Admin as Admin Web
    participant API as Backend API
    participant DB as PostgreSQL

    Admin->>API: POST /admin/regions<br/>{nama: "Badau", kode: "BADAU", bounds: {...}}
    API->>DB: INSERT regions
    DB-->>API: region created
    API-->>Admin: 201 Created
```

### 1.2 Admin Membuat Tarif

```mermaid
sequenceDiagram
    participant Admin as Admin Web
    participant API as Backend API
    participant DB as PostgreSQL

    Admin->>API: POST /admin/tariffs<br/>{golongan: "Eksternal", jenis: "Truk", tarif: 120000}
    API->>DB: INSERT tariffs
    DB-->>API: tariff created
    API-->>Admin: 201 Created
```

### 1.3 Admin Membuat User Petugas

```mermaid
sequenceDiagram
    participant Admin as Admin Web
    participant API as Backend API
    participant FB as Firebase Auth
    participant DB as PostgreSQL

    Admin->>API: POST /admin/users<br/>{nama: "Budi", pin: "123456", region_id: 1}
    API->>FB: Create user
    API->>DB: INSERT users<br/>pin_hash, region_id
    API-->>Admin: 201 Created
```

---

## Fase 2: Petugas Login Mobile

```mermaid
sequenceDiagram
    participant Mobile as Mobile Ionic
    participant Storage as Ionic Storage
    participant API as Backend API
    participant FB as Firebase Auth

    Mobile->>Mobile: App launched
    Mobile->>Storage: Check token
    Storage-->>Mobile: token exists?

    alt Token Ada
        Mobile->>API: Validate token
        API-->>Mobile: Token valid
        Mobile->>Storage: Load tariffs
        Mobile->>Home: Navigate to Home
    else Token Tidak Ada
        Mobile->>Mobile: Show Login Screen
    end
```

### Input PIN Login

```mermaid
sequenceDiagram
    participant User as Petugas
    participant Mobile as Mobile Ionic
    participant API as Backend API
    participant FB as Firebase Auth
    participant Storage as Ionic Storage

    User->>Mobile: Input PIN "123456"
    Mobile->>Mobile: Hash PIN SHA-256
    Mobile->>API: POST /auth/login<br/>{pin_hash, device_id}
    API->>API: Validate PIN di DB
    API->>FB: Generate Firebase token
    FB-->>API: token
    API-->>Mobile: {token, user, tariffs, region}
    Mobile->>Storage: Save token + tariffs
    Mobile->>Home: Navigate to Home
    User->>Mobile: Dashboard tampil
```

---

## Fase 3: Membuat Trip Baru

```mermaid
flowchart TD
    A[Mulai Buat Trip] --> B{Pilih Status}
    B -->|Ada Muatan| C[Ambil GPS Start]
    B -->|Kosong| D[Wajib: Keterangan]
    D --> E[Wajib: Foto Kondisi]
    E --> C
    C --> F[Generate No Trip]
    F --> G[TRP-120524-001]
    G --> H[Simpan ke SQLite]
    H --> I[Aktif]
```

### Detail Input Trip

```mermaid
sequenceDiagram
    participant User as Petugas
    participant Mobile as Mobile Ionic
    participant GPS as Geolocation
    participant Storage as Ionic Storage

    User->>Mobile: Pilih status muatan
    User->>Mobile: (opsional) Input keterangan
    User->>Mobile: (opsional) Ambil foto kondisi
    User->>GPS: getCurrentPosition()
    GPS-->>Mobile: {lat, lng}
    Mobile->>Mobile: Validate geofencing
    Mobile->>Mobile: Generate no_trip: TRP-120524-001
    Mobile->>Storage: INSERT trip draft
    Mobile->>User: Navigate ke Input Kendaraan
```

---

## Fase 4: Input Kendaraan

```mermaid
flowchart LR
    subgraph Input["Input Kendaraan"]
        A[Plat Nomor] --> B[Golongan]
        B --> C[Jenis]
        C --> D[Status Muatan]
        D --> E[Foto Selfie]
        E --> F[Ambil GPS]
    end

    subgraph Proses["Proses Otomatis"]
        F --> G[Hitung Tarif]
        G --> H[Simpan SQLite]
        H --> I[Dialog Sukses]
    end
```

### Detail Input Kendaraan

```mermaid
sequenceDiagram
    participant User as Petugas
    participant Mobile as Mobile Ionic
    participant Camera as Camera Plugin
    participant GPS as Geolocation
    participant Storage as Ionic Storage
    participant Tariffs as Tariffs Cache

    User->>Mobile: Input plat "B 1234 ABC"
    User->>Mobile: Pilih golongan "Eksternal"
    User->>Mobile: Pilih jenis "Truk"
    User->>Mobile: Pilih muatan "Dengan Muatan"
    User->>Camera: Capture selfie photo
    Camera-->>Mobile: file:///tmp/photo.jpg
    User->>GPS: getCurrentPosition()
    GPS-->>Mobile: {lat, lng}
    Mobile->>Tariffs: Cari tarif matching
    Tariffs-->>Mobile: tarif: 120000
    Mobile->>Storage: UPDATE trip<br/>ADD vehicle
    Storage-->>Mobile: saved
    Mobile->>User: Dialog sukses
    User->>Mobile: "Ya, lanjut" / "Tidak, selesai"
```

---

## Fase 5: Penyelesaian Trip

```mermaid
sequenceDiagram
    participant User as Petugas
    participant Mobile as Mobile Ionic
    participant GPS as Geolocation
    participant Storage as Ionic Storage

    User->>Mobile: Tekan "Selesai"
    Mobile->>Mobile: Validasi min 1 kendaraan
    alt Valid
        Mobile->>GPS: getCurrentPosition
        GPS-->>Mobile: {lat, lng}
        Mobile->>Storage: UPDATE trip<br/>status: completed<br/>end_lat, end_lng
        Storage-->>Mobile: saved
        Mobile->>User: Tampilkan ringkasan
        User->>Mobile: Konfirmasi selesai
        Mobile->>User: Kembali ke Home
    else Tidak valid
        Mobile->>User: Error: min 1 kendaraan
    end
```

---

## Fase 6: Sinkronisasi Data

```mermaid
flowchart TD
    A[Trip dibuat offline] --> B[Device Online]
    B --> C{Sync Trigger}
    C -->|Periodic 15min| D[Sync Queue]
    C -->|Network Change| D
    C -->|Manual| D
    D --> E[Upload Foto ke Firebase]
    E --> F[POST /trips ke API]
    F --> G[Store ke PostgreSQL]
    G --> H[Mark as Synced]
    H --> I[Remove from Queue]
    F -->|Error| J[Increment Retry]
    J -->|5x failed| K[Mark Failed]
```

### Detail Sync Process

```mermaid
sequenceDiagram
    participant Mobile as Mobile Ionic
    participant Network as Network Detection
    participant API as Backend API
    participant FB as Firebase Storage
    participant Storage as Ionic Storage
    participant DB as PostgreSQL

    Network-->>Mobile: Online detected
    Mobile->>Storage: GET pending_trips
    Storage-->>Mobile: [trip TRP-120524-001]

    loop Setiap Trip
        Mobile->>Mobile: Upload photos
        Mobile->>FB: POST photo.jpg
        FB-->>Mobile: url: "https://..."
        Mobile->>API: POST /trips
        Note over Mobile,API: Body: trip + vehicle + foto_url
        API->>DB: INSERT trip + vehicles
        DB-->>API: created
        API-->>Mobile: 201 Created
        Mobile->>Storage: SET is_synced = true
    end

    Mobile->>Mobile: Show notification
    Mobile->>User: "Data berhasil disinkronkan"
```

---

## Fase 7: Supervisor Dashboard

```mermaid
sequenceDiagram
    participant Supervisor as Supervisor
    participant Web as Web Dashboard
    participant API as Backend API
    participant DB as PostgreSQL

    Supervisor->>Web: Buka dashboard
    Web->>API: GET /reports/summary
    API->>DB: SELECT trips + vehicles
    DB-->>API: aggregated stats
    API-->>Web: {total_trips: 125, revenue: 38.6jt}
    Web->>Supervisor: Tampilkan cards + charts

    Supervisor->>Web: Filter tanggal
    Web->>API: GET /trips?date=...
    API-->>Web: trip list
    Web->>Supervisor: Tampilkan table

    Supervisor->>Web: Export PDF
    Web->>API: GET /reports/export?format=pdf
    API-->>Web: PDF blob
    Web->>Supervisor: Download file
```

---

## Fase 8: Admin Kelola Data

```mermaid
flowchart LR
    subgraph CRUD["CRUD Operations"]
        A[Users] -->|Create| B[POST /admin/users]
        A -->|Read| C[GET /admin/users]
        A -->|Update| D[PUT /admin/users/1]
        A -->|Delete| E[DELETE /admin/users/1]
    end

    subgraph Targets["Target Tables"]
        B --> F[Firebase Auth + PostgreSQL]
        C --> G[PostgreSQL]
        D --> H[PostgreSQL]
    end
```

---

## Timeline Contoh

```mermaid
gantt
    title Timeline Contoh操作
    dateFormat HH:mm
    section Mobile
    Login petugas           :08:00, 5m
    Buat trip TRP-120524-001 :08:15, 3m
    Input kendaraan 1       :08:18, 2m
    Input kendaraan 2       :08:20, 2m
    Selesaikan trip        :08:25, 1m
    Sync data (offline)    :08:26, 30s
    section Dashboard
    Supervisor login      :15:00, 2m
    Lihat statistics      :15:02, 3m
```

---

## Ringkasan Alur

```
PETAKS HANDLER:
Mobile App                    Backend                    Database
    |                           |                          |
1. LOGIN                      |                          |
   PIN ──────> API ──────> Firebase Auth                |
                    <──── Token + Tariffs ──── Ionic Storage

2. BUAT TRIP                 |                          |
   Form + GPS ──> Ionic Storage ──> draft_trip
                          |                          |
3. INPUT KENDARAAN            |                          |
   Plat + Foto ──> Ionic Storage ──> trip + vehicles
                          |                          |
4. SELESAI                   |                          |
   Konfirmasi ──> Ionic Storage ──> status: completed
                          |                          |
5. SYNC (saat online)        |                          |
   Queue ───────────────> API ──────────────────────> PostgreSQL
                          | Firebase Storage <─────── Upload foto
                          |                          |
6. DASHBOARD                 |                          |
   GET /summary ─────────────────────────> PostgreSQL
                    <────────────────── Stats + Charts

7. ADMIN CRUD                 |                          |
   PUT /tariffs/1 ───────────────────────────────> PostgreSQL
```

---

## Error Handling

| Fase | Error | Handling |
|------|-------|----------|
| Login | PIN salah | Tampilkan "PIN salah" |
| Login | Device mismatch | Tampilkan "Device tidak terdaftar" |
| GPS | Unavailable | Warning + allow proceed |
| GPS | Outside region | Warning + proceed option |
| Sync | Network timeout | Retry dengan backoff |
| Sync | 5x failed | Mark failed + notify user |
| Dashboard | API error | Error state + retry button |
