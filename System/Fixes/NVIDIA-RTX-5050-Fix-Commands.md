# NVIDIA RTX 5050 Fix Commands (COMPLETED)

**Status:** FIXED - 2026-09-06
**Requires:** sudo access

---

## Fix Applied (2026-09-06)

Commands that were run:

```bash
# Step 1: Remove broken DKMS
sudo rm -rf /var/lib/dkms/nvidia

# Step 2: Reinstall driver
sudo pacman -S nvidia-open-dkms --overwrite "*"

# Step 3: Install DKMS module
sudo dkms install nvidia/610.57.04

# Step 4: Load module
sudo modprobe nvidia

# Step 5: Verify
nvidia-smi  # SUCCESS
```

**Result:** NVIDIA RTX 5050 detected and working.

---

## Step 1: Build NVIDIA Kernel Module

The nvidia-open-dkms module needs to be built:

```bash
# Rebuild nvidia-open-dkms for current kernel
sudo dkms install nvidia/610.57.04

# Alternative - reinstall the package which triggers dkms
sudo pacman -S nvidia-open-dkms --overwrite "*"
```

---

## Step 2: Load NVIDIA Module

```bash
# Load nvidia module
sudo modprobe nvidia

# Verify loaded
lsmod | grep nvidia
nvidia-smi
```

---

## Step 3: Update mkinitcpio.conf

Add nvidia modules to initramfs:

```bash
sudo nano /etc/mkinitcpio.conf
```

Change:
```
MODULES=()
```

To:
```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Then regenerate initramfs:
```bash
sudo mkinitcpio -P
```

---

## Step 4: Add NVIDIA Environment Variables to Caelestia (COMPLETED)

Added to both files:
- `~/.config/hypr/hyprland/env.lua`
- `~/.config/caelestia/hypr/hyprland/env.lua`

```lua
-- NVIDIA/DRM
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVIDIA_VISIBLE_DEVICES", "GPU-0")
hl.env("NVIDIA_DRIVER_CAPABILITIES", "all")
```

---

## Step 5: Update mkinitcpio.conf (PENDING)

Edit `~/.config/hypr/hyprland/env.lua`:

```lua
-- NVIDIA/DRM
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVIDIA_VISIBLE_DEVICES", "GPU-0")
hl.env("NVIDIA_DRIVER_CAPABILITIES", "all")
```

Or add to `~/.config/caelestia/hypr/hyprland/env.lua`.

---

## Step 5: Rebuild GRUB (Optional - For Kernel Parameters)

The kernel cmdline already has nvidia-drm.modeset=1 (from pacman hook):

```bash
# Check current cmdline
cat /proc/cmdline
# Should include: nvidia-drm.modeset=1
```

If not present, add to GRUB:

```bash
sudo nano /etc/default/grub
```

Add to `GRUB_CMDLINE_LINUX_DEFAULT`:
```
nvidia-drm.modeset=1
```

Then regenerate:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## Step 6: Reboot (PENDING)

```bash
sudo reboot
```

---

## Verification After Reboot

```bash
# Check NVIDIA driver loaded
nvidia-smi

# Check Wayland session
echo $WAYLAND_DISPLAY

# Test with glxinfo
glxinfo -B | grep NVIDIA
```

---

## Troubleshooting

### If dkms install fails:

```bash
# Check kernel headers
pacman -Qs linux-headers

# Reinstall headers
sudo pacman -S linux-headers

# Try building manually
sudo dkms install nvidia/610.57.04 -k $(uname -r)/build
```

### If module still not found:

```bash
# Check module location
find /usr/lib/modules/$(uname -r) -name "nvidia*.ko*" 2>/dev/null

# If missing, reinstall
sudo pacman -S nvidia-open-dkms
```

### For RTX 5050 specifically (Ada Lovelace / Blackwell arch):

RTX 5050 uses newer GPU architecture. Make sure you have the latest driver:
```bash
pacman -Ss nvidia
```

---

## Expected Result

```
$ nvidia-smi
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 610.57.04   Driver Version: 610.57.04   CUDA Version: N/A      |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  Off  | 00000000:01:00.0 On |                  N/A |
|                             |                  0MiB /  4096MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
```

## Tags
#note-nvidia-rtx-5050-fix-commands
