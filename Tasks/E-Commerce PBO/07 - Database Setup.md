# Database Setup

## Overview
Step-by-step guide for setting up the database.

## Prerequisites
- Database server running
- phpMyAdmin or MySQL CLI access

## Steps

### Create Database
1. Open phpMyAdmin
2. Click "Databases" tab
3. Create new database: `ecommerce_pbo`
4. Select collation: `utf8mb4_unicode_ci`

### Run Migrations
```bash
php artisan migrate
```

### Seed Data (Optional)
```bash
php artisan db:seed
```

## Tables Created
- users
- categories
- products
- orders
- order_items
- carts

## Tags
#database #setup #laravel #migration
