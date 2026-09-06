# System Fixes Index

**Last Updated:** 2026-09-06

---

## Fixes Status

| Issue | Status | Priority |
|-------|--------|----------|
| [[NVIDIA-RTX-5050-Investigation]] | FIXED | Done |
| [[GRUB-Configuration]] | FIXED | Done |
| [[GRUB-Duplicate-Entries]] | Fixed | Done |
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
| [[Secure-Boot-Guide]] | Secure Boot options |
