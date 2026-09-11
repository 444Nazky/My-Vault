# BlackArch Audit

## Overview
Security audit procedures using BlackArch tools.

## Pre-Audit Checklist

### Information Gathering
- Scope definition
- Target inventory
- Authorization confirmation
- Rules of engagement

### Tools Preparation
```bash
# Update BlackArch
sudo blackarch-update

# Verify key tools
pacman -Qi nmap sqlmap nikto metasploit
```

## Scanning Phase

### Network Discovery
```bash
# Network scan
nmap -sn 192.168.1.0/24

# Find live hosts
nmap -sP 10.0.0.0/24
```

### Port Scanning
```bash
# Top 100 ports
nmap -F target.com

# All ports
nmap -p- target.com

# Service detection
nmap -sV target.com

# OS detection
nmap -O target.com
```

### Vulnerability Scanning
```bash
# Nikto web scan
nikto -h http://target.com

# Nuclei scan
nuclei -u http://target.com

# Custom templates
nuclei -u http://target.com -t custom-templates/
```

## Web Application Testing

### Directory Enumeration
```bash
# Dirsearch
python3 dirsearch.py -u http://target.com -e php,html,js

# Gobuster
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt
```

### SQL Injection
```bash
# Auto-detect
sqlmap -u "http://target.com/page.php?id=1"

# Enumerate databases
sqlmap -u "http://target.com/page.php?id=1" --dbs

# Extract data
sqlmap -u "http://target.com/page.php?id=1" -D dbname -T users --dump
```

## Password Attacks

### Hash Cracking
```bash
# Hashcat
hashcat -m 0 hash.txt wordlist.txt

# John
john --wordlist=rockyou.txt hash.txt
```

## Reporting

### Evidence Collection
- Screenshot all findings
- Document all commands
- Record timestamps
- Save logs

### Report Structure
1. Executive Summary
2. Methodology
3. Findings (Critical, High, Medium, Low)
4. Proof of Concept
5. Remediation Recommendations

## Tags
 #blackarch #pentesting #security
