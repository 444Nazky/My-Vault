# Bootcamp Tools Setup

## Overview
Setup guide for cybersecurity bootcamp tools and environment.

## Essential Tools

### Network Scanning
```bash
# Nmap
sudo pacman -S nmap

# Masscan
sudo pacman -S masscan

# Netcat
sudo pacman -S netcat-openbsd
```

### Web Application Testing
```bash
# Burp Suite
sudo pacman -S burpsuite

# OWASP ZAP
sudo pacman -S zaproxy

# SQLMap
pip install sqlmap

# Dirsearch
git clone https://github.com/maurosoria/dirsearch.git
```

### Password Attacks
```bash
# Hashcat
sudo pacman -S hashcat

# John the Ripper
sudo pacman -S john

# Hydra
sudo pacman -S hydra
```

### Wireless
```bash
# Aircrack-ng
sudo pacman -S aircrack-ng

# Wifite
pip install wifite
```

### Exploitation
```bash
# Metasploit
sudo pacman -S metasploit

# SearchSploit
sudo pacman -S exploitdb
```

## Development Environment

### Python
```bash
sudo pacman -S python python-pip
pip install sqlmap requests beautifulsoup4
```

### Ruby
```bash
sudo pacman -S ruby
gem install bundler
```

### Go
```bash
sudo pacman -S go
```

## Wordlists

### Kali Linux Wordlists
```bash
sudo pacman -S wordlist

# Additional wordlists
/usr/share/wordlists/
```

## Virtual Lab Setup

### Vulnerable VMs
- DVWA (Damn Vulnerable Web Application)
- Metasploitable
- OWASP WebGoat
- Vulnhub VMs

### Download Links
- DVWA: https://dvwa.co.uk/
- Metasploitable: https://information.rapid7.com/metasploitable-download.html

## Practice Platforms

### Online Labs
- HackTheBox
- TryHackMe
- VulnHub
- PentesterLab

### CTF Platforms
- picoCTF
- CTFlearn
- OverTheWire

## Documentation

### Kali Documentation
https://docs.kali.org/

### OWASP
https://owasp.org/

## Tags
#bootcamp #tools #setup #pentesting #security
