# Laporan Pekerjaan: Setup Infrastruktur, Staging Deployment & Monitoring

Dokumen ini mencatat seluruh tindakan teknis yang telah dieksekusi secara langsung pada server target (`192.168.1.2`).

---

## 1. Tahap 1: Infrastruktur Server & Basis Data
- **Audit Sistem & Spesifikasi**:
  - OS: Ubuntu 26.04.1 LTS
  - CPU: Intel Core i7-8700 (12 cores)
  - RAM: 14 GB (tersedia ~13 GB)
  - Disk: 98 GB LVM (`/dev/mapper/ubuntu--vg-ubuntu--lv`), sisa 82 GB
  - IP Server: `192.168.1.2` (interface `eno1` / uplink `wlxd0374581f962`)
  - Timezone: `Asia/Jakarta (WIB, +0700)`, status NTP synchronized.
- **Konfigurasi Firewall (UFW)**:
  - Mengizinkan port `22/tcp` (SSH), `80/tcp` (HTTP), dan `443/tcp` (HTTPS).
  - Status aktif dengan default deny incoming.
- **Docker & MariaDB**:
  - Verifikasi instalasi Docker Engine `29.1.3` dan Docker Compose `2.40.3`.
  - Menginisialisasi basis data `trip_app` dan user `trip_user` pada container `mariadb_server`.
  - Migrasi skema tabel dasar: `regions`, `officers`, `tariffs`, `vehicles`, dan `trips`.
- **Sistem Backup & Uji Pemulihan (Restore)**:
  - Dibuat script otomatisasi backup di server: `/home/server/backups/backup_mariadb.sh`.
  - Pengujian backup menghasilkan arsip `trip_app_YYYYMMDD_HHMMSS.sql.gz`.
  - Uji simulasi restore basis data ke `mariadb_server` berhasil diverifikasi.

---

## 2. Tahap 3: Deployment Lingkungan Staging
- **Sinkronisasi Kode Sumber**:
  - Mentransfer kode aplikasi `/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic` ke direktori server `/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic`.
- **Perbaikan Kode Sumber**:
  - Memperbaiki `backend/src/db.js` dengan mengekspor fungsi `initialize()` (`db.initialize = initialize`) agar backend tidak crash saat boot.
- **Docker Compose Staging**:
  - Membuat `Dockerfile` untuk container API backend berbasis Node.js 20 Alpine.
  - Membuat `docker-compose.staging.yml` yang menjalankan 3 service terisolasi:
    1. `trip_staging_backend`: port `127.0.0.1:3000` (Node.js/Express)
    2. `trip_staging_admin`: port `127.0.0.1:4200` (Nginx serving admin static web)
    3. `trip_staging_mobile`: port `127.0.0.1:8100` (Nginx serving Ionic PWA/web assets)
- **Nginx Reverse Proxy & SSL/HTTPS**:
  - Membuat sertifikat SSL self-signed di `/etc/nginx/ssl/staging.crt` dan `staging.key`.
  - Mengonfigurasi Virtual Host Nginx di `/etc/nginx/sites-available/staging-trip.conf`:
    - `https://192.168.1.2/` -> Mengarah ke Frontend Ionic Mobile (`:8100`)
    - `https://192.168.1.2/admin/` -> Mengarah ke Admin Dashboard (`:4200`)
    - `https://192.168.1.2/api/` -> Mengarah ke Backend API (`:3000`)
  - Pembatasan file tersembunyi/sensitif (`.env`, `.git`) dengan respons HTTP 403.
- **UAT & Pengujian Fungsional**:
  - Endpoint `/api/health` mengembalikan status `200 OK`.
  - Endpoint `/api/auth/officers/BADAU` mengembalikan data petugas aktif.
  - Endpoint POST `/api/auth/login` berhasil mengotentikasi PIN petugas dan menerbitkan JWT token.

---

## 3. Tahap 4: Monitoring & Operasional
- **Healthcheck Script**:
  - Membuat script `/home/server/monitor_health.sh` yang memeriksa ketersediaan HTTP API, Admin, Mobile Web, status MariaDB, dan sisa hari masa aktif SSL.
- **Pekerjaan Terjadwal (Cron)**:
  - Mendaftarkan entri cron setiap 5 menit: `*/5 * * * * /home/server/monitor_health.sh >/dev/null 2>&1`.
  - Hasil log dicatat ke `/var/log/app_monitor.log`.
- **Manajemen & Rotasi Log**:
  - Membuat konfigurasi `/etc/logrotate.d/app_monitor` dengan rotasi harian (daily), kompresi gzip, dan masa simpan 14 hari.
