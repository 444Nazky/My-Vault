# Migrasi Admin Dashboard React ke CodeIgniter 2.2.4

Tanggal: 24 September 2026

## Strategi

React admin dashboard di-build menjadi static HTML/JS, lalu serve oleh CodeIgniter 2.2.4 sebagai monolith terintegrasi.

```
React Build (www/) → Static Files → CodeIgniter Controller → Browser
                                              ↓
                                     API Endpoints (JSON)
```

---

## Struktur Folder

```
admin-ci/
├── index.php              # Entry point - serve static React
├── index.html.htaccess    # Client-side routing (SPAs)
├── assets -> ../www        # Symlink ke React build
└── application/
    └── controllers/
        ├── Admin.php      # Load dashboard
        └── Api.php        # REST API dengan CORS + JSON
```

---

## File Penting

### 1. index.php
Entry point yang serve static HTML React build.

```php
<?php
$static_index = dirname(__FILE__) . '/assets/index.html';

if (file_exists($static_index)) {
    header('Content-Type: text/html; charset=utf-8');
    readfile($static_index);
    exit;
}
?>
```

### 2. index.html.htaccess
Client-side routing - semua request diarahkan ke index.html.

```apache
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.html [L]
```

### 3. Api.php Controller
REST API dengan CORS headers dan JSON responses. Compatible PHP 5.6+.

```php
class Api extends CI_Controller {

    protected function _set_cors() {
        header("Access-Control-Allow-Origin: *");
        header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
        header("Access-Control-Allow-Headers: Content-Type, Authorization");
        if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit;
    }

    protected function _json($data, $status = 200) {
        http_response_code($status);
        header('Content-Type: application/json');
        echo json_encode($data);
        exit;
    }

    protected function _verify_token() {
        $auth = isset($_SERVER['HTTP_AUTHORIZATION']) ? $_SERVER['HTTP_AUTHORIZATION'] : '';
        if (strpos($auth, 'Bearer ') === 0) {
            return substr($auth, 7) === 'YOUR_SECRET_TOKEN';
        }
        return false;
    }
}
```

### 4. Admin.php Controller
Load React static dashboard.

```php
class Admin extends CI_Controller {
    public function index() {
        $static = FCPATH . 'assets/index.html';
        if (file_exists($static)) {
            readfile($static);
        } else {
            show_404();
        }
    }
}
```

---

## API Endpoints

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/health` | Health check |
| GET | `/api/trips` | List trips |
| POST | `/api/trips` | Create trip |
| PUT | `/api/trips/:id` | Update trip |
| DELETE | `/api/trips/:id` | Delete trip |
| GET | `/api/tariffs` | List tariffs |
| POST | `/api/tariffs` | Create tariff |
| GET | `/api/officers` | List officers |

---

## Deployment Step-by-Step

### Di Local (Development)

```bash
# 1. Build React app
cd /path/to/Aplikasi-Trip-Ionic
npm run build

# 2. Copy folder admin-ci ke server
scp -r admin-ci/ server@192.168.1.2:/var/www/html/admin-ci/

# 3. Atau buat symlink (jika www/ sudah ada di server)
ssh server@192.168.1.2 "ln -s /var/www/html/www /var/www/html/admin-ci/assets"
```

### Di Server (Production)

```bash
# 1. Login ke server
ssh server@192.168.1.2

# 2. Copy project
cd /var/www/html
git clone <repo-url> Aplikasi-Trip-Ionic

# 3. Build React
cd Aplikasi-Trip-Ionic
npm install
npm run build

# 4. Copy admin-ci folder
cp -r admin-ci /var/www/html/

# 5. Symlink assets ke www build
cd /var/www/html/admin-ci
rm -rf assets
ln -s ../Aplikasi-Trip-Ionic/www assets

# 6. Set permissions
chmod -R 755 /var/www/html/admin-ci
```

### Konfigurasi Database MariaDB

Edit `application/config/database.php` (CodeIgniter):

```php
$db['default'] = array(
    'dsn'   => '',
    'hostname' => 'localhost',
    'username' => 'trip_user',
    'password' => 'TripSecret2026!',
    'database' => 'trip_app',
    'dbdriver' => 'mysqli',
    'dbprefix' => '',
    'pconnect' => FALSE,
    'db_debug' => TRUE,
    'cache_on' => FALSE,
    'cachedir' => '',
    'char_set' => 'utf8mb4',
    'dbcollat' => 'utf8mb4_unicode_ci',
    'swap_pre' => '',
    'encrypt' => FALSE,
    'compress' => FALSE,
    'stricton' => FALSE,
    'failover' => array(),
    'save_queries' => TRUE
);
```

### Konfigurasi API Token

Edit `application/controllers/Api.php`:

```php
private $api_token = 'YOUR_SECURE_TOKEN_HERE';
```

Update di React services:

```typescript
// src/services/api.ts
export const environment = {
  apiBaseUrl: 'https://your-domain.com/admin-ci/api'
};
```

### Nginx Configuration (Optional)

```nginx
server {
    listen 80;
    server_name admin.your-domain.com;
    root /var/www/html/admin-ci;
    index index.php;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api/ {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

### SSL/HTTPS

```bash
# Let's Encrypt
sudo certbot --nginx -d admin.your-domain.com
```

---

## Troubleshooting

### Error 404 di Routes

Pastikan `.htaccess` aktif:

```bash
# Enable mod_rewrite
sudo a2enmod rewrite

# Restart Apache
sudo systemctl restart apache2
```

### CORS Error di Browser

Pastikan API controller set CORS headers. Cek response header:

```bash
curl -I https://admin.your-domain.com/api/health
```

Harus ada:
```
Access-Control-Allow-Origin: *
```

### Static Files 404

Cek symlink:

```bash
ls -la admin-ci/assets/
# Harus pointing ke www/
```

### PHP Version

CodeIgniter 2.2.4 butuh PHP 5.6+. Cek versi:

```bash
php --version
```

---

## Quick Reference

```bash
# Build React
npm run build

# Deploy ke server
scp -r admin-ci/ server:/var/www/html/

# Symlink assets (jika perlu)
ln -sf ../www assets

# Test API
curl http://localhost:3000/api/health
```
