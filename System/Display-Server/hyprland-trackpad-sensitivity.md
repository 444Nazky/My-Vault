# Hyprland Trackpad Sensitivity - Caelestia

## Problem
Wanted to adjust trackpad sensitivity without using nano (wanted a GUI like Windows).

## Solution

### Step 1: Identify Trackpad
```bash
hyprctl devices
```
Found: `elan06fa:00-04f3:327e-touchpad`

### Step 2: Find Correct Config Location
Hyprland on Caelestia uses a Lua-based config system at:
```
~/.config/caelestia/hypr/hyprland/
```

### Step 3: Edit input.lua
File: `~/.config/caelestia/hypr/hyprland/input.lua`

Added device-specific sensitivity:
```lua
hl.device({
    name = "elan06fa:00-04f3:327e-touchpad",
    sensitivity = 7.5
})
```

### Reload/Restart
```bash
hyprctl reload
```
Or full restart:
```bash
hyprctl dispatch exit
```
Then log back in.

## Notes
- Caelestia uses `hl.config()` and `hl.device()` instead of bare config blocks
- Device name from `hyprctl devices` must match exactly
- Sensitivity: 0.0 = default, positive = faster, negative = slower
- Old config attempt was in wrong file: `~/.config/hypr/hyprland.conf` (not being read)
