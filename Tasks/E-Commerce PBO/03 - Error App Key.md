# Error: App Key

## Problem
```
No application encryption key has been specified.
```

## Cause
Missing or invalid APP_KEY in .env file.

## Solution

### Generate New Key
```bash
php artisan key:generate
```

This will generate and set a new key in your .env file.

### Manual Method
```bash
# Generate key manually
php artisan key:generate --show
```

Then copy the key and paste it in .env:
```
APP_KEY=base64:your-generated-key-here
```

## Tags
#error #laravel #app-key #troubleshooting
