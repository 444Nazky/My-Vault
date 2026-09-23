# Data Flow Diagram

## Level 0 (Context Diagram)

```
                    ┌─────────────┐
                    │   Petugas   │
                    │  (Mobile)   │
                    └──────┬──────┘
                           │
                           │ Data Angkutan, Login PIN
                           ▼
                    ┌─────────────┐
                    │             │
         ┌─────────│  Sistem     │─────────┐
         │         │  Informasi  │         │
         │         │  Angkutan   │         │
         └─────────│             │─────────┘
                   └──────┬──────┘
                          │
         ┌────────────────┼────────────────┐
         │                │                │
         ▼                ▼                ▼
  ┌───────────┐   ┌───────────┐   ┌───────────┐
  │ Supervisor│   │  Database │   │   Admin   │
  │  (Web)   │   │   Server  │   │  (Web)   │
  └───────────┘   └───────────┘   └───────────┘
```

## Level 1 Processes

### Proses 1: Login Mobile
```
Input: PIN 6 digit
Output: Token autentikasi
- Validasi PIN dengan Firebase Auth
- Cek device ID binding
- Generate session token
```

### Proses 2: Input Angkutan
```
Input: Data kendaraan + foto + GPS
Output: Trip record
- Generate nomor trip
- Simpan foto ke storage
- Validasi koordinat GPS
- Hitung tarif otomatis
- Sync ke server (online) / simpan offline
```

### Proses 3: Sinkronisasi Data
```
Input: Data offline
Output: Data tersinkron
- Cek koneksi internet
- Upload data tertunda
- Handle konflik
```

### Proses 4: Monitoring Dashboard
```
Input: Data trip
Output: Laporan & statistik
- Aggregate data per periode
- Generate grafik
- Export laporan
```

## Data Store

| ID | Nama | Deskripsi |
|----|------|----------|
| D1 | USER | Data petugas |
| D2 | REGION | Data region |
| D3 | TARIFF | Master tarif |
| D4 | TRIP | Header trip |
| D5 | TRIP_KENDARAAN | Detail kendaraan |
| D6 | SYNC_QUEUE | Data offline pending |
