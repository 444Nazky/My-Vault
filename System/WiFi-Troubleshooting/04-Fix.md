---
date: 2026-09-12
tags: [fix, remediation, wifi, reboot, arch-linux]
---

# 04 — Fix & Remediation

## Solution: System Reboot

After investigation determined the Intel WiFi card was in a disabled power state (PCI enable = 0, ACPI S4 disabled), a system reboot was the most appropriate first step.

## Why Reboot First?

- The device was at the **PCI level** disabled (D3cold/D4 state)
- The driver probe had timed out — restarting the driver alone would likely fail again
- ACPI power states needed to be re-initialized from scratch
- The user didn't have sudo access to forcefully re-enable PCI devices or reload drivers

## Steps Taken

### Step 1: Restart the system
```bash
# User rebooted the device
```

### Step 2: Verify PCI device enabled
```bash
cat /sys/bus/pci/devices/0000:00:14.3/enable
# Result: 1 ✓
```

### Step 3: Verify wireless interfaces
```bash
iw dev
# Result:
#   phy#0
#     Interface wlan0
#       type managed
#       addr bc:d2:2c:57:31:2c
#       ssid Gladi_ASTS6
#       channel 149 (5745 MHz), width: 80 MHz
#       txpower 22.00 dBm
# ✓
```

### Step 4: Verify rfkill
```bash
rfkill list
# Result:
#   0: ideapad_wlan: Wireless LAN (soft: no, hard: no)
#   3: phy0: Wireless LAN (soft: no, hard: no)
# ✓
```

### Step 5: Verify NetworkManager connection
```bash
nmcli device status
# Result:
#   wlan0  wifi  connected  Gladi_ASTS6
# ✓
```

### Step 6: Verify internet connectivity
```bash
ping -c 3 google.com
# Result: 0% packet loss ✓
```

## What Changed After Reboot

| Property | Before | After |
|----------|--------|-------|
| PCI enable | `0` (disabled) | `1` (enabled) |
| ACPI CNVW state | `S4 *disabled` | Active/awake |
| iwlwifi driver | Not bound | Bound to device |
| iwlmvm module | Not loaded | Loaded |
| `iw dev` output | Empty | `wlan0` present |
| `wlan0` interface | None | UP, connected |
| `rfkill` WiFi | None | `phy0` listed |
| NetworkManager | No WiFi device | Connected to Gladi_ASTS6 |

## Alternative Fixes (If Reboot Didn't Work)

### Method A: Force PCI device enable (requires root)
```bash
sudo tee /sys/bus/pci/devices/0000:00:14.3/enable <<< "1"
# Then reload driver:
sudo rmmod iwlmvm iwlwifi
sudo modprobe iwlwifi
```

### Method B: Driver override (requires root)
```bash
sudo bash -c 'echo "iwlwifi" > /sys/bus/pci/devices/0000:00:14.3/driver_override'
sudo systemctl restart systemd-modules-load
```

### Method C: Disable PCIe ASPM (requires root, GRUB config)
Edit `/etc/default/grub`:
```
GRUB_CMDLINE_LINUX_DEFAULT="pcie_aspm=off"
```
Then: `sudo grub-mkconfig -o /boot/grub/grub.cfg`

### Method D: Update firmware (requires root)
```bash
sudo pacman -Syu linux-firmware
```

### Method E: Toggle ACPI wakeup (requires root)
```bash
sudo bash -c 'echo "enabled" > /proc/acpi/wakeup'
# Or via BIOS: enable CNVW wakeup in UEFI settings
```

## Outcome

✅ WiFi fully restored — no further action needed
✅ Connected to Gladi_ASTS6 (5GHz, channel 149)
✅ Internet connectivity verified
✅ USB tethering can be disconnected if desired (WiFi works independently)
