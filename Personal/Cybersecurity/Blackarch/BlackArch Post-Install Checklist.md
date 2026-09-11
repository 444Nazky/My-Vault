# BlackArch Post-Install Checklist

## Overview
Post-installation checklist for BlackArch Linux.

## System Update

### Update Package Database
```bash
sudo pacman -Syy
sudo pacman -Syu
```

### Update BlackArch
```bash
sudo blackarch-update
```

## Essential Tools

### Network Tools
```bash
sudo pacman -S networkmanager network-manager-applet
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
```

### Basic Utilities
```bash
sudo pacman -S vim git curl wget htop neofetch
sudo pacman -S base-devel
```

### Development Tools
```bash
sudo pacman -S python python-pip ruby
sudo pacman -S gcc make cmake
```

## Tool Verification

### Verify Installation
```bash
# Check main tools
nmap --version
sqlmap --version
nikto -Version
metasploit --version
```

### Quick Test
```bash
# Nmap
nmap -sn 127.0.0.1

# Check wordlists
ls /usr/share/wordlists/
```

## Configuration

### Git Configuration
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### Editor Setup
```bash
# Vim configuration
cat > ~/.vimrc << 'EOF'
syntax on
set number
set tabstop=4
set shiftwidth=4
EOF
```

### Shell Configuration
```bash
# Add to ~/.bashrc or ~/.zshrc
export EDITOR=vim
export VISUAL=vim
```

## Python Environment

### Virtual Environment
```bash
python -m venv pentest
source pentest/bin/activate

# Install common tools
pip install sqlmap
pip install dirsearch
pip install impacket
pip install pwntools
```

## Wordlists

### Essential Wordlists
```bash
# Check existing
ls /usr/share/wordlists/

# Install additional
sudo pacman -S wordlist
sudo pacman -S seclists

# Create custom directory list
mkdir -p ~/wordlists
```

## Documentation

### Important Paths
```
/usr/share/doc/blackarch/  # Documentation
/etc/blackarch/           # Configuration
/usr/share/blackarch/     # Data files
```

## Security Configuration

### Firewall (Optional)
```bash
sudo pacman -S ufw
sudo ufw enable
sudo ufw default deny
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

### Disable Unnecessary Services
```bash
# List services
systemctl list-units --type=service

# Disable unused
sudo systemctl disable cupslld
sudo systemctl mask postgresql
```

## Virtualization (Optional)

### VirtualBox
```bash
sudo pacman -S virtualbox linux-headers
sudo modprobe vboxdrv
```

### Docker
```bash
sudo pacman -S docker
sudo systemctl enable docker
sudo systemctl start docker
```

## Troubleshooting Setup

### Common Issues
```bash
# Key issues
sudo pacman-key --init
sudo pacman-key --populate archlinux

# Mirror issues
sudo pacman-mirrors -f 5
```

## Final Verification

### Tool List
- [ ] nmap
- [ ] sqlmap
- [ ] nikto
- [ ] metasploit
- [ ] hashcat
- [ ] john
- [ ] burpsuite
- [ ] aircrack-ng
- [ ] wireshark
- [ ] nuclei

## Tags
 #blackarch #checklist
