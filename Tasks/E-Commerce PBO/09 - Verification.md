# Verification

## Overview
Checklist to verify successful installation.

## Pre-Launch Checks

### Environment
- [ ] .env file created
- [ ] APP_KEY generated
- [ ] Database configured
- [ ] No errors in .env

### Database
- [ ] Database created
- [ ] Migrations ran successfully
- [ ] Tables exist
- [ ] Seed data loaded (if applicable)

### Server
- [ ] Application runs without errors
- [ ] No 500 errors
- [ ] Static assets load

## Test Endpoints

### Home Page
```bash
curl http://localhost:8000
```

### Products API
```bash
curl http://localhost:8000/api/products
```

### Categories API
```bash
curl http://localhost:8000/api/categories
```

## Common Issues
- Port already in use
- Permission denied
- Database connection failed

## Tags
#verification #testing #laravel #checklist
