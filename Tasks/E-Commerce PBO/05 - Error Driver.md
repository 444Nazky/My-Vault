# Error: Database Driver

## Problem
```
could not find driver
```

## Cause
Required database PDO driver not installed.

## Solution

### Check Installed Drivers
```bash
php -m | grep -i pdo
```

### Install PDO MySQL Driver

#### Ubuntu/Debian
```bash
sudo apt install php-mysql
sudo service php8.1-fpm restart
```

#### Arch Linux
```bash
sudo pacman -S php-mysql
sudo systemctl restart httpd
```

#### Windows (XAMPP)
1. Open php.ini
2. Find `;extension=pdo_mysql`
3. Remove semicolon
4. Restart Apache

### Verify Installation
```bash
php -m | grep -i pdo_mysql
# Should show: pdo_mysql
```

## Tags
#error #database #pdo #laravel #troubleshooting
