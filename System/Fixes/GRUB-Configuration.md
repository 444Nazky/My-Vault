# GRUB Configuration Fix

**Date:** 2026-09-06
**System:** BlackArch Linux + Windows Dual Boot
**Status:** Fixed

---

## Summary

Cleaned up GRUB menu to show only:
- BlackArch Linux
- Windows Boot Manager
- UEFI Firmware Settings

Removed duplicate entries and organized menu order.

---

## Disk Layout

| Drive | Partition | Size | Content | UUID |
|-------|----------|------|---------|------|
| nvme1n1 | nvme1n1p1 | 1G | EFI | 0F61-907D |
| nvme1n1 | nvme1n1p2 | 237.5G | BlackArch (btrfs) | 67fde82c-... |
| nvme0n1 | nvme0n1p1 | 1G | Windows EFI | 298C-5E1B |
| nvme0n1 | nvme0n1p2 | 475.9G | Windows | BCB6C114... |

---

## Issues Fixed

### 1. Duplicate Arch Linux Entries
BlackArch built on Arch Linux caused `/etc/grub.d/10_linux` to generate generic Arch entries alongside BlackArch entries.

**Fix:** Disabled 10_linux script
```bash
sudo chmod -x /etc/grub.d/10_linux
```

### 2. Duplicate Windows Entries
os-prober detected multiple Windows boot stubs (bootloader + recovery partitions).

**Fix:** Disabled os-prober and added custom Windows entry.

### 3. UEFI Firmware at Top
UEFI Firmware Settings appeared at the top of GRUB menu.

**Fix:** Renamed script to run last
```bash
sudo mv /etc/grub.d/30_uefi-firmware /etc/grub.d/41_uefi-firmware
```

---

## GRUB Script Order

| Script | Purpose | Executable |
|--------|---------|------------|
| 10_linux | Arch entries | Disabled |
| 20_linux_xen | Xen kernel | Yes |
| 30_os-prober | Auto-detect OS | Yes |
| 40_custom | Windows entry | Yes |
| 41_uefi-firmware | UEFI settings | Yes |

---

## Files Modified

| File | Change |
|------|--------|
| `/etc/default/grub` | Set GRUB_DISABLE_OS_PROBER=true |
| `/etc/grub.d/10_linux` | chmod -x (disabled) |
| `/etc/grub.d/40_custom` | Added Windows Boot Manager entry |
| `/etc/grub.d/30_uefi-firmware` | Renamed to 41_uefi-firmware |

---

## Next Steps

Run after any GRUB change:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## See Also

- [[GRUB-Duplicate-Entries-Fix-Commands]] - Detailed fix commands
- [[Secure-Boot-Guide]] - Secure Boot considerations for gaming

## Tags
#note-grub-configuration
