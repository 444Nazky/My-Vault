# PHP Notes

**Born:** 1995. The web backend behind Laravel, which this vault uses for Tasks.

## Arrays Do Everything

```php
$list = [1, 2, 3];
$map = ["a" => 1];
$users[] = $u; // append, arrays grow and double as dicts
```

## Null Coalescing Everywhere

```php
$name = $_GET["name"] ?? "guest";
$conn?->query($sql); // nullsafe call, skips when null
```

Pairs well with the Tasks/Laravel-CRUD/Laravel CRUD guide in this vault.

## Gotchas

- `==` coerces wildly (`0 == "foo"` was true before PHP 8), use `===`.
- Variables need `$`, always, even in classes with `$this->`.
- `empty` treats `"0"` and `0` as empty, check explicitly instead.
- Composer autoload must be regenerated after moving classes.

**Mental model:** request in, array wrangling, response out.

## Tags
#note-php
