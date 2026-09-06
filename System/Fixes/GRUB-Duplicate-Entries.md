# GRUB Duplicate Entries Fix

**Date:** 2026-09-06
**Issue:** Multiple duplicate Arch Linux entries appearing in GRUB menu
**Status:** Fixed

---

## Summary

GRUB was showing duplicate Arch Linux entries when the user only has Blackarch and Windows installed.

---

## Root Cause

BlackArch is built on top of Arch Linux. GRUB automatically detects installed Linux kernels using scripts in `/etc/grub.d/`:
- `/etc/grub.d/10_linux` - Generates generic Arch Linux entries
- BlackArch repository scripts - Adds BlackArch specific entries

This causes duplicate entries for:
1. Generic "Arch Linux" entries from 10_linux
2. "BlackArch" entries from BlackArch scripts
3. "Advanced options" submenu with fallback kernels

---

## Disk Layout

```
nvme1n1 (238.5G) - Main drive (BlackArch)
  nvme1n1p1  1G   /boot              vfat   (EFI: 0F61-907D)
  nvme1n1p2  237.5G /                btrfs

nvme0n1 (476.9G) - Secondary drive (Windows)
  nvme0n1p1  1G    vfat             (EFI: 298C-5E1B)
  nvme0n1p2  475.9G ntfs           BCB6C114B6C0CFD6

sda (57.3G) - External/Backup
  sda1  57.3G exfat  4E21-0000
  sda2  32M   vfat   EA6C-95B2 (Ventoy)
```

---

## Solution Applied

1. Disabled generic Arch entries by making 10_linux non-executable
2. Disabled os-prober to prevent duplicate Windows entries
3. Added Windows Boot Manager entry manually to 40_custom
4. Moved UEFI Firmware to bottom of menu (renamed to 41_uefi-firmware)
5. Regenerated GRUB config

---

## Result

GRUB now shows only:
1. BlackArch
2. Windows Boot Manager
3. UEFI Firmware Settings

---

## See Also

See [[GRUB-Configuration]] for full details and [[Secure-Boot-Guide]] for Secure Boot information.
