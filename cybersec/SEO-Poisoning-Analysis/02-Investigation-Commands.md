# Investigation Commands - OSINT & CLI

## 1. cURL Commands untuk Cek Cloaking

### Basic Header Check (Googlebot UA)
```bash
curl -I -A "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" \
 -H "Accept: text/html,application/xhtml+xml" \
 https://kurmamedia.com/ 2>/dev/null | head -20
```

### Full HTML Response (Googlebot)
```bash
curl -s -A "Googlebot/2.1 (+http://www.google.com/bot.html)" \
 https://kurmamedia.com/ | head -100
```

### Simulasi Googlebot dengan IP Spoofing
```bash
curl -I -A "Googlebot/2.1" \
 -H "X-Forwarded-For: 66.249.66.1" \
 https://kurmamedia.com/
```

### Bandingkan User vs Googlebot
```bash
# Normal user - hitung keyword judol
curl -s https://kurmamedia.com/ | grep -iE "judi|slot|casino|pkv|gambling|agen" | wc -l

# Googlebot - hitung keyword judol
curl -s -A "Googlebot/2.1" https://kurmamedia.com/ | grep -iE "judi|slot|casino|pkv|gambling|agen" | wc -l
```

### Cek Redirect Chain
```bash
curl -Lv -A "Googlebot/2.1" https://kurmamedia.com/ 2>&1 | grep -E "Location:|< HTTP|< Location"
```

### Cek Hidden Content / Cloaked Sections
```bash
curl -s -A "Googlebot/2.1" https://kurmamedia.com/ | \
 grep -iE "display:\s*none|visibility:\s*hidden|opacity:\s*0" -A2 -B2
```

### Cek External Links Mencurigakan
```bash
curl -s https://kurmamedia.com/ | grep -oE 'href="https?://[^"]+' | sort -u
```

---

## 2. Google Dorking Commands

### Langsung di Google Search:

```
# Temukan subdomain/page judol tersembunyi
site:kurmamedia.com inurl:slot
site:kurmamedia.com inurl:casino
site:kurmamedia.com inurl:pkv
site:kurmamedia.com inurl:agen

# Temukan page dengan keywords judol
site:kurmamedia.com "slot online"
site:kurmamedia.com "judi slot"
site:kurmamedia.com "bandarqq"

# Temukan file mencurigakan
site:kurmamedia.com filetype:php "eval"
site:kurmamedia.com filetype:txt "base64"
site:kurmamedia.com filetype:sql

# Kombinasi
site:kurmamedia.com (slot OR casino OR poker) -www
site:kurmamedia.com "gacor" OR "maxwin" OR "rtp"

# Cek cached version (tunjukkan konten berbeda)
cache:kurmamedia.com
```

---

## 3. Additional CLI Checks

### WHOIS Lookup
```bash
whois kurmamedia.com | grep -iE "created|expir|updated|status"
```

### DNS Records Check
```bash
dig kurmamedia.com A +short
dig kurmamedia.com CNAME
dig kurmamedia.com NS
dig kurmamedia.com MX
```

### VirusTotal Check
```bash
curl -s "https://www.virustotal.com/api/v3/urls" \
 -H "x-apikey: YOUR_API_KEY" \
 -d "url=https://kurmamedia.com"
```

### URLScan.io
```bash
curl -s "https://urlscan.io/api/v1/scan/" \
 -H "Content-Type: application/json" \
 -d '{"url": "https://kurmamedia.com", "visibility": "public"}'
```

### Cek Sitemap untuk URL Mencurigakan
```bash
curl -s https://kurmamedia.com/sitemap.xml | grep -iE "slot|judi|casino|pkv"
```

---

## 4. Site Download for Forensic Analysis

```bash
# Buat direktori forensik
mkdir -p /forensics/kurmamedia-$(date +%Y%m%d)
cd /forensics/kurmamedia-$(date +%Y%m%d)

# Download full site
wget -r -np -nH --cut-dirs=1 \
 --user-agent="Mozilla/5.0 ForensicBackup" \
 --domains kurmamedia.com \
 -e robots=off \
 https://kurmamedia.com/

# Generate checksum
find . -type f -exec md5sum {} \; > file_hashes.txt
```

---

## 5. Google Cache Analysis

```
# Cek Google cached version
1. Buka: https://webcache.googleusercontent.com/search?q=cache:kurmamedia.com
2. Bandingkan dengan live version
3. Perhatikan perbedaan content
```

---

## 6. Case Study: kurmamedia.com (2026-09-07)

### Investigation Results

| Check | Result | Notes |
|-------|--------|-------|
| DNS Resolution | `72.61.209.233` | ✅ Active |
| WHOIS Status | `clientTransferProhibited` | Domain aktif, expires 2026-11-18 |
| HTTP Response | ❌ Timeout | Server tidak respons |
| SSL/TLS | ❌ Connection failed | Kemungkinan firewall/WAF |
| Sitemap.xml | ❌ Not found | |
| robots.txt | ❌ Not found | |
| Google Cache | ❌ No cached version | Tidak ada di index |

### IP Geolocation (72.61.209.233)
```json
{
 "ip": "72.61.209.233",
 "hostname": "srv1156729.hstgr.cloud",
 "city": "Jakarta",
 "region": "Jakarta",
 "country": "ID",
 "org": "AS47583 Hostinger International Limited",
 "loc": "-6.2146,106.8451"
}
```

### Threat Intelligence Summary

| Indicator | Value |
|-----------|-------|
| IP Address | 72.61.209.233 |
| ASN | AS47583 (Hostinger) |
| Country | Indonesia (ID) |
| Hosting Provider | Hostinger International Limited |
| Hostname Pattern | `srv1156729.hstgr.cloud` |

### Kesimpulan Awal

Domain `kurmamedia.com`:
- **DNS aktif** - domain registered dan resolving
- **Server mati/offline** - tidak serve HTTP content
- **Tidak ada di Google index** - tidak ada cached version
- **Kemungkinan scenario**:
 1. Server dihack → attacker take down
 2. Hosting suspended karena abuse
 3.涊 Dibersihkan owner → masih dalam proses
 4. Domain parked/squatted

### Rekomendasi Lanjutan

1. **Cek Wayback Machine** untuk historical content:
 ```
 https://web.archive.org/web/*/https://kurmamedia.com/
 ```

2. **Cek IP reputation** secara langsung:
 - AbuseIPDB
 - Shodan
 - Censys

3. **Monitoring** - set up alert jika domain become active again

4. **Hostinger Abuse Report** - Jika domain di-host di Hostinger:
 ```
 https://www.hostinger.com/report-abuse
 ```

---

## Tags

#investigation #curl #osint #dorking #forensics #commands
