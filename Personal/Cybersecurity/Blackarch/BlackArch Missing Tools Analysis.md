# BlackArch Missing Tools Analysis

## Overview
Analysis of commonly needed tools that may not be in BlackArch.

## Common Missing Tools

### Python-Based Tools
```bash
# Install via pip
pip install sqlmap
pip install dirsearch
pip install wpscan
pip install impacket
pip install pwntools
```

### Additional Recon Tools
```bash
# Install from AUR
paru -S subfinder
paru -S assetfinder
paru -S ffuf
paru -S gobuster
```

### Additional Exploitation
```bash
# Metasploit framework (may need manual setup)
paru -S metasploit

# SearchSploit
paru -S exploitdb
```

## Tools to Consider Adding

### Offensive Security
- Metasploit Framework
- Cobalt Strike (license required)
- Burp Suite Professional
- Nessus (license required)

### Enumeration
- FFUF (fast web fuzzer)
- Subfinder (subdomain finder)
- Amass (detailed enumeration)
- Naabu (fast port scanner)

### Post-Exploitation
- Mimikatz
- PowerSploit
- Empire
- Covenant

## Installation from AUR

### Common AUR Helpers
```bash
# paru (recommended)
sudo pacman -S paru

# yay
sudo pacman -S yay
```

### Install AUR Packages
```bash
paru -S burpsuite
paru -S metasploit
paru -S wpscan
```

## Alternative Tools Included

### Instead of Commercial Scanners
- OpenVAS (instead of Nessus)
- Nmap scripts (instead of specialized scanners)
- Nuclei (instead of Nuclei + commercial)

### Instead of Password Tools
- hashcat (GPU acceleration)
- john (CPU cracking)
- hydra (online attacks)

## Manual Installation

### Tools Not in Repositories
```bash
# Clone and install
git clone https://github.com/tool/tool.git
cd tool
pip install -e .
```

## Recommendations

### For Penetration Testing
1. Stick with BlackArch tools first
2. Add AUR tools as needed
3. Build custom tool collection
4. Use Docker for specialized tools

### For CTF/Competition
- Focus on common tools
- Prepare wordlists
- Set up payloads in advance

## Tags
#blackarch #tools #missing #installation
