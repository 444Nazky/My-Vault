# Panduan Teknis & Tutorial Implementasi (Runbook)

Panduan langkah demi langkah untuk mereplikasi konfigurasi infrastruktur, staging deployment, dan monitoring pada server Ubuntu.

---

## Persiapan: Koneksi ke Server via SSH

Jalankan perintah berikut di terminal komputer lokal untuk masuk ke server:

```bash
# Format: ssh <user>@<ip_server>
ssh server@192.168.1.2

# Jika menggunakan custom port (misal 2222)
# ssh -p 2222 server@192.168.1.2

# Jika menggunakan SSH Key
# ssh -i ~/.ssh/id_rsa server@192.168.1.2
```

---

## Tahap 1: Setup Infrastruktur & MariaDB

### 1. Konfigurasi Firewall (UFW)
Jalankan perintah berikut di server untuk mengamankan port:
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp comment 'SSH'
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'
sudo ufw enable
sudo ufw status verbose
```

### 2. Setup Basis Data MariaDB via Docker Compose
Jika belum berjalan, jalankan MariaDB di server menggunakan docker-compose:
```yaml
# /home/server/docker-mariadb/docker-compose.yml
services:
  mariadb:
    image: mariadb:11.2
    container_name: mariadb_server
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword123
      MYSQL_DATABASE: db_latihan
      MYSQL_USER: app_user
      MYSQL_PASSWORD: userpassword123
    ports:
      - "127.0.0.1:3306:3306"
    volumes:
      - mariadb_data:/var/lib/mysql

volumes:
  mariadb_data:
```

Buat database aplikasi `trip_app`:
```bash
docker exec -i mariadb_server mariadb -u root -prootpassword123 << 'EOF'
CREATE DATABASE IF NOT EXISTS trip_app CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'trip_user'@'%' IDENTIFIED BY 'TripSecret2026!';
GRANT ALL PRIVILEGES ON trip_app.* TO 'trip_user'@'%';
FLUSH PRIVILEGES;
EOF
```

### 3. Setup Backup & Uji Restore
Buat file script `/home/server/backups/backup_mariadb.sh`:
```bash
#!/bin/bash
BACKUP_DIR="/home/server/backups"
DATE=$(date +'%Y%m%d_%H%M%S')
FILE="$BACKUP_DIR/trip_app_$DATE.sql.gz"

mkdir -p "$BACKUP_DIR"
docker exec mariadb_server mariadb-dump -u root -prootpassword123 --databases trip_app | gzip > "$FILE"
find "$BACKUP_DIR" -name "trip_app_*.sql.gz" -mtime +7 -delete
echo "Backup saved: $FILE"
```
Beri hak eksekusi dan jalankan uji restore:
```bash
chmod +x /home/server/backups/backup_mariadb.sh
/home/server/backups/backup_mariadb.sh

# Uji Restore
LATEST=$(ls -t /home/server/backups/trip_app_*.sql.gz | head -n1)
gunzip -c "$LATEST" | docker exec -i mariadb_server mariadb -u root -prootpassword123 trip_app
```

---

## Tahap 3: Deployment Lingkungan Staging

### 1. Dockerfile Backend
Letakkan di `/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/backend/Dockerfile`:
```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .
EXPOSE 3000
CMD ["node", "src/index.js"]
```

### 2. Docker Compose Staging
Letakkan di `/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/docker-compose.staging.yml`:
```yaml
services:
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: trip_staging_backend
    restart: unless-stopped
    ports:
      - "127.0.0.1:3000:3000"
    environment:
      - NODE_ENV=staging
      - PORT=3000

  admin:
    image: nginx:alpine
    container_name: trip_staging_admin
    restart: unless-stopped
    volumes:
      - ./admin/src:/usr/share/nginx/html:ro
    ports:
      - "127.0.0.1:4200:80"

  mobile-web:
    image: nginx:alpine
    container_name: trip_staging_mobile
    restart: unless-stopped
    volumes:
      - ./www:/usr/share/nginx/html:ro
    ports:
      - "127.0.0.1:8100:80"
