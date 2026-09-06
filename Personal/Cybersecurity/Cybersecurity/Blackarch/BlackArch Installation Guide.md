# BlackArch Installation Guide

## Overview
Complete guide to installing BlackArch Linux or using BlackArch tools on Arch.

## Option 1: Full BlackArch ISO

### Download
```bash
# From official site
wget https://blackarch.org/blackarch/iso/blackarch-linux-full-2023.01.01-x86_64.iso
```

### Installation
1. Create bootable USB with Balena Etcher or dd
2. Boot from USB
3. Follow Arch installer
4. BlackArch tools pre-installed

## Option 2: BlackArch Repository (on existing Arch)

### Add Repository
```bash
# As root user
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
./strap.sh
```

### Update System
```bash
sudo pacman -Syu
```

### Verify Installation
```bash
pacman-key --list-keys | grep BlackArch
pacman -Syy
```

## Tool Installation

### All Tools
```bash
sudo pacman -S blackarch
```

### By Category
```bash
# Reconnaissance
sudo pacman -S blackarch-recon

# Exploitation
sudo pacman -S blackarch-exploitation

# Forensics
sudo pacman -S blackarch-forensic

# Password attacks
sudo pacman -S blackarch-cracking

# Networking
sudo pacman -S blackarch-networking

# Web application
sudo pacman -S blackarch-webapp

# Reverse engineering
sudo pacman -S blackarch-reversing

# Defense
sudo pacman -S blackarch-defensive
```

### Individual Tools
```bash
# Common tools
sudo pacman -S nmap sqlmap nikto metasploit hydra john hashcat burpsuite
sudo pacman -S aircrack-ng wireshark tcpdump masscan
```

## Configuration

### Network Setup
```bash
# Start NetworkManager
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
```

### Tool Configuration
```bash
# Set up wordlists
ls /usr/share/wordlists/

# Configure proxy (optional)
export http_proxy="http://127.0.0.1:8080"
export https_proxy="http://127.0.0.1:8080"
```

## Post-Installation

### Essential Setup
```bash
# Update tools
sudo pacman -Syu

# Install common dependencies
sudo pacman -S python python-pip ruby git

# Set up virtual environment for Python tools
python -m venv pentest-venv
source pentest-venv/bin/activate
```

### Verify Tools
```bash
# Check installed tools
pacman -Q | grep -i nmap
pacman -Q | grep -i sqlmap

# Test basic functionality
nmap --version
sqlmap --version
```

## Troubleshooting

### Key Issues
```bash
# Refresh keys
sudo pacman-key --refresh-keys

# Reset keys
sudo rm -rf /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman-key --populate archlinux
```

### Mirror Issues
```bash
# Edit /etc/pacman.conf
# Add BlackArch mirror
[blackarch]
Server = https://www.mirrorservice.org/sites/blackarch.org/blackarch/$repo/$arch
```

## Usage Examples

### Quick Tool List
```bash
# List available tools
pacman -Sg | grep blackarch | head -50

# Search for tool
pacman -Ss nmap
```

## Tags
#blackarch #installation #linux #security
