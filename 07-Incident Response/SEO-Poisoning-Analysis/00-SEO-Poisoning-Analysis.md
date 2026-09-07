# SEO Poisoning / Judi Online Slot - Security Analysis Framework

> **Target:** `kurmamedia.com` (contoh/silakan diganti)
> **Date:** 2026-09-07
> **Status:** Investigation Complete
> **Tags:** #security #seo-poisoning #incident-response #malware-analysis

---

## Overview

Dokumen ini berisi panduan teknis untuk menganalisis, mendeteksi, dan membersihkan infeksi SEO Poisoning / Judi Online Slot pada sebuah website.

---

## 📁 Table of Contents

1. [[01-Mod operandus & IoC|Modus Operandi & Indikator Kompromi (IoC)]]
2. [[02-Investigation-Commands|Commands untuk Investigasi & Pembuktian]]
3. [[03-Remediation-Hardening|Panduan Remediator & Hardening]]
4. [[04-Checklist|Checklist Lengkap]]
5. [[05-Case-Study-kurmamedia|Case Study: kurmamedia.com]]

---

## 🎯 Case Study: kurmamedia.com

### Investigation Results (2026-09-07)

| Check | Result | Notes |
|-------|--------|-------|
| DNS | `72.61.209.233` | ✅ Aktif |
| Hosting | Hostinger (ID) | Jakarta, AS47583 |
| HTTP | ❌ No Response | Server offline/timeout |
| Sitemap | ❌ Not Found | |
| Google Index | ❌ No Cache | Not indexed |

### Threat Intel
```
IP: 72.61.209.233
Hostname: srv1156729.hstgr.cloud
ISP: Hostinger International Limited
Location: Jakarta, Indonesia
```

### Kesimpulan
Domain aktif di DNS dan hosting provider (Hostinger Indonesia), tetapi server tidak serve HTTP. Kemungkinan: hosting suspended, server down, atau sudah di-take down.

---

## Quick Reference

### 🚨 Red Flags - Cek Cepat

```bash
# Bandingkan respons Googlebot vs User
curl -s https://kurmamedia.com/ | grep -iE "judi|slot|casino" | wc -l
curl -s -A "Googlebot/2.1" https://kurmamedia.com/ | grep -iE "judi|slot|casino" | wc -l
```

### 🔧 Emergency Response

1. **Isolate** → Put site in maintenance mode
2. **Backup** → Archive compromised files
3. **Audit** → Check .htaccess, database, PHP files
4. **Clean** → Replace core files, reset credentials
5. **Re-index** → Submit via Google Search Console

---

## Related

- [[WordPress Hardening Checklist]]
- [[Incident Response Runbook]]
- [[Server Security Baseline]]
