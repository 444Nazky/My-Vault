# Secure Boot Guide

**Date:** 2026-09-06
**Topic:** Secure Boot with Linux Dual Boot

---

## Overview

Secure Boot is a UEFI feature that only allows signed bootloaders to run. Games like Valorant and FC26 require Secure Boot + Windows.

---

## Options for Linux + Secure Boot Gaming

### Option 1: Disable Secure Boot (Recommended for Gaming)

**Pros:**
- Simple setup
- No key management needed
- Works with all Linux distributions

**Cons:**
- Slightly less secure
- Must disable manually when gaming

**How:**
1. Boot into UEFI/BIOS settings
2. Find "Secure Boot" option
3. Set to "Disabled"
4. Save and reboot

**When to use:**
- Playing Valorant, FC26, or other games that require Secure Boot + Windows
- Simple dual boot setup

---

### Option 2: Keep Secure Boot OFF for Linux

**Setup:**
1. Leave Secure Boot disabled in UEFI
2. Use GRUB to boot Linux
3. For gaming, boot directly to Windows (via GRUB or UEFI boot menu)

**Workflow:**
- Linux for daily work (Secure Boot OFF)
- Windows for gaming (Secure Boot OFF)
- No conflicts

---

### Option 3: Sign GRUB for Secure Boot (Advanced)

**Prerequisites:**
- shim-signed package
- MOK (Machine Owner Key)

**Steps:**

1. Install shim:
```bash
sudo pacman -S shim-signed mokutil
```

2. Generate MOK:
```bash
sudo mkdir -p /var/lib/shim-signed/mok
sudo openssl req -new -x509 -newkey rsa:4096 \
  -keyout MOK.key -out MOK.pem \
  -days 36500 -subj "/CN=Machine Owner Key/"
sudo openssl x509 -inform PEM -outform DER -in MOK.pem -out MOK.der
```

3. Sign GRUB:
```bash
sudo /usr/bin/grub2-mkimage \
  -o grubx64.efi \
  -O x86_64-efi \
  -p /boot/grub \
  grub
```

4. Enroll MOK:
```bash
sudo mokutil --import MOK.der
# Reboot and follow MOKManager prompts
```

**Cons:**
- Complex setup
- Must re-sign after kernel updates
- May break with distribution updates

---

## Game Compatibility

| Game | Secure Boot Required | Notes |
|------|---------------------|-------|
| Valorant | Yes (Windows) | Requires Secure Boot + Windows |
| FC26 | Yes (Windows) | Requires Secure Boot + Windows |
| Most Linux Games | No | Work fine without Secure Boot |

---

## Recommendation

For your setup (BlackArch + Windows Gaming):

1. **Keep Secure Boot disabled**
2. **Use GRUB to select OS:**
   - BlackArch for daily work
   - Windows for gaming
3. **No additional configuration needed**

When you need Valorant/FC26:
- Boot into Windows via GRUB
- Games work with Secure Boot disabled

---

## Verification

Check Secure Boot status:
```bash
mokutil --sb-state
```

Output:
- `SecureBoot enabled` - Secure Boot is ON
- `SecureBoot disabled` - Secure Boot is OFF

---

## Re-enabling Secure Boot Later

If you want to enable Secure Boot later:

1. Boot into Linux
2. Sign your bootloader (Option 3 above)
3. Enroll keys in MOKManager
4. Enable Secure Boot in UEFI

---

## See Also

- [[GRUB-Configuration]] - GRUB menu setup
- Arch Wiki: Secure Boot - https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot

## Tags
#note-secure-boot-guide
