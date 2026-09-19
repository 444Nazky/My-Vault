# E-Commerce PBO - Quick Start

## Overview
Quick start guide for the E-Commerce PBO project.

## Prerequisites
- PHP 8.0+
- Composer installed
- XAMPP/WAMP/Laragon
- Database server

## Installation Steps

### 1. Clone Repository
```bash
git clone <repository-url>
cd ecommerce-pbo
```

### 2. Install Dependencies
```bash
composer install
```

### 3. Create Environment File
```bash
cp .env.example .env
```

### 4. Generate Application Key
```bash
php artisan key:generate
```

### 5. Create Database
1. Open phpMyAdmin
2. Create new database: `ecommerce_pbo`
3. Select utf8mb4_unicode_ci

### 6. Run Migrations
```bash
php artisan migrate
```

### 7. Seed Database (Optional)
```bash
php artisan db:seed
```

### 8. Start Server
```bash
php artisan serve
```

## Access Application
Open browser: http://localhost:8000

## Tags

