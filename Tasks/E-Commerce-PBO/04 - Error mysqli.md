# Error: mysqli Extension

## Problem
```
Installation request for ext-mysqli * -> satisfiable by ...
```

## Cause
mysqli PHP extension not installed or enabled.

## Solution

### Check if Extension is Installed
```bash
php -m | grep mysqli
```

### Install on Ubuntu/Debian
```bash
sudo apt install php-mysqli
sudo service php8.1-fpm restart
```

### Install on Windows (XAMPP)
1. Open php.ini
2. Find `;extension=mysqli`
3. Remove the semicolon to uncomment
4. Restart Apache

### Install on Arch Linux
```bash
sudo pacman -S php-mysql
sudo systemctl restart httpd
```

## Verify Installation
```bash
php -m | grep mysqli
# Should show: mysqli
```

## Tags
#php #troubleshooting
