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

### WiFi Driver Timeout (Intel AX211 / iwlwifi)
- **Symptom:** `iw dev` returns nothing, no `wlan` interface, `iwlwifi` probe fails with `error -110` (ETIMEDOUT)
- **Cause:** PCI device left in disabled/off state (D4/S4), `enable: 0` in sysfs, ACPI CNVW disabled
- **Fix:** Reboot the system — restores proper PCI device initialization
- **Diagnosis commands:**
  ```bash
  cat /sys/bus/pci/devices/0000:00:14.3/enable  # check if 0 = disabled
  journalctl -b | grep iwlwifi                  # check for probe timeout
  iw dev                                        # check for wireless interfaces
  rfkill list                                   # check rfkill blocks
  acpi -t                                       # check thermal/wake states (CNVW)
  ```
- **Key logs:** `probe with driver iwlwifi failed with error -110`

## Related Notes

- [[../System/WiFi Troubleshooting/00-Overview\|WiFi Troubleshooting Overview]] — Full investigation of WiFi fix (2026-09-12)
- [[../System/WiFi Troubleshooting/01-Device-Inventory\|Device Inventory]] — Hardware inventory
- [[../System/WiFi Troubleshooting/02-Diagnosis\|Diagnostic steps]]
- [[../System/WiFi Troubleshooting/03-Root-Cause\|Why WiFi failed]]
- [[../System/WiFi Troubleshooting/04-Fix\|How it was fixed]]
- [[../System/WiFi Troubleshooting/05-Lessons-Learned\|Takeaways]]
- [[../System/WiFi Troubleshooting/06-Quick-Reference\|Command cheat sheet]]

### USB WiFi Adapter Misidentification
- Some USB devices advertised as "WiFi adapters" are actually wireless HID devices (keyboard/mouse receivers)
- **Check:** `lsusb -v -d <vendor>:<product>` — look for `HID Device`, `Keyboard`, `Mouse` in interface classes
- A real WiFi adapter over USB uses `rndis_host`, `cdc_ether`, or dedicated WiFi drivers (e.g., `rt2800usb`, `rtl8xxxu`)
- **Example:** Kanata Wireless WG9 (32c2:001a) = wireless keyboard/mouse, NOT WiFi

## Tags
 #fix #system #troubleshooting
