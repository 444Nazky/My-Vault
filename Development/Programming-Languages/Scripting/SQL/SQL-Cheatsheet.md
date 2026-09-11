# SQL Cheatsheet

**Companion:** [[SQL]] for deeper notes

## Query Skeleton

```sql
SELECT u.name, o.total
FROM users u
JOIN orders o ON o.user_id = u.id
WHERE o.total > 100
GROUP BY u.name
HAVING COUNT(*) > 1
ORDER BY o.total DESC
LIMIT 10;
```

## Filtering

```sql
WHERE age BETWEEN 18 AND 65
WHERE name LIKE 'ana%'
WHERE id IN (1, 2, 3)
WHERE deleted_at IS NULL
WHERE email IS NOT NULL
```

## Joins

```sql
INNER JOIN orders o ON o.user_id = u.id   -- matches only
LEFT JOIN orders o ON o.user_id = u.id    -- all users
```

## Aggregates

```sql
SELECT COUNT(*), COUNT(email), AVG(total), SUM(total), MIN(total), MAX(total)
FROM orders;
```

## Grouping

```sql
SELECT user_id, COUNT(*) AS n
FROM orders
GROUP BY user_id
HAVING COUNT(*) > 2;
```

## Writes

```sql
INSERT INTO users (name, email) VALUES ('ana', 'a@x.com');
UPDATE users SET name = 'ana' WHERE id = 1;
DELETE FROM users WHERE id = 1;
```

## Schema

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE users ADD COLUMN age INT DEFAULT 0;
```

## Gotchas

- Always test UPDATE and DELETE as SELECT first.
- Wrap multi-step writes in a transaction with rollback ready.
- Index foreign keys and WHERE columns or joins will crawl.
- Never SELECT star in app code, name the columns.

Tags: #programming #sql #cheatsheet #scripting
