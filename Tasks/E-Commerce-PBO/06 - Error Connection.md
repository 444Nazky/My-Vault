# Error: Database Connection

## Problem
```
SQLSTATE[HY000] [2002] Connection refused
```

## Cause
Database server not running or incorrect connection settings.

## Solution

### Check Database Server

#### MySQL/MariaDB
```bash
# Check if running
sudo systemctl status mysql

# Start if not running
sudo systemctl start mysql
```

#### XAMPP
```bash
# Start MySQL from XAMPP control panel
```

### Verify .env Settings
```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=ecommerce_pbo
DB_USERNAME=root
DB_PASSWORD=
```

### Test Connection
```bash
php artisan tinker
DB::connection()->getPdo();
```

## Tags
#database #troubleshooting
