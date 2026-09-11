# SEO Poisoning Cleanup - Checklist

> Checklist lengkap untuk membersihkan infeksi SEO Poisoning / Judi Online Slot

---

## Phase 1: Detection & Analysis
- [ ] Bandingkan respons Googlebot vs User dengan curl
- [ ] Dump sitemap.xml, cek URL mencurigakan
- [ ] Scan semua file untuk backdoor patterns
- [ ] Audit database CMS untuk injected content
- [ ] Review .htaccess untuk redirect rules
- [ ] List semua file yang dimodifikasi recently
- [ ] Backup full site sebelum cleaning

## Phase 2: Isolation
- [ ] Enable maintenance mode
- [ ] Disable write access ke public_html
- [ ] Snapshot/volume backup server
- [ ] Dokumentasikan current state

## Phase 3: Cleaning
- [ ] Reset semua credentials:
 - [ ] FTP/SFTP password
 - [ ] SSH keys/passwords
 - [ ] Database credentials
 - [ ] CMS admin passwords
 - [ ] Hosting/cPanel passwords
 - [ ] Any API keys exposed

- [ ] Remove backdoor files
- [ ] Clean injected database content
- [ ] Replace compromised .htaccess
- [ ] Replace core CMS files
- [ ] Update semua plugins/themes
- [ ] Remove suspicious cron jobs
- [ ] Clean any added SSH keys

## Phase 4: Hardening
- [ ] Setup proper file permissions
- [ ] Configure firewall rules
- [ ] Install security plugins
- [ ] Enable file integrity monitoring
- [ ] Setup fail2ban
- [ ] Configure logging & alerting
- [ ] Enable 2FA untuk semua accounts
- [ ] Disable unnecessary services
- [ ] Update all passwords to strong random

## Phase 5: Verification
- [ ] Scan ulang dengan malware tools
- [ ] Test responsiveness Googlebot UA
- [ ] Verify no gambling keywords
- [ ] Test all forms/inputs
- [ ] Check for any new suspicious files

## Phase 6: Google Re-indexing
- [ ] Login Google Search Console
- [ ] Verify domain ownership
- [ ] Submit inspection request
- [ ] Submit clean sitemap.xml
- [ ] Remove spam URLs via Removals tool
- [ ] Force recrawl with ping

## Phase 7: Monitoring
- [ ] Setup continuous file monitoring
- [ ] Configure uptime monitoring
- [ ] Setup Google Alerts untuk domain
- [ ] Enable server logging
- [ ] Configure backup schedule
- [ ] Document incident & lessons learned

---

## Quick Commands Reference

### Detection
```bash
# Bandingkan Googlebot vs User
curl -s https://target.com/ | grep -iE "slot|judi|casino" | wc -l
curl -s -A "Googlebot/2.1" https://target.com/ | grep -iE "slot|judi|casino" | wc -l

# Cek sitemap
curl -s https://target.com/sitemap.xml | grep -iE "slot|judi"
```

### File Scan
```bash
# Backdoor patterns
grep -rElE "eval\(|base64_decode|system\(" /var/www/*/public_html/

# Recent modified files
find /var/www -type f -mtime -7
```

### Quick Cleanup
```bash
# Backup
tar -czvf backup_$(date +%Y%m%d).tar.gz /var/www/

# Reset permissions
find /var/www -type f -exec chmod 644 {} \;
find /var/www -type d -exec chmod 755 {} \;
chmod 440 wp-config.php
```

---

## External Resources

- [[https://developers.google.com/search/docs/crawling-indexing/googlebot|Googlebot Documentation]]
- [[https://wordfence.com/docs|Wordfence Documentation]]
- [[https://sitecheck.sucuri.net|Sucuri SiteCheck]]

---

## Tags

#checklist #incident-response #cleanup
