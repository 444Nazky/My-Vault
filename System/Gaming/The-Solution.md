# The Solution: Fix NFS Heat Lag

## Overview

The fix has two parts:
1. Install Proton GE (done)
2. Configure Steam to use it with NVIDIA GPU (do this now)

## Prerequisites

- Steam installed
- NFS Heat downloaded
- NVIDIA drivers working
- Hybrid graphics (Intel + NVIDIA)

Check if NVIDIA is working:
```bash
nvidia-smi
```

You should see "NVIDIA GeForce RTX 5050 Laptop GPU" listed.

## Step 1: Install Proton GE

If not already done:

```bash
# Download
cd /tmp
wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-6/GE-Proton11-6-x86_64.tar.gz

# Install
mkdir -p ~/.steam/steam/compatibilitytools.d/
tar -xf GE-Proton11-6-x86_64.tar.gz
mv GE-Proton11-6-x86_64 ~/.steam/steam/compatibilitytools.d/GE-Proton11-6
```

Verify:
```bash
ls ~/.steam/steam/compatibilitytools.d/
# Should show: GE-Proton11-6
```

## Step 2: Configure Steam

### Enable Steam Play

1. Open Steam
2. Go to Settings (gear icon)
3. Click "Steam Play"
4. Check "Enable Steam Play for all titles"
5. Select Proton 9.0 (or latest)
6. Click OK

### Configure NFS Heat

1. In Steam Library, find "Need for Speed Heat"
2. Right-click > Properties
3. Click "Compatibility" tab on the left
4. Check "Force the use of a specific Steam Play compatibility tool"
5. Dropdown: Select "GE-Proton11-6"

## Step 3: Add Launch Options

Still in NFS Heat Properties:

1. Find "Launch Options" text box (under General tab)
2. Clear any existing text
3. Copy and paste exactly:

```
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%
```

4. Close the Properties window

## Step 4: Verify It Works

1. Launch NFS Heat
2. Open a terminal
3. Run:
   ```bash
   nvidia-smi
   ```
4. Look for "NeedForSpeedHeat" or similar process
5. GPU utilization should NOT be 0%

## In-Game Settings

Once running on NVIDIA, recommended settings for RTX 5050:

| Setting | Value |
|---------|-------|
| Resolution | Native (your display) |
| Quality Preset | Medium |
| V-Sync | On |
| Anti-Aliasing | FXAA |
| Ambient Occlusion | Off |
| Shadow Quality | Medium |
| Texture Quality | High |
| Reflections | Medium |

## Alternative: Global Environment Variables

Instead of per-game launch options, add to `~/.bashrc`:

```bash
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
```

Then restart Steam or run:
```bash
source ~/.bashrc
```

---

Related: [[The-Problem]] - Why this works
Related: [[Troubleshooting]] - If it still doesn't work
Related: [[Launch-Options]] - What those flags mean

## Tags
#note-the-solution
