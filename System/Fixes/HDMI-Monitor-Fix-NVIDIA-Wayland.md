# HDMI Monitor Not Showing - NVIDIA Wayland Fix

**Date:** 2026-09-07
**System:** BlackArch Linux (Arch-based)
**GPU:** NVIDIA GeForce RTX 5050 Max-Q (dGPU) + Intel UHD (iGPU)
**Display Server:** Wayland (Hyprland via GDM/uwsm)
**Boot Method:** UKI (Unified Kernel Image) via systemd-boot
**Status:** FIXED (requires reboot + verification)

---

## What Was Done

1. **Diagnosed** the HDMI-A-1 connector showing `disconnected` with 0-byte EDID at the kernel DRM level
2. **Discovered** the system boots from a UKI (`arch-linux.efi`) — GRUB config changes had no effect
3. **Found** `nvidia-drm.modeset=1` was in `/etc/default/grub` but NOT in `/etc/kernel/cmdline` (the actual parameter source for UKI boot)
4. **Added** `nvidia-drm.modeset=1` to `/etc/kernel/cmdline`
5. **Rebuilt** the UKI/initramfs with `mkinitcpio -P`
6. **Manually loaded** `nvidia-drm` module (`modprobe nvidia-drm`) — monitor immediately appeared
7. **Found** `nvidia-drm` was being blacklisted by `/usr/lib/modprobe.d/bumblebee.conf`
8. **Disabled** the bumblebee blacklist (`mv bumblebee.conf bumblebee.conf.disabled`)
9. **Rebuilt** initramfs again with the blacklist removed

---

## What The Problem Was

### Root Cause: `nvidia-drm` module never loaded at boot

The HDMI port is physically wired to the **NVIDIA dGPU** (at PCI `01:00.0`). The `nvidia-drm` kernel module provides the DRM interface that exposes this GPU's display connectors (HDMI, DP, eDP) to the Wayland compositor (Hyprland).

`nvidia-drm` was **not loading at boot** due to two compounding issues:

#### Issue 1: Kernel parameter not applied (UKI boot)
- The system boots from a **Unified Kernel Image** (`arch-linux.efi`), not GRUB
- Kernel parameters are embedded in the UKI from `/etc/kernel/cmdline`
- `nvidia-drm.modeset=1` was set in `/etc/default/grub` (GRUB config) but was **never in `/etc/kernel/cmdline`**
- **GRUB config regeneration had zero effect** since GRUB isn't the active bootloader

#### Issue 2: Bumblebee blacklist (primary blocker)
- `/usr/lib/modprobe.d/bumblebee.conf` contained:
  ```
  blacklist nvidia
  blacklist nvidia-drm
  blacklist nvidia-modeset
  blacklist nvidia-uvm
  ```
- These blacklists prevented `nvidia-drm` from auto-loading via udev/modprobe after the initramfs handoff
- The `nvidia` and `nvidia_modeset` modules loaded anyway because they're in `/etc/mkinitcpio.conf MODULES=()`, which forces them in initramfs and bypasses blacklists
- `nvidia_drm` was also in MODULES but failed to load during early boot (likely dependency/timing with nvidia-modeset), and the blacklist prevented it from loading later

### Evidence

```
# Before fix — nvidia-drm NOT loaded:
$ lsmod | grep nvidia
nvidia_modeset    1921024  0
nvidia_uvm         2449408  0
nvidia            18190336  7 nvidia_uvm,nvidia_modeset

# HDMI-A-1 on Intel iGPU (card1) — no NVIDIA DRM outputs:
/sys/class/drm/card1-HDMI-A-1/status: disconnected
/sys/class/drm/card1-HDMI-A-1/edid: 0 bytes

# After fix — nvidia-drm loaded:
$ lsmod | grep nvidia
nvidia_drm           167936  9
nvidia_modeset    1921024  3 nvidia_drm
nvidia_uvm         2449408  0
nvidia             18190336  42 nvidia_uvm,nvidia_modeset

# HDMI-A-2 on NVIDIA dGPU (card0) — monitor detected!:
/sys/class/drm/card0-HDMI-A-2/status: connected
/sys/class/drm/card0-HDMI-A-2/edid: 256 bytes
# EDID shows: "Mi Monitor" (manufacturer 61a9, model parsed from hexdump)
```

---

## What's Missing (Pending)

- [ ] **Reboot** — must reboot to verify `nvidia-drm` loads automatically at boot
- [ ] **Verify after reboot** — confirm HDMI-A-2 is `connected` without manual `modprobe`
- [ ] **Check Hyprland monitor config** — may need `monitor=HDMI-A-2,auto,auto,1` in Hyprland config if it doesn't auto-detect
- [ ] **Update README.md** in `[[System/Fixes/README]]` to reference this fix

---

## Solutions

### Solution 1: Fix kernel cmdline (UKI-specific)

```bash
# Add nvidia-drm.modeset=1 to the UKI kernel cmdline
sudo bash -c 'echo "root=PARTUUID=<your-partuuid> zswap.enabled=0 rootflags=subvol=@ rw rootfstype=btrfs nvidia-drm.modeset=1" > /etc/kernel/cmdline'

# Rebuild UKI
sudo mkinitcpio -P
```

### Solution 2: Remove NVIDIA module blacklists

