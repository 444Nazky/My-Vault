---
date: 2026-09-12
tags: [wifi, diagnosis, commands, investigation, arch-linux]
---

# 02 — Diagnosis

Step-by-step diagnostic process used to identify the WiFi issue. Each step includes commands, expected output, and interpretation.

## Phase 1: Initial Assessment — "What interfaces exist?"

### Command: List network interfaces
```bash
ip link show
```
**Result:**
- `lo`: loopback (normal)
- `enp12s0`: Ethernet, DOWN, no carrier
- `enp0s20f0u3`: USB Ethernet, UP, has IP `10.98.202.195/24`

**Finding:** No `wlan*` interface present.

### Command: Check wireless interfaces
```bash
iw dev
```
**Result:** Empty output (no wireless devices)

**Finding:** No WiFi hardware recognized by the wireless stack.

### Command: Check interface types
```bash
cat /sys/class/net/enp0s20f0u3/type
cat /sys/class/net/enp12s0/type
```
**Result:** Both return `1` (ARPHOD_ETHER = Ethernet)

**Finding:** The USB adapter is Ethernet, not WiFi.

### Command: Check NetworkManager
```bash
nmcli device status
```
**Result:**
```
enp0s20f0u3  ethernet  connected  Wired connection 2
enp12s0      ethernet  unavailable  --
lo           loopback   connected  lo
```
**Finding:** NM sees `enp0s20f0u3` as Ethernet, no WiFi device listed.

## Phase 2: Investigating the USB Device — "Is this really WiFi?"

### Command: List USB devices
```bash
lsusb
```
**Result:** Found `Bus 001 Device 002: ID 32c2:001a OM6229 Kanata Wireless WG9`

### Command: Get USB device details
```bash
lsusb -v -d 32c2:001a
```
**Result:** Both interfaces are HID devices:
- Interface 0: `bInterfaceClass 3 (HID)`, `bInterfaceProtocol 1 (Keyboard)`
- Interface 1: `bInterfaceClass 3 (HID)`, `bInterfaceProtocol 2 (Mouse)`

**Finding:** This is a wireless keyboard/mouse receiver, not WiFi.

### Command: Check driver binding
```bash
for dir in /sys/bus/usb/drivers/*/; do ls "${dir}" 2>/dev/null | grep -q "32c2" && echo "Bound to: $(basename $dir)"; done
```
**Result:** No match — device not bound to any WiFi driver.

### Command: Check modprobe aliases
```bash
modprobe -c | grep "32c2"
```
**Result:** No alias for vendor `32c2` in any WiFi driver.

**Finding:** No kernel WiFi driver claims this device.

## Phase 3: Finding the Real WiFi Hardware

### Command: List PCI network devices
```bash
lspci | grep -i wireless
```
**Result:** `00:14.3 Network controller: Intel Corporation 700 Series Chipset Family CNVi Wi-Fi`

### Command: Check driver status
```bash
lspci -k -s 00:14.3
```
**Result:**
```
Kernel modules: iwlwifi
```
**Finding:** `iwlwifi` module exists but need to check if device is bound.

### Command: Check PCI driver binding
```bash
readlink /sys/bus/pci/devices/0000:00:14.3/driver
```
**Result:** Empty (no symlink — device NOT bound to any driver)

### Command: Check PCI enable state
```bash
cat /sys/bus/pci/devices/0000:00:14.3/enable
```
**Result:** `0` (device disabled)

**Finding:** The WiFi card is powered off/disabled at PCI level.

## Phase 4: Checking Logs — "Why did it fail?"

### Command: Check kernel logs for WiFi
```bash
journalctl -b | grep -i iwlwifi | tail -30
```
**Result:**
```
iwlwifi 0000:00:14.3: CSR_RESET = 0x10
iwlwifi 0000:00:14.3: Host monitor block 0x0 vector 0x0
...
iwlwifi 0000:00:14.3: probe with driver iwlwifi failed with error -110
```
**Finding:** Driver probe timed out (-110 = ETIMEDOUT).

### Command: Check ACPI power states
```bash
cat /proc/acpi/wakeup | grep CNVW
```
**Result:** `CNVW  S4  *disabled  pci:0000:00:14.3`

**Finding:** WiFi device is in S4 (deep sleep) and disabled in ACPI.

### Command: Check rfkill
```bash
rfkill list
```
**Result:** Only `ideapad_wlan` (virtual), `ideapad_bluetooth`, `hci0` (Bluetooth). No real WiFi device listed.

**Finding:** No WiFi rfkill device = WiFi hardware not initialized.

## Phase 5: Confirming Internet Source

### Command: Check routing
```bash
ip route show
```
**Result:**
```
default via 10.98.202.171 dev enp0s20f0u3
10.98.202.0/24 dev enp0s20f0u3
```

### Command: Test connectivity
```bash
ping -c 2 8.8.8.8
```
**Result:** 2 packets transmitted, 2 received, ~47ms

### Command: Check USB driver for network device
```bash
cat /sys/bus/usb/devices/1-3:1.0/driver/uevent
```
**Result:** `DRIVER=rndis_host`

**Finding:** Internet comes from Xiaomi phone USB tethering.

## Diagnosis Summary

| Check | Result | Significance |
|-------|--------|-------------|
| `iw dev` | Empty | No WiFi interface |
| USB `32c2:001a` | HID Keyboard+Mouse | NOT a WiFi adapter |
| PCI `00:14.3` enable | `0` | WiFi card powered off |
| `iwlwifi` driver | Not bound | Driver not claiming device |
| Kernel log | `error -110` | Probe timeout |
| ACPI `CNVW` | `S4 *disabled` | Device in deep sleep |
| `rfkill list` | No WiFi device | Hardware not initialized |
| Internet via | `enp0s20f0u3` (RNDIS) | Phone tethering |
