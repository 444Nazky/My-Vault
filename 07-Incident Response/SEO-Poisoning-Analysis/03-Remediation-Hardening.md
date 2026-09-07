# Panduan Remediator & Hardening

## Fase 1: Assessment & Snapshot

```bash
# Buat direktori forensik
mkdir -p /forensics/kurmamedia-$(date +%Y%m%d)
cd /forensics/kurmamedia-$(date +%Y%m%d)

# Download full site untuk perbandingan
wget -r -np -nH --cut-dirs=1 \
     --user-agent="Mozilla/5.0 ForensicBackup" \
     --domains kurmamedia.com \
     -e robots=off \
     https://kurmamedia.com/

# Checksum semua file legitimate
find /var/www/kurmamedia.com -type f -exec md5sum {} \; > file_hashes_$(date +%Y%m%d).txt
```

---

## Fase 2: File Integrity Check

### Scan untuk Backdoor Patterns
```bash
# PHP backdoor signatures
grep -rElE "(eval\s*\(|base64_decode|system\(|exec\(|shell_exec\(|passthru\(|popen\(|assert\(|preg_replace.*e)" \
     /var/www/kurmamedia.com/public_html/ 2>/dev/null > suspicious_files.txt

# Obfuscation patterns
grep -rElE "chr\(|str_rot13|gzinflate|strrev|hex2bin" \
     /var/www/kurmamedia.com/public_html/ 2>/dev/null >> suspicious_files.txt
```

### Cek .htaccess Modification
```bash
# List all .htaccess files
find /var/www -name ".htaccess" -exec ls -la {} \; -exec cat {} \;

# Compare with known good
diff /var/www/kurmamedia.com/.htaccess /backup/clean_htaccess.txt
```

### Cek Cron Jobs
```bash
crontab -l
cat /etc/crontab
ls -la /var/spool/cron/
cat /etc/cron.d/*
```

---

## Fase 3: Cleaning Steps

### Step 1: Isolate - Maintenance Mode
```bash
# Enable maintenance mode
touch /var/www/kurmamedia.com/maintenance.html
echo "<html><body><h1>Site Under Maintenance</h1></body></html>" > /var/www/kurmamedia.com/maintenance.html
```

### Step 2: Backup Original Compromised Files
```bash
tar -czvf compromised_backup_$(date +%Y%m%d).tar.gz \
     /var/www/kurmamedia.com/
```

### Step 3: Reset Semua Credentials
```bash
# FTP/SSH accounts
# Database credentials (update wp-config.php)
# Admin CMS accounts
```

### Step 4: Replace Core CMS Files (WordPress)
```bash
cd /var/www/kurmamedia.com/
rm -rf wp-admin wp-includes
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
mv wordpress/* .
rm -rf wordpress latest.tar.gz
```

### Step 5: Clean .htaccess
```bash
cat > /var/www/kurmamedia.com/.htaccess << 'EOF'
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress

# Security Headers
<IfModule mod_headers.c>
    Header set X-Content-Type-Options "nosniff"
    Header set X-Frame-Options "SAMEORIGIN"
    Header set X-XSS-Protection "1; mode=block"
</IfModule>

# Disable PHP execution in uploads
<Directory "wp-content/uploads">
    <FilesMatch "\.php$">
        Order Deny,Allow
        Deny from all
    </FilesMatch>
</Directory>
EOF
```

### Step 6: Audit Database
```sql
-- Check untuk injected scripts
SELECT * FROM wp_posts WHERE post_content LIKE '%<script%' OR post_content LIKE '%eval%';

-- Check untuk recent suspicious posts
SELECT * FROM wp_posts WHERE post_status='publish' AND post_date > DATE_SUB(NOW(), INTERVAL 30 DAY);

-- Check untuk suspicious options
SELECT * FROM wp_options WHERE option_value LIKE '%http%' OR option_value LIKE '%iframe%';
```

---

## Fase 4: Hardening

### File Permissions
```bash
find /var/www/kurmamedia.com -type f -exec chmod 644 {} \;
find /var/www/kurmamedia.com -type d -exec chmod 755 {} \;
chmod 440 wp-config.php
chmod 400 .htaccess
```

### Install Security Plugins (WordPress)
```bash
wp plugin install wordfence --activate
wp plugin install sucuri-scanner --activate
wp plugin install better-wp-security --activate
```

### Disable XML-RPC
```bash
echo "# Disable XML-RPC
<FilesMatch \"xmlrpc.php$\">
    Order Deny,Allow
    Deny from all
</FilesMatch>" >> .htaccess
```

### Setup File Monitoring (AIDE)
```bash
# Install AIDE
apt-get install aide

# Initialize database
aide --init

# Daily check
aide --check
```

### Configure Fail2Ban
```bash
cat > /etc/fail2ban/jail.local << 'EOF'
[nginx-http-auth]
enabled  = true
port     = http,https
filter   = nginx-http-auth
logpath  = /var/log/nginx/error.log
maxretry = 5

[wordpress-login]
enabled  = true
port     = http,https
filter   = wordpress-login
logpath  = /var/log/nginx/access.log
maxretry = 3
bantime  = 3600
EOF
```

---

## Fase 5: Google Search Console Re-indexing

### Steps:
1. **Login** → https://search.google.com/search-console
2. **Verify ownership** domain (TXT record di DNS)
3. **Request Inspection** untuk URL utama
4. **Submit clean sitemap**
5. **Remove spam URLs** dari index

### Submit Sitemap
```
https://kurmamedia.com/sitemap.xml
```

### Force Re-crawl
```bash
curl -s "https://www.google.com/ping?sitemap=https://kurmamedia.com/sitemap.xml"
```

### Remove Spam URLs
```
Google Search Console → Removals → Temporary Removals → New Request
```

---

## Fase 6: Monitoring & Alerting

```bash
cat > /usr/local/bin/site-monitor.sh << 'EOF'
#!/bin/bash
LOG="/var/log/site-monitor.log"
ALERT_EMAIL="security@example.com"

# Check untuk file baru yang mencurigakan
NEW_FILES=$(find /var/www -type f -mtime -1 | grep -vE "\.(jpg|png|css|js)$")
if [ -n "$NEW_FILES" ]; then
    echo "$(date) - New files detected: $NEW_FILES" >> $LOG
    echo "WARNING: New files detected" | mail -s "Security Alert" $ALERT_EMAIL
fi

# Check untuk perubahan .htaccess
HTCHECK=$(aide --check | grep -E "\.htaccess")
if [ -n "$HTCHECK" ]; then
    echo "$(date) - .htaccess changed!" >> $LOG
    echo "CRITICAL: .htaccess modified" | mail -s "Security Alert" $ALERT_EMAIL
fi
EOF

chmod +x /usr/local/bin/site-monitor.sh
echo "0 */6 * * * /usr/local/bin/site-monitor.sh" >> /etc/crontab
```

---

## Tags

#remediation #hardening #cleanup #google-search-console #monitoring
