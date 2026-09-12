---
date: 2026-09-12
tags: [wifi, network, troubleshooting, arch-linux, investigation]
---

# WiFi Troubleshooting — Investigation Summary

## Incident Date
2026-09-12

## Problem Statement
User reported WiFi not working while using a USB WiFi adapter. No wireless interfaces were detected by the system. Internet connectivity was present via USB tethering.

## Files in This Investigation

| File | Description |
|------|-------------|
| [[01-Device-Inventory\|Device Inventory]] | Complete hardware inventory of USB/PCI network devices |
| [[02-Diagnosis\|Diagnosis]] | Step-by-step diagnostic process with commands and outputs |
| [[03-Root-Cause\|Root Cause Analysis]] | Technical explanation of why WiFi failed |
| [[04-Fix\|Fix & Remediation]] | Steps taken to restore WiFi |
| [[05-Lessons-Learned\|Lessons Learned]] | Takeaways and reference for future issues |

## Quick Summary
- **Main issue:** Intel WiFi AX211 PCI device in D4 power state, driver probe timed out
- **USB device misconception:** Kanata WG9 is a keyboard/mouse dongle, not WiFi
- **Internet source:** Xiaomi POCO F5 USB tethering (RNDIS)
- **Fix:** System reboot restored PCI device initialization
- **Result:** WiFi connected to `Gladi_ASTS6` (5GHz)

## Key Metrics
- PCI device enable state before: `0` (disabled)
- PCI device enable state after: `1` (enabled)
- WiFi error code: `-110` (ETIMEDOUT)
- Connection: `Gladi_ASTS6`, channel 149, 5745 MHz, 22 dBm

## Related
- [[Arch Linux System Fixes]]
- [[Troubleshooting Steps]]
