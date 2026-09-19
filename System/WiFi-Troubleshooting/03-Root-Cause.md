---
date: 2026-09-12
tags: [root-cause, wifi, iwlwifi, intel, power-management, arch-linux]
---

# 03 — Root Cause Analysis

Technical explanation of why the WiFi failed.

## Primary Cause: Intel WiFi Card in D4 Power State

The Intel WiFi 6 AX211 (`8086:7A70`) PCI Express device was in an entirely **powered-down state** at multiple levels:

### Level 1: PCI Device Disabled
```
/sys/bus/pci/devices/0000:00:14.3/enable → 0
```
- Value `0` means the PCI device is **not enabled** in the PCI configuration space
- The device cannot respond to any MMIO or IO operations when disabled
- Usually set when the OS puts the device in **D3cold** (completely powered off)

### Level 2: ACPI Power State S4
```
/proc/acpi/wakeup → CNVW  S4  *disabled  pci:0000:00:14.3
```
- **CNVW** = CNVi Wi-Fi (the internal name for Intel's WiFi+Bluetooth combo)
- **S4** = device is in sleep state (low power)
- **\*disabled** = wakeup from this state is disabled in BIOS/firmware
- This means the firmware doesn't allow the OS to wake the device from S4

### Level 3: Driver Probe Timeout
```
kernel: iwlwifi 0000:00:14.3: probe with driver iwlwifi failed with error -110
```
- **Error -110** = `ETIMEDOUT` in Linux kernel errno
- The `iwlwifi` driver loaded successfully but could not communicate with the hardware during `probe()`
- Without a responding hardware device, the driver times out waiting for firmware/register reads
- The kernel marks the device as failed and does not create any network interface

### Level 4: No Wireless Stack Initialization
Because `iwlwifi` failed:
- `iwlmvm` (the modern Intel WiFi mVM driver) was not loaded
- No `phy0` wireless device was created
- No `wlan0` interface was spawned
- `cfg80211`/`mac80211` stack has no WiFi PHY to work with
- NetworkManager has no WiFi device to manage
- `rfkill` has no WiFi device to track

## Why Did This Happen?

### Probable Scenario
1. **Previous session ended abnormally** — the OS put the WiFi device into D3cold/D4 without proper shutdown sequence
2. **PCI power state was not restored on boot** — the kernel did not re-enable the device on next boot
3. **Driver probe timed out** — since the device was still in a low-power state, it couldn't respond to the driver's initialization sequence
4. **ACPI wakeup disabled** — the BIOS setting for CNVW wakeup was disabled, preventing the OS from waking the device

### Contributing Factors
- **USB tethering was active** — the Xiaomi phone was providing internet via RNDIS, so the user didn't notice WiFi was down
- **The USB device was misidentified** — the Kanata WG9 was plugged in and assumed to be the WiFi adapter, but it's actually a HID device
- **No `iwlmvm` module loaded** — only `iwlwifi` was loaded, which is the core driver, but `iwlmvm` (the actual hardware interface) was not

## Was This a Hardware Problem?

**Likely NO.** Evidence suggests this was a **software/power management issue**:

1. After a **system reboot**, the device was properly detected and initialized
2. PCI status register read `0x0010` (IO space enabled, device responding)
3. The `iwlwifi` driver successfully probed and created `wlan0`
4. All firmware loaded correctly
5. WiFi connected to access point with full functionality

If it were a hardware failure (dead card, damaged antenna, etc.), a reboot would not have fixed it.

## Was the USB Device Related?

**No.** The Kanata WG9 (`32c2:001a`) is a USB HID device (keyboard + mouse). It shares no hardware resources with the Intel WiFi card and has no ability to affect PCI device power states.

## Potential Recurrence Prevention

1. **Ensure ACPI wakeup is enabled** in BIOS/UEFI for CNVW
2. **Check BIOS power management settings** — USB selective suspend, PCIe ASPM, etc.
3. **Avoid force-shutdowns** which can leave devices in bad power states
4. **Update BIOS/firmware** if the laptop manufacturer has fixes for power management
5. **Install latest `linux-firmware`** package for proper iwlwifi firmware support
