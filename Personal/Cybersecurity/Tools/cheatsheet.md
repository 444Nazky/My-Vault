# Cybersecurity Cheatsheet

## Overview
Quick reference for common cybersecurity tools and commands.

## Reconnaissance

### Nmap
```bash
nmap -sV target.com          # Version scan
nmap -p- target.com          # All ports
nmap -O target.com            # OS detection
nmap -sC target.com          # Default scripts
nmap -A target.com           # Aggressive scan
```

### Gobuster
```bash
gobuster dir -u http://target.com -w wordlist.txt
gobuster dns -d target.com -w subdomains.txt
```

## Web Application

### SQLMap
```bash
sqlmap -u "http://target.com/page?id=1" --dbs
sqlmap -u "http://target.com/page?id=1" -D db --tables
sqlmap -u "http://target.com/page?id=1" -D db -T users --dump
```

### Dirsearch
```bash
python3 dirsearch.py -u http://target.com -e php,html,js
```

### Nikto
```bash
nikto -h http://target.com
```

## Password Attacks

### Hashcat
```bash
hashcat -m 0 hash.txt wordlist.txt         # MD5
hashcat -m 1000 hash.txt wordlist.txt       # NTLM
hashcat -a 3 hash.txt ?a?a?a?a?a?a?a?a   # Bruteforce
```

### John
```bash
john --wordlist=rockyou.txt hash.txt
john --show hash.txt
```

### Hydra
```bash
hydra -l admin -P passwords.txt ssh://target.com
hydra -l admin -P passwords.txt target.com http-post-form "/login:user=^USER^&pass=^PASS^:F=error"
```

## Wireless

### Aircrack-ng
```bash
airmon-ng start wlan0
airodump-ng wlan0mon
airodump-ng -w capture -c 1 --bssid MAC wlan0mon
aircrack-ng -w wordlist.txt capture.cap
```

## Exploitation

### Metasploit
```bash
msfconsole
search exploit_name
use module/path
set RHOSTS target.com
exploit
```

## Network

### Netcat
```bash
nc -lvnp 4444                    # Listener
nc target.com 4444                 # Connect
```

### Curl
```bash
curl -I http://target.com
curl -X POST -d "param=value" http://target.com
curl -H "Authorization: Bearer token" http://target.com
```

## Tags
#cheatsheet #pentesting #security
