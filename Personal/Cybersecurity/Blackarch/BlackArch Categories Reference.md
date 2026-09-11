# BlackArch Categories Reference

## Overview
Overview of BlackArch tool categories and key tools.

## Category Breakdown

### Reconnaissance
Tools for information gathering and scanning.

| Tool | Purpose |
|------|---------|
| nmap | Network scanner |
| masscan | Fast port scanner |
| amass | Subdomain enumeration |
| theHarvester | Email/domain harvest |
| recon-ng | Web reconnaissance |

### Exploitation
Framework and exploit tools.

| Tool | Purpose |
|------|---------|
| metasploit | Exploitation framework |
| searchsploit | Exploit database search |
| beef-xss | Browser exploitation |

### Password Attacks
Hash cracking and password tools.

| Tool | Purpose |
|------|---------|
| hashcat | GPU-accelerated cracker |
| john | John the Ripper |
| hydra | Online password attacks |
| medusa | Parallel login cracker |

### Web Application
Web vulnerability testing.

| Tool | Purpose |
|------|---------|
| sqlmap | SQL injection |
| nikto | Web server scanner |
| dirsearch | Directory enumeration |
| burpsuite | Web proxy |
| nuclei | Vulnerability scanner |

### Wireless
WiFi and Bluetooth testing.

| Tool | Purpose |
|------|---------|
| aircrack-ng | WiFi suite |
| wifite2 | Automated WiFi attack |
| bully | WPS attack |
| bettercap | WiFi/Bluetooth |

### Reverse Engineering
Binary analysis tools.

| Tool | Purpose |
|------|---------|
| radare2 | Binary analysis |
| ghidra | NSA decompiler |
| objdump | Binary disassembler |
| strace | System call tracer |

### Forensics
Digital forensics and analysis.

| Tool | Purpose |
|------|---------|
| autopsy | Forensic browser |
| sleuthkit | File system analysis |
| volatility | Memory forensics |
| binwalk | Firmware analysis |

### Defensive
Security monitoring and defense.

| Tool | Purpose |
|------|---------|
| lynis | Security audit |
| rkhunter | Rootkit detection |
| chkrootkit | Rootkit scanner |
| clamav | Antivirus |

## Tool Count by Category
```bash
# Count tools in each category
pacman -Qg blackarch-recon | wc -l
pacman -Qg blackarch-exploitation | wc -l
pacman -Qg blackarch-cracking | wc -l
```

## Quick Reference

### Common Commands
```bash
# Update all tools
sudo pacman -Syu

# Install category
sudo pacman -S blackarch-recon

# Install specific tool
sudo pacman -S nmap

# List installed
pacman -Q | grep blackarch
```

## Related Notes
- [[BlackArch Installation Guide]]
- [[BlackArch Audit]]
- [[BlackArch Tool Usage Cheat Sheet]]

## Tags
 #blackarch #security #tools