```bash
# Disable the bumblebee blacklist (if bumblebee is not used)
sudo mv /usr/lib/modprobe.d/bumblebee.conf /usr/lib/modprobe.d/bumblebee.conf.disabled

# Or create an override in /etc/modprobe.d/ (doesn't override blacklist, use above):
sudo bash -c 'echo "options nvidia-drm modeset=1" > /etc/modprobe.d/nvidia.conf'
```

### Solution 3: Verify mkinitcpio config

```bash
# Ensure nvidia modules are in MODULES=()
cat /etc/mkinitcpio.conf | grep MODULES
# Should show: MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)

# Ensure kms hook is in HOOKS (for early KMS)
cat /etc/mkinitcpio.conf | grep HOOKS
# Should include: kms
```

---

## How To Fix (Complete Command Sequence)

```bash
# 1. Fix the UKI kernel cmdline (replace PARTUUID with your actual one)
ROOT_UUID=$(blkid -s PARTUUID -o value /dev/nvme0n1p2 2>/dev/null || cat /proc/cmdline | grep -oP 'root=PARTUUID=\S+')
if [[ -z "$ROOT_UUID" ]]; then
    # Fallback: extract currently running cmdline and append
    CMDLINE=$(cat /proc/cmdline)
    echo "$CMDLINE nvidia-drm.modeset=1" | sudo tee /etc/kernel/cmdline
else
    echo "$ROOT_UUID nvidia-drm.modeset=1" | sudo tee /etc/kernel/cmdline
fi

# 2. Disable bumblebee blacklist
sudo mv /usr/lib/modprobe.d/bumblebee.conf /usr/lib/modprobe.d/bumblebee.conf.disabled 2>/dev/null || true

# 3. Ensure nvidia-drm modeset option is set
echo 'options nvidia-drm modeset=1' | sudo tee /etc/modprobe.d/nvidia.conf

# 4. Verify mkinitcpio.conf has nvidia modules in MODULES
# Edit: sudo nano /etc/mkinitcpio.conf
# MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)

# 5. Rebuild initramfs + UKI
sudo mkinitcpio -P

# 6. Reboot
sudo reboot

# --- After reboot, verify: ---
lsmod | grep nvidia_drm              # should show nvidia_drm loaded
cat /sys/class/drm/card0-HDMI-A-2/status  # should say 'connected'
cat /sys/class/drm/card0-HDMI-A-2/edid | wc -c  # should be >0 (256 bytes)
hyprctl monitors all                 # should show HDMI-A-2
```

---

## Advice

### 1. Always check the actual boot method
The system has GRUB installed and configured at `/etc/default/grub`, but **boots via systemd-boot + UKI**. Changes to GRUB config are meaningless if GRUB isn't the active bootloader. Check `/proc/cmdline` to verify parameters are actually applied, and check `efibootmgr -v` to see which EFI entry is active.

### 2. UKI kernel parameters vs. GRUB kernel parameters
- **GRUB**: `/etc/default/grub` → `sudo grub-mkconfig -o /boot/grub/grub.cfg`
- **UKI**: `/etc/kernel/cmdline` → `sudo mkinitcpio -P`
- If the kernel parameter isn't in `/proc/cmdline`, it's NOT being applied regardless of what the config files say.

### 3. Check for module blacklists from removed packages
The `bumblebee.conf` modprobe file was likely left behind from a previous Bumblebee installation. When you stop using Bumblebee, **always check** `/usr/lib/modprobe.d/` and `/etc/modprobe.d/` for stale blacklists that prevent NVIDIA modules from loading.

### 4. The `nvidia_drm` module is critical for Wayland
On NVIDIA + Wayland setups:
- `nvidia` module = CUDA/OGL rendering (loaded without DRM)
- `nvidia_drm` module = DRM/KMS display interface (REQUIRED for compositor output)
- Loading `nvidia` alone makes `nvidia-smi` work but **does NOT expose displays to Wayland**

### 5. Use `pkexec` for sudo in restricted environments
`pkexec` works without passwordless sudo if polkit is configured to allow it for the user's group. Check group membership:
```bash
groups  # should include 'wheel' or equivalent
```

### 6. Two DRM cards on Optimus laptops
This system has dual GPUs:
- **card0** = NVIDIA dGPU (`01:00.0`) — HDMI-A-2, DP-2, eDP-2
- **card1** = Intel iGPU (`00:02.0`) — HDMI-A-1, DP-1, eDP-1 (connected)

If the HDMI monitor is plugged into the port wired to the dGPU, you need `nvidia-drm` loaded. If it's wired to the iGPU, the Intel connector (card1-HDMI-A-1) would show the connection. In this case, the monitor is on the NVIDIA side.

### 7. After applying fixes, always reboot (don't just reload modules)
Loading `nvidia-drm` manually fixes the immediate issue, but the blacklist and kernel parameter issues will reoccur on reboot. Always reboot to verify the fix is persistent.

---

## References

- [NVIDIA/Wayland (Arch Wiki)](https://wiki.archlinux.org/title/NVIDIA/Wayland)
- [NVIDIA (Arch Wiki)](https://wiki.archlinux.org/title/NVIDIA)
- [mkinitcpio (Arch Wiki)](https://wiki.archlinux.org/title/Mkinitcpio)
- Related: [[NVIDIA-RTX-5050-Investigation]], [[NVIDIA-RTX-5050-Fix-Commands]]
