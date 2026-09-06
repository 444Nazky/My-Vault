# Database Security Requirements

## Overview
Security requirements and best practices for database systems.

## Common Database Systems

### MySQL/MariaDB
- Default port: 3306
- Configuration: /etc/mysql/
- Logs: /var/log/mysql/

### PostgreSQL
- Default port: 5432
- Configuration: /var/lib/postgres/
- Connection: psql

### SQLite
- File-based
- No server required
- Good for embedded applications

## Security Hardening

### MySQL/MariaDB
```bash
# Secure installation
mysql_secure_installation

# Create limited user
CREATE USER 'app'@'localhost' IDENTIFIED BY 'strong_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON app_db.* TO 'app'@'localhost';
FLUSH PRIVILEGES;
```

### PostgreSQL
```bash
# Create limited user
CREATE USER app WITH PASSWORD 'strong_password';
GRANT CONNECT ON DATABASE app_db TO app;
GRANT USAGE ON SCHEMA public TO app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app;
```

## Common Vulnerabilities

### SQL Injection
- User input not sanitized
- Dynamic SQL construction
- Lack of parameterized queries

### Authentication
- Weak passwords
- Default credentials
- No account lockout

### Configuration
- Remote root access enabled
- Sample databases installed
- Verbose error messages

## Best Practices

### Access Control
- Principle of least privilege
- Separate application accounts
- Regular access reviews

### Encryption
- TLS for connections
- Encrypted backups
- Secure key storage

### Monitoring
- Enable query logging
- Monitor failed connections
- Alert on suspicious activity

### Updates
- Regular security patches
- Subscribe to security lists
- Test in staging first

## Tags
#database #security #mysql #postgresql #sql
