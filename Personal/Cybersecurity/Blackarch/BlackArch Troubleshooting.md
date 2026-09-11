# BlackArch Troubleshooting

## Overview
Common issues and solutions for BlackArch Linux.

## Pacman Issues

### Signature Verification Failed
```bash
# Refresh keys
sudo pacman-key --refresh-keys

# Reset database
sudo rm -rf /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --populate blackarch
```

### Database Lock
```bash
sudo rm /var/lib/pacman/db.lck
```

### Partial Upgrade
```bash
sudo pacman -Syu
```

## BlackArch-Specific Issues

### Tool Not Found
```bash
# Update package database
sudo pacman -Syy

# Search for tool
pacman -Ss nmap

# Install tool
sudo pacman -S nmap
```

### Repository Not Found
```bash
# Check /etc/pacman.conf
cat /etc/pacman.conf | grep -A 5 blackarch

# Re-run strap
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh
```

## Tool-Specific Issues

### Nmap Script Errors
```bash
# Update scripts
nmap --script-updatedb

# Run specific script
nmap --script=vuln target.com
```

### Metasploit Database
```bash
# Start database
msfdb start

# Check status
msfdb status

# Reinit if needed
msfdb init
```

### SQLMap Errors
```bash
# Update
sqlmap --update

# Check dependencies
pip install -r requirements.txt
```

## Python Tool Issues

### pip Errors
```bash
# Update pip
pip install --upgrade pip

# Install without cache
pip install --no-cache-dir package

# Use virtual environment
python -m venv env
source env/bin/activate
```

### Import Errors
```bash
# Check Python version
python --version

# Install dependencies
pip install -r requirements.txt

# Try with Python 3
python3 script.py
```

## Network Issues

### Internet Not Working
```bash
# Check interface
ip link show

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Check DNS
cat /etc/resolv.conf
ping -c 3 google.com
```

### Tool Cannot Connect
```bash
# Check proxy settings
env | grep proxy

# Test connection
curl -I http://target.com

# Disable proxy
unset http_proxy https_proxy
```

## Wireless Tools

### Airmon-ng Issues
```bash
# Kill conflicting processes
airmon-ng check kill

# Check driver support
airmon-ng

# Interface not showing
modprobe <driver_name>
```

### Wireshark
```bash
# Add user to wireshark group
sudo gpasswd -a $USER wireshark

# Log out and back in
# Or run as sudo (not recommended)
```

## Performance Issues

### Slow Scanning
```bash
# Increase threads in nmap
nmap -sV target.com --max-parallelism 10

# Use faster scanner
masscan target.com -p0-65535
```

### Memory Issues
```bash
# Check available memory
free -h

# Increase swap
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

## Docker Issues

### Docker Not Starting
```bash
# Check status
sudo systemctl status docker

# Enable in boot
sudo systemctl enable docker

# Add user to docker group
sudo gpasswd -a $USER docker
newgrp docker
```

## Getting Help

### Tool Help
```bash
# Tool --help
nmap --help

# Manual page
man nmap

# In-tool help
msfconsole
help
```

### Online Resources
- BlackArch official docs
- Arch Wiki
- Tool-specific documentation

## Tags
 #blackarch #troubleshooting
