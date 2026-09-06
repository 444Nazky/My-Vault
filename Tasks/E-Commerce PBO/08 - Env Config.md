# Environment Configuration

## Overview
Guide for configuring the .env file.

## Create .env File
```bash
cp .env.example .env
```

## Essential Variables

### Application
```
APP_NAME="E-Commerce PBO"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost
```

### Database
```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=ecommerce_pbo
DB_USERNAME=root
DB_PASSWORD=
```

### Mail (Optional)
```
MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
```

## Generate Key
```bash
php artisan key:generate
```

## Clear Cache
```bash
php artisan config:clear
php artisan cache:clear
```

## Tags
#environment #configuration #laravel #env
