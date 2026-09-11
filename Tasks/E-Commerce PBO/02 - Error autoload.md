# Error: Autoload

## Problem
```
Error: Class 'Illuminate\Foundation\Application' not found
```

## Cause
Composer autoload files not generated or corrupted.

## Solution

### Step 1: Clear Cache
```bash
composer dump-autoload
```

### Step 2: Reinstall Dependencies
```bash
rm -rf vendor
composer install
```

### Step 3: Regenerate Autoload
```bash
composer dump-autoload --optimize
```

### Step 4: Clear Application Cache
```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
```

## Prevention
- Always run `composer install` after cloning
- Check vendor directory exists
- Verify composer.json is valid

## Tags
#troubleshooting