```
Jalankan stack:
```bash
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic
docker compose -f docker-compose.staging.yml up -d --build
```

### 3. Sertifikat SSL & Reverse Proxy Nginx
Buat sertifikat SSL self-signed:
```bash
sudo mkdir -p /etc/nginx/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/staging.key \
  -out /etc/nginx/ssl/staging.crt \
  -subj "/C=ID/ST=Kalbar/L=Pontianak/O=Trip/CN=staging.trip.local"
```

Konfigurasi Virtual Host `/etc/nginx/sites-available/staging-trip.conf`:
```nginx
server {
    listen 80;
    server_name staging.trip.local admin.trip.local 192.168.1.2;

    location /admin/ {
        proxy_pass http://127.0.0.1:4200/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:3000/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location / {
        proxy_pass http://127.0.0.1:8100/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location ~ /\. {
        deny all;
    }
}

server {
    listen 443 ssl;
    server_name staging.trip.local admin.trip.local 192.168.1.2;

    ssl_certificate /etc/nginx/ssl/staging.crt;
    ssl_certificate_key /etc/nginx/ssl/staging.key;

    location /admin/ {
        proxy_pass http://127.0.0.1:4200/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:3000/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location / {
        proxy_pass http://127.0.0.1:8100/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location ~ /\. {
        deny all;
    }
}
```
Aktifkan dan reload Nginx:
```bash
sudo ln -sf /etc/nginx/sites-available/staging-trip.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

## Tahap 4: Monitoring, Log Rotation & Operasional

### 1. Script Monitoring URL & Service
Buat file `/home/server/monitor_health.sh`:
```bash
#!/bin/bash
DATE=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE="/var/log/app_monitor.log"

API_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3000/api/health)
WEB_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8100/)
ADMIN_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:4200/)
DB_STATUS=$(docker exec mariadb_server mariadb-admin ping -u root -prootpassword123 2>&1 | grep -o "alive" || echo "down")
SSL_DAYS=$(openssl x509 -enddate -noout -in /etc/nginx/ssl/staging.crt | cut -d= -f2 | xargs -I{} bash -c 'echo $(( ($(date -d "{}" +%s) - $(date +%s)) / 86400 ))')

MSG="[$DATE] API:$API_STATUS | WEB:$WEB_STATUS | ADMIN:$ADMIN_STATUS | DB:$DB_STATUS | SSL_EXPIRE:${SSL_DAYS}d"
echo "$MSG" | sudo tee -a "$LOG_FILE"
```
Jadikan executable dan atur cron:
```bash
chmod +x /home/server/monitor_health.sh
(crontab -l 2>/dev/null; echo "*/5 * * * * /home/server/monitor_health.sh >/dev/null 2>&1") | crontab -
```

### 2. Rotasi Log (Logrotate)
Konfigurasikan `/etc/logrotate.d/app_monitor`:
```text
/var/log/app_monitor.log {
    su root root
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0644 root root
}
```
Uji validasi logrotate:
```bash
sudo logrotate -d /etc/logrotate.d/app_monitor
```

---

## Verifikasi & Cara Pengecekan di Server

Setelah seluruh tahapan selesai, masuk ke server melalui SSH:
```bash
ssh server@192.168.1.2
```

Jalankan perintah pengujian berikut:

### 1. Cek Firewall & Status Container
```bash
# Status Firewall
sudo ufw status verbose

# Status Container (MariaDB, Backend API, Admin, Mobile Web)
docker ps
```

### 2. Cek Basis Data MariaDB & File Backup
```bash
# Cek tabel di database trip_app
docker exec mariadb_server mariadb -u root -prootpassword123 -e "USE trip_app; SHOW TABLES;"

# Cek file backup tersimpan
ls -lh /home/server/backups/
```

### 3. Cek Akses HTTP/HTTPS (Reverse Proxy Nginx)
```bash
# Healthcheck Backend API
curl -k https://192.168.1.2/api/health

# Cek response header Admin Dashboard
curl -k -I https://192.168.1.2/admin/

# Cek response header Web Mobile Ionic
curl -k -I https://192.168.1.2/

# Uji proteksi file sensitif (harus HTTP 403 Forbidden)
curl -k -I https://192.168.1.2/.env
```

### 4. Cek Monitoring Otomatis & Rotasi Log
```bash
# Cek cron job monitoring
crontab -l

# Cek log hasil pemantauan berkala
cat /var/log/app_monitor.log
```