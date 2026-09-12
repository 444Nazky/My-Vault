---
date: 2026-09-12
tags: [wifi, hardware, usb, pci, inventory, investigation]
---

# 01 — Device Inventory

Complete hardware inventory of all network-related devices found during investigation.

## PCI Devices (Network)

### Intel 700 Series CNVi Wi-Fi (AX211)
- **PCI Address:** `00:14.3`
- **PCI ID:** `8086:7A70`
- **Subsystem:** `8086:0274`
- **IRQ:** 18
- **Memory:** `6205134000` (16K)
- **Driver Module:** `iwlwifi` (listed in kernel modules)
- **Driver Binding:** NOT bound (driver symlink was empty)
- **PCI Enable:** `0` (disabled)
- **Power State:** D4 (device disabled)
- **ACPI State:** S4 (sleep), disabled
- **ACPI Wakeup Entry:** `CNVW S4 *disabled`
- **Firmware:** `iwlwifi-ty-a0-gf-a0.pnvm` and `iwlwifi-ty-a0-gf-a0-89.ucode` (in `/lib/firmware/intel/iwlwifi/`)
- **Status:** Probe failed with timeout

### Realtek RTL8111/8168/8211/8411 (Gigabit Ethernet)
- **PCI Address:** `0c:00.0`
- **Interface:** `enp12s0`
- **Status:** DOWN (no cable / NO-CARRIER)
- **MAC:** `a8:2b:dd:e6:eb:fb`
- **MTU:** 1500

## USB Devices (Network-Related)

### Kanata Wireless WG9 (`32c2:001a`)
- **Bus:** `001 Device 002`
- **USB Port:** `1-4` (USB 1.1, Full Speed 12Mbps)
- **bcdUSB:** 1.10
- **Interfaces:** 2
  - Interface 0: HID, Boot Interface, Keyboard (Protocol 1), EP 1 IN (interrupt, 8 bytes)
  - Interface 1: HID, Boot Interface, Mouse (Protocol 2)
- **Power:** 100mA, Bus Powered
- **Serial:** `No.098-0001-1`
- **Driver:** `usbhid` (bound to USB HID driver, not a WiFi driver)
- **Actual Purpose:** Wireless keyboard/mouse receiver — **NOT WiFi**

### Xiaomi POCO F5 (`2717:ff88`)
- **Bus:** `001 Device 008`
- **USB Port:** `1-3` (USB 2.0, High Speed)
- **Interfaces:** 3 (+ Interface Association for RNDIS)
  - Interface Association: RNDIS (Miscellaneous Device, Class 239)
  - Interface 0: RNDIS Communications Control (Class 239)
  - Interface 1: RNDIS Ethernet Data (Class 10, CDC Data)
  - Interface 2: ADB Interface (Miscellaneous)
- **Driver:** `rndis_host` (bound)
- **Network Interface:** `enp0s20f0u3`
- **IP:** `10.98.202.195/24` (DHCP, dynamic)
- **MAC:** `b2:3b:39:cb:79:59` (locally administered)
- **Gateway:** `10.98.202.171`
- **Status:** Connected, internet OK (ping 8.8.8.8: ~47ms)

### Other USB Devices (Non-Network)
| Device | ID | Purpose |
|--------|----|---------|
| ITE Device(8258) | `048d:c195` | Another HID device (keyboard) |
| Chicony Camera | `04f2:b828` | Integrated camera |
| Xbox360 Controller | `045e:028e` | Gaming controller |
| Intel AX201 Bluetooth | `8087:0026` | Bluetooth adapter |

## Network Interfaces Summary

| Interface | Type | State | IP | Driver | Notes |
|-----------|------|-------|----|--------|-------|
| `lo` | loopback | UP | 127.0.0.1/8 | — | Standard |
| `enp12s0` | PCI Ethernet | DOWN | — | Realtek | No carrier |
| `enp0s20f0u3` | USB RNDIS | UP | 10.98.202.195/24 | rndis_host | Phone tethering |
| `wlan0` | WiFi (after reboot) | UP | DHCP | iwlwifi | Connected to Gladi_ASTS6 |
| `p2p-dev-wlan0` | WiFi P2P | DOWN | — | iwlwifi | Created by iwd |

## Key Discovery

The Kanata Wireless WG9 (`32c2:001a`) is **not a WiFi adapter**. It has only HID interfaces (keyboard + mouse). Any WiFi connectivity must come from either:
1. The built-in Intel WiFi card (PCI)
2. USB network tethering (RNDIS from phone)
3. A different USB device not initially identified
