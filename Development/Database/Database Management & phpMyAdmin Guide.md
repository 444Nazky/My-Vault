# Database Management & phpMyAdmin Guide

## Overview
Guide for managing databases with phpMyAdmin and MySQL/MariaDB.

## phpMyAdmin Setup

### Installation
```bash
# Install on Arch
sudo pacman -S phpmyadmin

# Install Apache/PHP dependencies
sudo pacman -S apache php php-apache php-mysql
```

### Configuration
```bash
# /etc/httpd/conf/extra/httpd-phpmyadmin.conf
Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"
<Directory "/usr/share/webapps/phpMyAdmin">
    AllowOverride All
    Require all granted
</Directory>

# Add to /etc/httpd/conf/httpd.conf
Include conf/extra/httpd-phpmyadmin.conf
```

### Start Services
```bash
# Start Apache
sudo systemctl start httpd

# Start MySQL/MariaDB
sudo systemctl start mariadb

# Enable at boot
sudo systemctl enable httpd mariadb
```

## Database Operations

### Create Database
```sql
CREATE DATABASE mydatabase CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Create User
```sql
CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON mydatabase.* TO 'username'@'localhost';
FLUSH PRIVILEGES;
```

### Backup Database
```bash
mysqldump -u username -p mydatabase > backup.sql

# All databases
mysqldump -u root -p --all-databases > full_backup.sql
```

### Restore Database
```bash
mysql -u username -p mydatabase < backup.sql
```

## Common Tasks

### Import Large SQL File
```bash
# Increase upload limit in php.ini
upload_max_filesize = 64M
post_max_size = 64M

# Or via CLI
mysql -u username -p database < large_file.sql
```

### Optimize Tables
```sql
-- In phpMyAdmin
-- Select database > Operations > Optimize tables

-- Or via SQL
OPTIMIZE TABLE table_name;
```

### Repair Corrupted Table
```sql
REPAIR TABLE table_name;
```

## SQL Reference

### Select
```sql
SELECT * FROM table WHERE condition;
SELECT column1, column2 FROM table ORDER BY column1 DESC;
SELECT COUNT(*) FROM table GROUP BY column;
```

### Insert
```sql
INSERT INTO table (col1, col2) VALUES ('val1', 'val2');
INSERT INTO table SET col1='val1', col2='val2';
```

### Update
```sql
UPDATE table SET col1='val1' WHERE condition;
UPDATE table SET col1=col1+1 WHERE condition;
```

### Delete
```sql
DELETE FROM table WHERE condition;
DELETE FROM table; -- Empty table
TRUNCATE TABLE table; -- Faster delete
```

## Troubleshooting

### Access Denied
```bash
# Reset root password
sudo mysql_secure_installation

# Or manually
sudo systemctl stop mariadb
sudo mysqld_safe --skip-grant-tables &
mysql -u root
# Then reset password in mysql.user table
```

### Connection Issues
- Check if MySQL service is running
- Verify credentials
- Check firewall settings
- Verify socket path in php.ini

## Tags
 #administration #database
