# System Fixes Index

**Last Updated:** 2026-09-07

---

## Fixes Status

| Issue | Status | Priority |
|-------|--------|----------|
| [[NVIDIA-RTX-5050-Investigation]] | FIXED | Done |
| [[GRUB-Configuration]] | FIXED | Done |
| [[GRUB-Duplicate-Entries]] | Fixed | Done |
| [[HDMI-Monitor-Fix-NVIDIA-Wayland]] | FIXED | Done |
| [[Secure-Boot-Guide]] | Reference | Info |
| [[caelestia-shell-Removal-Issues]] | Fixed | Done |

---

## NVIDIA RTX 5050 - FULLY FIXED

**Commands Executed:**
```bash
sudo rm -rf /var/lib/dkms/nvidia
sudo pacman -S nvidia-open-dkms --overwrite "*"
sudo dkms install nvidia/610.57.04
sudo modprobe nvidia
```

**Configuration Updated:**
- `env.lua` - Added NVIDIA environment variables
- `mkinitcpio.conf` - MODULES includes nvidia modules

**Verification:**
```bash
nvidia-smi  # Working
```

**Status:** Ready for use.

---

## HDMI Monitor Not Showing - FIXED

**Problem:** HDMI monitor not detected. NVIDIA dGPU detected by `nvidia-smi` but `nvidia-drm` module not loaded, so DRM outputs (HDMI-A-2) not exposed to Wayland compositor (Hyprland).

**Root Causes:**
1. System boots via UKI (not GRUB) — `nvidia-drm.modeset=1` was in `/etc/default/grub` but NOT in `/etc/kernel/cmdline`
2. `/usr/lib/modprobe.d/bumblebee.conf` blacklisted all NVIDIA modules including `nvidia-drm`

**Commands Executed:**
```bash
# Fix UKI kernel cmdline
echo "$(cat /proc/cmdline | grep -oP 'root=\S+') zswap.enabled=0 rootflags=subvol=@ rw rootfstype=btrfs nvidia-drm.modeset=1" | sudo tee /etc/kernel/cmdline

# Remove bumblebee blacklist
sudo mv /usr/lib/modprobe.d/bumblebee.conf /usr/lib/modprobe.d/bumblebee.conf.disabled

# Set nvidia-drm modeset option
echo 'options nvidia-drm modeset=1' | sudo tee /etc/modprobe.d/nvidia.conf

# Rebuild initramfs + UKI
sudo mkinitcpio -P

# Manual load (immediate fix, no reboot needed)
sudo modprobe nvidia-drm

# Reboot to verify persistence
sudo reboot
```

**Status:** Monitor detected after `modprobe nvidia-drm`. Reboot required to verify automatic loading. See [[HDMI-Monitor-Fix-NVIDIA-Wayland]] for full details.

---

## GRUB Configuration - FULLY FIXED

**Commands Executed:**
```bash
sudo chmod -x /etc/grub.d/10_linux
sudo sed -i 's/GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=true/' /etc/default/grub
sudo mv /etc/grub.d/30_uefi-firmware /etc/grub.d/41_uefi-firmware
# Edited /etc/grub.d/40_custom with Windows Boot Manager entry
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**Final Menu Order:**
1. BlackArch
2. Windows Boot Manager
3. UEFI Firmware Settings

**Status:** Ready for use.

---

## Quick Commands Reference

### NVIDIA
```bash
nvidia-smi                    # Check GPU status
lsmod | grep nvidia         # Check loaded modules
```

### GRUB
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg  # Regenerate config
ls -l /etc/grub.d/          # Check script permissions
```

---

## Related Documents

| Document | Topic |
|----------|-------|
| [[NVIDIA-RTX-5050-Investigation]] | Full NVIDIA fix details |
| [[NVIDIA-RTX-5050-Fix-Commands]] | NVIDIA fix commands |
| [[GRUB-Configuration]] | Full GRUB fix details |
| [[GRUB-Duplicate-Entries-Fix-Commands]] | GRUB fix commands |
| [[HDMI-Monitor-Fix-NVIDIA-Wayland]] | HDMI monitor not detected on NVIDIA Wayland |
| [[Secure-Boot-Guide]] | Secure Boot options |