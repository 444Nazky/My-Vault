# Case Study: kurmamedia.com Investigation

> **Date:** 2026-09-07
> **Investigator:** Automated OSINT Scan
> **Status:** Complete - Server Offline

---

## Executive Summary

Analisis OSINT terhadap `kurmamedia.com` menunjukkan domain aktif di DNS dan hosting provider, namun server tidak serve HTTP content. Diduga domain pernah digunakan untuk SEO Poisoning Judi Online, namun saat ini dalam status tidak aktif.

---

## Domain Information

```
Registrar: VeriSign Global Registry Services
Registered: 2023-11-18
Expires: 2026-11-18
Status: clientTransferProhibited
Last Updated: 2025-11-17
```

---

## Hosting Infrastructure

| Field | Value |
|-------|-------|
| IP Address | 72.61.209.233 |
| Hostname | srv1156729.hstgr.cloud |
| ASN | AS47583 |
| ISP | Hostinger International Limited |
| Country | Indonesia (ID) |
| Region | Jakarta |
| Coordinates | -6.2146, 106.8451 |

### Hosting Analysis

```
┌─────────────────────────────────────────────────┐
│ kurmamedia.com INFRASTRUCTURE │
├─────────────────────────────────────────────────┤
│ │
│ Domain Registrar: VeriSign │
│ │ │
│ ▼ │
│ DNS: 72.61.209.233 │
│ │ │
│ ▼ │
│ Hostinger Cloud (Jakarta, ID) │
│ srv1156729.hstgr.cloud │
│ │
└─────────────────────────────────────────────────┘
```

---

## HTTP/HTTPS Probing Results

### Tests Performed

| Test | URL | Result |
|------|-----|--------|
| HTTP Header | https://kurmamedia.com/ | ❌ Timeout |
| HTTPS Header | https://kurmamedia.com/ | ❌ Timeout |
| SSL/TLS | TLS Handshake | ❌ Connection Failed |
| www subdomain | https://www.kurmamedia.com/ | ❌ Timeout |
| HTTP via IP | http://72.61.209.233/ | ❌ No Response |
| Sitemap | https://kurmamedia.com/sitemap.xml | ❌ Not Found |
| Robots.txt | https://kurmamedia.com/robots.txt | ❌ Not Found |

### Technical Details

```bash
# DNS Resolution
$ dig kurmamedia.com A +short
72.61.209.233

# Connection Test
$ curl -v https://kurmamedia.com/
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* SSL Trust Anchors:
... (connection stalled)
```

---

## Search Engine Analysis

### Google Search Results

| Check | Result |
|-------|--------|
| Google Index | ❌ Not Found |
| Google Cache | ❌ No cached version |
| Google Snippet | N/A |
| Related Keywords | Unable to crawl |

### Dorking Results

```
site:kurmamedia.com slot → No results
site:kurmamedia.com casino → No results
site:kurmamedia.com "judi slot" → No results
site:kurmamedia.com filetype:php → No results
```

---

## Threat Assessment

### Indicators of Compromise (Historical - jika pernah terinfeksi)

Based on the infrastructure (Indonesian hosting, WordPress-compatible hostname), berikut IoC yang harus dimonitor:

| Indicator Type | Pattern | Status |
|----------------|---------|--------|
| URL Pattern | `/slot-gacor-*` | Monitor |
| URL Pattern | `/agen-judi-*` | Monitor |
| URL Pattern | `/pkv-games/*` | Monitor |
| Keywords | "slot online", "maxwin", "rtp" | Monitor |
| Backdoor | `eval(base64_decode(...))` | Check if active |
| Cloaking | `.htaccess` Googlebot redirect | Check if active |

---

## Timeline Hypotheses

```
┌──────────────────────────────────────────────────────────────┐
│ POSSIBLE TIMELINE │
├──────────────────────────────────────────────────────────────┤
│ │
│ Nov 2023 Domain registered │
│ │ │
│ ▼ │
│ Early 2024 Site launched / compromised │
│ │ │
│ ▼ │
│ Mid 2024 SEO Poisoning campaign active │
│ │ - Cloaking detected by Google │
│ │ - Domain flagged in Search Console │
│ ▼ │
│ Late 2024 Decline / Suspected cleanup │
│ │ │
│ ▼ │
│ Sep 2026 Current: Server offline, domain still registered │
│ │
└──────────────────────────────────────────────────────────────┘
```

---

## Recommendations

### Immediate Actions

1. **Cek Wayback Machine** untuk historical snapshots:
 ```
 https://web.archive.org/web/2024*/https://kurmamedia.com/
 ```

2. **Monitor Domain** untuk aktivitas baru:
 - Setup DNS monitoring
 - Alert jika IP berubah
 - Alert jika HTTP mulai responsif

3. **Report ke Hostinger** jika ditemukan abuse:
 ```
 https://www.hostinger.com/report-abuse
 ```

### For Other Similar Domains

Jika menganalisis domain lain yang similar:

```bash
# Quick scan script
TARGET="example.com"
echo "=== DNS ===" && dig $TARGET A +short
echo "=== WHOIS ===" && whois $TARGET | grep -E "Status|Expiry|Created"
echo "=== IP Info ===" && curl -s ipinfo.io/$(dig $TARGET A +short | head -1)/json
echo "=== Headers ===" && curl -I -A "Googlebot/2.1" https://$TARGET/ 2>/dev/null | head -10
echo "=== Keywords ===" && curl -s https://$TARGET/ | grep -iE "slot|judi|casino|pkv" | wc -l
```

---

## Related Files

- [[01-Mod operandus & IoC]]
- [[02-Investigation-Commands]]
- [[03-Remediation-Hardening]]
- [[04-Checklist]]

---

## Tags

#case-study #kurmamedia #osint #hostinger #indonesia 
