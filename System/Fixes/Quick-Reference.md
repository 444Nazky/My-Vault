# System Fixes - Quick Reference Card

**Date:** 2026-09-06
**System:** BlackArch + Hyprland + NVIDIA RTX 5050

---

## NVIDIA Fix - One Liner

```bash
# Fix DKMS, reinstall driver, load module
sudo rm -rf /var/lib/dkms/nvidia
sudo pacman -S nvidia-open-dkms --overwrite "*"
sudo dkms install nvidia/610.57.04
sudo modprobe nvidia
nvidia-smi
```

---

## GRUB Fix - One Liner

```bash
# Disable duplicates, add Windows, reorder menu
sudo chmod -x /etc/grub.d/10_linux
sudo sed -i 's/GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=true/' /etc/default/grub
sudo mv /etc/grub.d/30_uefi-firmware /etc/grub.d/41_uefi-firmware
sudo nano /etc/grub.d/40_custom  # Add Windows Boot Manager entry
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## ASCII: Boot Menu Before/After

### BEFORE
```
UEFI Firmware Settings
Arch Linux
Arch Linux
Advanced options > Arch Linux
BlackArch
Windows
Windows
```

### AFTER
```
BlackArch
BlackArch (fallback)
Windows Boot Manager
UEFI Firmware Settings
```

---

## ASCII: NVIDIA Driver Status

### CHECK
```
nvidia-smi                          # Check GPU
lsmod | grep nvidia                # Check module loaded
dkms status                         # Check DKMS build
```

### OUTPUT
```
+------------------------------------------+
| NVIDIA-SMI 610.57.04       Driver OK     |
| GPU: NVIDIA GeForce RTX 5050 / Mobile    |
+------------------------------------------+
```

---

## ASCII: Disk Layout

```
nvme1n1 (238.5G)                    nvme0n1 (476.9G)
+------------------+                   +------------------+
| EFI (0F61-907D) |                   | EFI (298C-5E1B) |
+------------------+                   +------------------+
| btrfs (BlackArch)|                   | NTFS (Windows)   |
|    237.5G       |                   |    475.9G        |
+------------------+                   +------------------+
```

---

## ASCII: Config Files Modified

```
~/.config/hypr/hyprland/
├── env.lua          [MODIFIED] NVIDIA vars added
├── variables.lua    [KEPT]    User preferences
└── ...

/etc/
├── default/grub      [MODIFIED] os-prober disabled
├── mkinitcpio.conf  [MODIFIED] nvidia modules
└── grub.d/
    ├── 10_linux     [DISABLED] chmod -x
    ├── 40_custom    [MODIFIED] Windows entry
    └── 41_uefi-firmware [RENAMED] was 30_*
```

---

## Commands Reference

| Task | Command |
|------|---------|
| Check GPU | `nvidia-smi` |
| Check module | `lsmod \| grep nvidia` |
| Load module | `sudo modprobe nvidia` |
| Rebuild initramfs | `sudo mkinitcpio -P` |
| Update GRUB | `sudo grub-mkconfig -o /boot/grub/grub.cfg` |
| Check Secure Boot | `mokutil --sb-state` |

---

## Verification Checklist

- [x] NVIDIA driver loads
- [x] nvidia-smi works
- [x] env.lua has NVIDIA vars
- [x] mkinitcpio has nvidia modules
- [x] GRUB no duplicate entries
- [x] Windows Boot Manager in GRUB
- [x] UEFI at bottom of menu

---

## See Also

- [[System/Fixes/Visual-Guides]] - Visual diagrams
- [[System/System-Architecture]] - System overview
- [[System/Fixes/NVIDIA-RTX-5050-Investigation]] - Full NVIDIA doc
- [[System/Fixes/GRUB-Configuration]] - Full GRUB doc

## Tags
#note-quick-reference
