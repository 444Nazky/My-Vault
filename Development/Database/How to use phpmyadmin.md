# How to Use phpMyAdmin

## Overview
Step-by-step guide for using phpMyAdmin web interface.

## Accessing phpMyAdmin

### Local Access
Open browser: http://localhost/phpmyadmin

### Login
- Username: root (or your user)
- Password: (your MySQL password)

## Navigation

### Left Panel
- Server: localhost
- Databases list
- Selected database tables

### Main Area
- Tabs: Structure, SQL, Search, Query, Export, Import, Operations

## Common Operations

### Create New Database
1. Click "New" in left panel
2. Enter database name
3. Select collation (utf8mb4_unicode_ci)
4. Click "Create"

### Create Table
1. Select database
2. Enter table name
3. Enter number of columns
4. Click "Go"
5. Define columns:
   - Name
   - Type (INT, VARCHAR, TEXT, etc.)
   - Length/Values
   - Default value
   - Collation
   - Checkbox for primary key/Auto Increment

### Insert Data
1. Select table
2. Click "Insert" tab
3. Fill form fields
4. Click "Go"

### Edit Data
1. Browse table
2. Click "Edit" on row
3. Modify fields
4. Click "Go"

### Delete Data
```sql
-- Single row (in SQL tab)
DELETE FROM table WHERE id = 1;

-- Multiple rows
DELETE FROM table WHERE condition;
```

## Query Editor

### Write Custom Query
1. Click "SQL" tab
2. Write SQL query
3. Click "Go"

### Example Queries
```sql
-- Select with condition
SELECT * FROM users WHERE email LIKE '%@example.com';

-- Join tables
SELECT users.name, orders.total
FROM users
INNER JOIN orders ON users.id = orders.user_id;

-- Aggregate
SELECT COUNT(*), category FROM products GROUP BY category;
```

## Import/Export

### Export Database
1. Select database
2. Click "Export" tab
3. Choose "Quick" or "Custom"
4. Select format (SQL)
5. Click "Go"

### Import Database
1. Select database
2. Click "Import" tab
3. Choose file
4. Click "Go"

## Table Operations

### Structure View
- View column details
- Add columns
- Modify columns
- Drop columns
- Set primary key
- Set indexes

### Browse View
- Paginated data view
- Edit inline
- Delete rows
- Sort columns
- Filter data

### Search
- Full-text search
- Column-specific search
- Multiple conditions

## Troubleshooting

### Session Expired
- Re-login
- Increase session timeout in config

### Upload Failed
- Increase limits in php.ini
- Check file permissions

### Query Timeout
- Break into smaller queries
- Add indexes to improve performance

## Tips

### Keyboard Shortcuts
- Ctrl+Enter: Execute query
- Ctrl+S: Save bookmark
- Ctrl+U: Toggle SQL editor

### Best Practices
- Always backup before major changes
- Use transactions for multiple updates
- Validate data before import
- Use appropriate column types

## Tags
#phpmyadmin #database #mysql #tutorial
