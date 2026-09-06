# GRUB Duplicate Entries Fix Commands

**Status:** FIXED - 2026-09-06
**Requires:** sudo access

---

## Complete Solution

### Step 1: Disable Generic Arch Entries

The script `/etc/grub.d/10_linux` generates generic Arch Linux entries. Disable it:

```bash
sudo chmod -x /etc/grub.d/10_linux
```

**Verification:**
```bash
ls -l /etc/grub.d/10_linux
# Should show: -rw-r--r-- (no execute permission)
```

### Step 2: Disable os-prober

Prevent duplicate Windows entries from os-prober:

```bash
sudo nano /etc/default/grub
# Add or set: GRUB_DISABLE_OS_PROBER=true
```

Or use sed:
```bash
sudo sed -i 's/GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=true/' /etc/default/grub
```

### Step 3: Add Windows Boot Manager Entry

Edit `/etc/grub.d/40_custom`:

```bash
sudo nano /etc/grub.d/40_custom
```

Content:
```bash
#!/bin/sh
exec tail -n +3 $0

menuentry "Windows Boot Manager" --class windows --class os {
    insmod part_gpt
    insmod fat
    insmod chain
    search --no-floppy --fs-uuid --set=root 298C-5E1B
    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}
```

Make it executable:
```bash
sudo chmod +x /etc/grub.d/40_custom
```

**Note:** The UUID `298C-5E1B` is the Windows EFI partition (`/dev/nvme0n1p1`).

### Step 4: Move UEFI Firmware to Bottom

Rename script to run after 40_custom:

```bash
sudo mv /etc/grub.d/30_uefi-firmware /etc/grub.d/41_uefi-firmware
```

### Step 5: Regenerate GRUB Configuration

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**Verification:** Check output shows:
- BlackArch entries only
- Windows Boot Manager entry
- UEFI Firmware Settings at bottom
- No duplicate entries

### Step 6: Reboot

```bash
sudo reboot
```

---

## Commands Summary

```bash
# 1. Disable 10_linux
sudo chmod -x /etc/grub.d/10_linux

# 2. Disable os-prober
sudo sed -i 's/GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=true/' /etc/default/grub

# 3. Edit 40_custom with Windows Boot Manager entry
sudo nano /etc/grub.d/40_custom

# 4. Make executable
sudo chmod +x /etc/grub.d/40_custom

# 5. Move UEFI to bottom
sudo mv /etc/grub.d/30_uefi-firmware /etc/grub.d/41_uefi-firmware

# 6. Regenerate
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 7. Reboot
sudo reboot
```

---

## GRUB Script Order (Final)

| Order | Script | Purpose |
|-------|-------|---------|
| 10 | 10_linux | Disabled |
| 20 | 20_linux_xen | Xen kernel |
| 30 | 30_os-prober | OS detection (disabled via GRUB_DISABLE_OS_PROBER) |
| 40 | 40_custom | Windows Boot Manager |
| 41 | 41_uefi-firmware | UEFI settings (at bottom) |

---

## File Locations

| File | Purpose |
|------|---------|
| `/etc/default/grub` | Main GRUB configuration |
| `/etc/grub.d/10_linux` | Auto-generates Arch entries (disabled) |
| `/etc/grub.d/40_custom` | Custom entries (Windows Boot Manager) |
| `/etc/grub.d/41_uefi-firmware` | UEFI settings (moved to bottom) |
| `/boot/grub/grub.cfg` | Generated menu |

---

## Revert if Needed

To restore original GRUB configuration:
```bash
sudo chmod +x /etc/grub.d/10_linux
sudo sed -i 's/GRUB_DISABLE_OS_PROBER=true/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
sudo mv /etc/grub.d/41_uefi-firmware /etc/grub.d/30_uefi-firmware
sudo rm /etc/grub.d/40_custom
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## Expected GRUB Menu

After fix, GRUB should show:
```
BlackArch
BlackArch, with Linux (linux)
BlackArch, with Linux (linux) -fallback

Windows Boot Manager

UEFI Firmware Settings
```

Not:
```
UEFI Firmware Settings

Arch Linux
Arch Linux
Advanced options for Arch Linux
Windows
Windows
...
```
