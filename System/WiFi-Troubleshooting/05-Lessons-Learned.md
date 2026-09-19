---
date: 2026-09-12
tags: [lessons, reference, troubleshooting, wifi, best-practices, arch-linux]
---

# 05 — Lessons Learned

Key takeaways from this WiFi troubleshooting session for future reference.

## 1. Not Every USB "WiFi" Is WiFi

**Problem:** Assumed USB device was WiFi adapter based on user's claim.

**Lesson:** Always verify with `lsusb -v` and check interface classes:
- Real WiFi over USB: uses `rndis_host`, `cdc_ether`, `rt2800usb`, `rtl8xxxu`, `mt7601u`, etc.
- HID device: `bInterfaceClass 3` with keyboard/mouse protocols — NOT WiFi

**Future check:**
```bash
lsusb -v -d <vendor>:<product> | grep -E "Interface Class|Interface Protocol"
```

## 2. PCI Device `enable: 0` Is a Red Flag

**Problem:** WiFi card had `enable: 0` in sysfs — completely disabled.

**Lesson:** When a PCI device shows `enable: 0`:
- Check `dmesg`/`journalctl` for probe failures
- Check ACPI wakeup table for the device's state
- A reboot may fix it if it was just a power state issue
- If reboot doesn't fix it, it may be a hardware or firmware issue

**Quick check:**
```bash
cat /sys/bus/pci/devices/<addr>/enable
```

## 3. `iwlwifi` Probe Timeout Has Known Causes

**Problem:** `probe with driver iwlwifi failed with error -110`

**Common causes (in order of likelihood):**
1. Device in D3cold/D4 power state (PCI disabled)
2. Firmware not found or corrupted (check `/lib/firmware/intel/iwlwifi/`)
3. ACPI wakeup disabled in BIOS
4. PCIe link issues (ASPIM, lane negotiation)
5. Actual hardware failure (least likely)

**Diagnostic sequence:**
```bash
dmesg | grep iwlwifi          # Check for errors
journalctl | grep iwlwifi     # More detailed logs
cat /sys/bus/pci/devices/0000:00:14.3/enable  # PCI enabled?
ls /lib/firmware/intel/iwlwifi/ | grep ax     # Firmware present?
cat /proc/acpi/wakeup | grep CNVW            # ACPI wakeup enabled?
```

## 4. USB Tethering Can Mask WiFi Issues

**Problem:** User had internet the whole time (via phone tethering) but thought WiFi was broken because they expected it through the USB device.

**Lesson:** Always check ALL network interfaces before declaring WiFi broken:
```bash
ip route show          # Where is traffic going?
ping 8.8.8.8          # Does internet work at all?
ip addr show           # What interfaces have IPs?
nmcli device status    # What devices are connected?
```

## 5. Reboot Is a Valid First Step

**Problem:** Initially tried complex troubleshooting (driver reload, PCI re-enablement) without sudo access.

**Lesson:** For power-state issues, a reboot:
- Re-initializes all PCI devices from scratch
- Re-runs driver probes in correct order
- Resets ACPI power states
- Often fixes issues that seem complex but are just stale power states

**Rule of thumb:** If `enable: 0` or D4 state is the issue, reboot first. If that fails, then dig deeper.

## 6. Arch Linux Specifics

- WiFi firmware is in `linux-firmware` package (not `iwlwifi-firmware` like some distros)
- `iwlmvm` is the mVM driver for modern Intel WiFi (AX200+, 700 series)
- `iwlwifi` is the core driver, `iwlmvm` interfaces with hardware
- Check `modprobe -c | grep <pci_id>` to find which driver a device needs
- NetworkManager with `iwd` is the default WiFi stack on Arch

## 7. User Environment Awareness

**Context matters:** This is a laptop (ThinkPad X1 Carbon based on Intel 700 Series CNVi) used in multiple environments:
- Home WiFi (Gladi_ASTS6 network and multiple others saved in NM)
- USB tethering from phone (POCO F5)
- Various school/institution networks (SISWA_PENUS, TKA 20, LAB_RPL_2, etc.)

**Future investigation should consider:**
- Is WiFi consistently failing after sleep/suspend, or only on cold boot?
- Does the BIOS need a firmware update for better power management?
- Should PCIe ASPM be disabled in GRUB for stability?
