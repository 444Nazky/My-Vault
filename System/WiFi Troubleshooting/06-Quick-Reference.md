---
date: 2026-09-12
tags: [reference, commands, wifi, network, quick-reference]
---

# WiFi Quick Reference

A collection of commands useful for diagnosing and fixing WiFi issues on Arch Linux.

## Check WiFi Status
```bash
iw dev                          # List wireless devices
iw dev wlan0 info               # Details of specific WiFi device
rfkill list                     # Check WiFi blocks
nmcli device status             # NetworkManager device status
ip link show wlan0              # WiFi interface state
```

## Check PCI Device Status
```bash
lspci | grep -i wireless         # Find WiFi PCI devices
lspci -k -s <addr>               # Driver info for device
cat /sys/bus/pci/devices/0000:<addr>/enable  # PCI enabled?
readlink /sys/bus/pci/devices/0000:<addr>/driver  # Driver bound?
```

## Check Kernel Logs
```bash
journalctl -b | grep iwlwifi     # iwlwifi messages
dmesg | grep -i wifi             # Kernel WiFi messages
journalctl -b | grep -E "probe.*failed"  # Failed probes
```

## Check ACPI States
```bash
cat /proc/acpi/wakeup | grep CNVW  # WiFi ACPI state
cat /sys/bus/pci/devices/0000:00:14.3/power/state  # Power state
```

## Check USB Device Classes
```bash
lsusb -v -d <vendor>:<product> | grep -E "Class|Protocol"
# Class 3 = HID (keyboard/mouse) → NOT WiFi
# Class 0/2/10 = Network → could be WiFi/RNDIS/Ethernet
```

## Fix WiFi (Root Required)
```bash
# Force PCI enable
echo "1" | sudo tee /sys/bus/pci/devices/0000:00:14.3/enable

# Reload WiFi driver
sudo rmmod iwlmvm iwlwifi && sudo modprobe iwlwifi

# Unblock WiFi
sudo rfkill unblock wifi

# Update firmware
sudo pacman -Syu linux-firmware

# Restart network services
sudo systemctl restart iwd NetworkManager
```

## Check for Misidentified Devices
```bash
lsusb                    # List all USB devices
lsusb -v -d <vendor>:<product>  # Check if device is HID vs network
modprobe -c | grep <vendor_id>  # Check which driver handles device
```

## Network Verification
```bash
ping -c 4 google.com         # Internet connectivity
ip route show                # Check default route
curl ifconfig.me              # External IP check
nmcli device show wlan0       # Detailed WiFi device info
```
