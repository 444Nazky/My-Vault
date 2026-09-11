# PHP Cheatsheet

**Companion:** [[PHP]] for deeper notes

## Skeleton

```php
<?php
echo "hello";
```

## Composer Commands

```bash
composer install
composer dump-autoload
composer require vendor/pkg
php artisan serve
```

## Types and Variables

```php
$i = 42; $f = 3.14; $b = true; $s = "hi"; $n = null;
$a = [1, 2, 3]; $m = ["k" => "v"];
$c = count($a); $ok = isset($m["k"]);
```

## Strings

```php
$name = "ana";
echo "hello $name, sum " . ($a + $b);
explode(",", "a,b"); implode(", ", $a);
strlen($s); substr($s, 0, 2);
```

## Control Flow

```php
if ($x > 0) { } elseif ($x == 0) { } else { }
for ($k = 0; $k < $n; $k++) { }
foreach ($a as $e) { }
foreach ($m as $k => $v) { }
while ($cond) { }
match ($x) { 1 => "one", default => "?" };
```

## Functions

```php
function add(int $a, int $b = 0): int { return $a + $b; }
$dbl = fn($e) => $e * 2;   // arrow fn, auto-captures
```

## Classes

```php
class Task {
    public function __construct(public string $title) {}
    public bool $done = false;
    public function complete(): void { $this->done = true; }
}
```

## Superglobals and Request

```php
$name = $_GET["name"] ?? $_POST["name"] ?? "guest";
$id = (int)($_GET["id"] ?? 0);
```

## Gotchas

- `===` everywhere, `==` coerces.
- `require` fatals on missing, `include` only warns.
- Headers must be sent before any output, watch stray whitespace.
- `foreach` copies values, use `&$e` to mutate in place.

Tags: #programming #php #cheatsheet
