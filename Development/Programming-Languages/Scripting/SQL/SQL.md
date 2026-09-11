# SQL Notes

**Born:** 1986 standard. The query language behind every Laravel database in this vault.

## NULL Is Not a Value

```sql
SELECT * FROM users WHERE deleted_at IS NULL;
```

`NULL = NULL` is never true. Use IS NULL and IS NOT NULL, and COALESCE for defaults.

## Join the Right Table First

```sql
SELECT u.name, COUNT(o.id) AS orders
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
GROUP BY u.name
HAVING COUNT(o.id) > 2
ORDER BY orders DESC;
```

Pairs with the Tasks/Laravel-CRUD Eloquent Relationships guide and the E-Commerce PBO database setup.

## Gotchas

- WHERE filters rows before grouping, HAVING filters groups after.
- COUNT counts non-null values, COUNT star counts rows.
- LIKE patterns need ESCAPE when matching literal percent or underscore.
- Migrations are the schema source of truth, never hand-edit production.

**Mental model:** sets in, sets out, NULL is a third state.

Tags: #programming #sql #cobweb #scripting
