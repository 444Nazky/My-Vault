# NFS Heat Setup Log

Date: September 2, 2026

## System Check

Ran `lspci` to identify GPUs:

```
00:02.0 VGA: Intel Corporation Raptor Lake-S UHD Graphics
01:00.0 VGA: NVIDIA Corporation GB207M [GeForce RTX 5050 Max-Q]
```

This is a hybrid graphics laptop with:
- Intel UHD Graphics (integrated, low power)
- NVIDIA RTX 5050 (dedicated, high performance)

## Software Found

- Steam: Installed (version 1.0.0.87-1)
- NVIDIA Driver: 610.57.04
- NFS Heat location: ~/.local/share/Steam/steamapps/common/Need for Speed Heat
- Steam App ID: 1222680

## Steps Completed

### Step 1: Located Game Installation

Game was already installed via Steam at:
`~/.local/share/Steam/steamapps/common/Need for Speed Heat`

### Step 2: Downloaded Proton GE

Downloaded `GE-Proton11-6-x86_64.tar.gz` (~521MB) from:
https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-6/

### Step 3: Installed Proton GE

Extracted and moved to Steam compatibility tools:
```bash
tar -xf GE-Proton11-6-x86_64.tar.gz
mv GE-Proton11-6-x86_64 ~/.steam/steam/compatibilitytools.d/GE-Proton11-6
```

Verified installation:
```bash
$ ls ~/.steam/steam/compatibilitytools.d/
GE-Proton11-6
```

### Step 4: Configured NVIDIA PRIME

Added environment variables to `/etc/environment`:
- `VK_LAYER_NV_optimus=NVIDIA_only`
- `NVIDIA_VISIBLE_DEVICES=1`

### Step 5: Created Steam Config

Created user config at:
`~/.steam/steam/userdata/<STEAM_USER>/config/config.vdf`

## Manual Steps Required

User must do these in Steam client:

1. Right-click "Need for Speed Heat"
2. Click "Properties"
3. Go to "Compatibility" tab
4. Check "Force the use of a specific Steam Play compatibility tool"
5. Select "GE-Proton11-6"
6. In "Launch Options", paste:
   ```
   __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%
   ```

## Verification

After configuration, run this to verify GPU usage:
```bash
nvidia-smi
```

The game process should appear and show GPU utilization.

---

Log Status: Complete
Last Updated: 2026-09-02

## Tags
#note-setup-log
