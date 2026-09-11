# Arch Linux System Fixes

## Overview
Common issues and fixes for Arch Linux system administration.

## Network Issues

### WiFi Not Connecting
- Check NetworkManager status: `systemctl status NetworkManager`
- Restart service: `sudo systemctl restart NetworkManager`
- Check WiFi interfaces: `ip link show`
- Verify credentials in `/etc/NetworkManager/system-connections/`

### Ethernet Not Detected
- Check driver: `lspci -k | grep -A 3 Ethernet`
- Load driver manually: `modprobe <driver_name>`
- Check DHCP: `dhcpcd <interface>`

## Graphics Issues

### NVIDIA Driver Problems
- Check GPU: `lspci | grep -i vga`
- Install drivers:
  ```bash
  sudo pacman -S nvidia nvidia-utils
  ```
- Configure `/etc/mkinitcpio.conf`: Add `nvidia` to MODULES
- Regenerate initramfs: `sudo mkinitcpio -P`

### Screen Tearing
- Enable sync in compositor
- Set environment variable: `KWIN_DRM_DEVICE` for NVIDIA

## Package Manager Issues

### Pacman Database Lock
- Remove lock: `sudo rm /var/lib/pacman/db.lck`
- Kill stale pacman process: `sudo killall pacman`

### Failed Package Signature
- Refresh keys: `sudo pacman-key --refresh-keys`
- Update keyring: `sudo pacman -S archlinux-keyring`

## Audio Issues

### No Sound Output
- Check PulseAudio: `pulseaudio --check`
- Restart PulseAudio: `pulseaudio -k`
- Check ALSA: `alsamixer`
- Unmute with `M` key

### Bluetooth Audio
- Install: `sudo pacman -S pulseaudio-bluetooth`
- Restart: `systemctl restart bluetooth`

## System Performance

### High Memory Usage
- Check processes: `ps aux --sort=-%mem | head`
- Clear cache: `echo 3 | sudo tee /proc/sys/vm/drop_caches`
- Check swap: `swapon --show`

### Slow Boot
- Analyze boot time: `systemd-analyze blame`
- Disable unnecessary services
- Enable parallel loading

## Orphaned Packages
```bash
# List orphans
sudo pacman -Qtdq

# Remove orphans
sudo pacman -Rns $(pacman -Qtdq)
```

## Tags
#archlinux #troubleshooting #system #fix
