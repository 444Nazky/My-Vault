# NVIDIA RTX 5050 - Fixed

**Date:** 2026-09-06
**GPU:** NVIDIA GeForce RTX 5050 Max-Q / Mobile
**Status:** FIXED

---

## Hardware Detection

GPU IS detected by PCI:
```
01:00.0 VGA compatible controller: NVIDIA Corporation GB207M [GeForce RTX 5050 Max-Q / Mobile] (rev a1)
```

DRI devices exist:
```
/dev/dri/card1
/dev/dri/renderD128
```

---

## Fix Applied (2026-09-06)

### Root Cause
DKMS source directory was corrupted/broken, preventing nvidia kernel module from building.

### Solution
1. Removed broken DKMS directory: `sudo rm -rf /var/lib/dkms/nvidia`
2. Reinstalled driver: `sudo pacman -S nvidia-open-dkms --overwrite "*"`
3. Built module: `sudo dkms install nvidia/610.57.04`
4. Loaded module: `sudo modprobe nvidia`

### Configuration Updated
Added NVIDIA environment variables to:
- `~/.config/hypr/hyprland/env.lua`
- `~/.config/caelestia/hypr/hyprland/env.lua`

```lua
-- NVIDIA/DRM
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVIDIA_VISIBLE_DEVICES", "GPU-0")
hl.env("NVIDIA_DRIVER_CAPABILITIES", "all")
```

### Pending Steps
- Update `/etc/mkinitcpio.conf` MODULES to include nvidia modules
- Regenerate initramfs: `sudo mkinitcpio -P`
- Reboot

### Verification
```
$ nvidia-smi
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 610.57.04       Driver Version: 610.57.04   CUDA UMD Version: 13.3 |
| GPU  Name                   Persistence-M | Bus-Id    Disp.A | Volatile ECC |
|   0  NVIDIA GeForce RTX 5050 ...    Off | 00000000:01:00.0 Off |        N/A |
+-----------------------------------------------------------------------------+
```

---

---

## Original Issues Found (Before Fix)

### 1. NVIDIA Kernel Module Not Loaded

```bash
$ lsmod | grep nvidia
# No output - nvidia module not loaded

$ modinfo nvidia
modinfo: ERROR: Module nvidia not found.
```

The main `nvidia` kernel module is missing/not built.

### 2. nvidia-open-dkms Not Built

Installed packages:
```
local/nvidia-open-dkms 610.57.04-1
local/lib32-nvidia-utils 610.57.04-1
local/linux-firmware-nvidia 20260810-2
```

But DKMS shows no modules built:
```bash
$ dkms status
# No output
```

### 3. Missing NVIDIA Environment Variables

Current `env.lua` lacks NVIDIA-specific Wayland settings:
- No `NVIDIA_VISIBLE_DEVICES`
- No `NVIDIA_DRIVER_CAPABILITIES`
- No `GBM_BACKEND=nvidia-drm`
- No `__GLX_VENDOR_LIBRARY_NAME=nvidia`

### 4. Modules Not in initramfs

`/etc/mkinitcpio.conf`:
```
MODULES=()
```

Should include nvidia modules for early loading.

---

## System State

- Kernel headers installed: `linux-headers 7.2.3.arch1-2`
- Kernel: `7.2.3-arch1-2`
- nvidia-open-dkms: `610.57.04-1`
- Firmware: `linux-firmware-nvidia 20260810-2`

---

## Required Fixes

See: [[NVIDIA-RTX-5050-Fix-Commands]]

---

## References

- Arch Wiki NVIDIA: https://wiki.archlinux.org/title/NVIDIA
- NVIDIA Wayland: https://wiki.archlinux.org/title/NVIDIA/Wayland

## Tags
#note-nvidia-rtx-5050-investigation
