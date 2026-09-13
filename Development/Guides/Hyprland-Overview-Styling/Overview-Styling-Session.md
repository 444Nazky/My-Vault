# Hyprland Overview Styling - Session Record

## What Was Done

### Context
Configuring a macOS Mission Control / Windows Task View style workspace overview on Arch Linux with Hyprland 0.56.2 and the Caelestia shell.

### Original Task
Convert the 3-finger swipe up gesture from toggling the Caelestia launcher drawer into a proper workspace/window overview UI:
- 3 fingers UP = open Overview
- 3 fingers DOWN = close Overview
- LEFT/RIGHT = unchanged workspace switching
- Bug: 3-finger swipe up opened the launcher instead of an overview

### First Session (setup)
1. Investigated the Hyprland 0.56.2 Lua config layout:
   - `~/.config/hypr/hyprland.lua` is the entry point
   - Loads modules from `~/.config/hypr/hyprland/*.lua`
   - Mirror copy at `~/.config/caelestia/hypr/hyprland/*.lua`
2. Verified Caelestia has NO overview UI (`caelestia toggle overview` is an empty `special:overview` workspace).
3. Installed the **hyprtasking** plugin (`raybbian/hyprtasking`), ABI pin matched the exact running Hyprland commit `efb50993780079460b0cbed1363e2166a2de1d9f`.
4. Built the plugin from source (headers matched locally, no root needed).
5. Copied the built `.so` to `~/.local/share/hyprland/plugins/hyprtasking.so`.
6. Wired gestures in `gestures.lua` via `hl.plugin.hyprtasking.toggle("cursor")`.
7. Registered plugin loading via `hl.plugin.load(...)` for auto-load on start.

### Second Session (styling refactor)
Switched the overview from **grid layout** (3x3, filled with empty wallpaper tiles) to **linear layout**:
- Only occupied workspaces shown + one extra "new workspace" slot
- Horizontal strip at top (Mission Control style) instead of grids
- Blur on the desktop behind the strip (built-in)
- Removed the harsh rectangular border grid (`border_size = 0`)
- Increased card padding (`gap_size = 16`)
- Background color matched to Material scheme `surfaceContainer` (`0xFF201f23`)

## The Bug

### Symptom
Overview UI displays a full 3x3 workspace grid where all empty workspaces show duplicated wallpaper tiles and prominent active borders (harsh blue grid boxes).

### Root Cause
- The overview was hyprtasking's `layout = "grid"`.
- Grid layout ALWAYS fills every slot (rows x cols) with synthetic/empty workspaces (`next_synth()` in `src/layout/grid.cpp`), even when no windows exist.
- Grid layout has NO option to hide empty slots.
- Grid layout has NO blur/dimming of the background.
- Borders come from `general:col.active_border` / `inactive_border`.
- `SBorderData` (Hyprland BorderPassElement) has no `rounding` field, so card corners cannot be rounded by the plugin.

### Why it was hard to fix via Caelestia
- Caelestia shell (`shell.json`, `hypr-vars.lua`) has NO overview styling options.
- Caelestia manages the bar, launcher, sidebar, dashboard — not the workspace overview.
- There is no `shell-tokens.json` in this setup.
- The overview is entirely rendered by the hyprtasking Hyprland plugin.

## The Fix

### Fix 1 - Wire the gestures (session 1)
File: `~/.config/hypr/hyprland/gestures.lua` (and the mirror at `~/.config/caelestia/hypr/hyprland/gestures.lua`)

```lua
hl.plugin.load(os.getenv("HOME") .. "/.local/share/hyprland/plugins/hyprtasking.so")

hl.gesture({ fingers = vars.workspaceSwipeFingers, direction = "horizontal", action = "workspace" })
hl.gesture({
    fingers   = vars.gestureFingers,
    direction = "up",
    action    = function()
        hl.plugin.hyprtasking.toggle("cursor")
    end,
})
hl.gesture({
    fingers   = vars.gestureFingers,
    direction = "down",
    action    = function()
        if hl.plugin.hyprtasking.is_active() then
            hl.plugin.hyprtasking.toggle("cursor")
        else
            fn.toggle("specialws")
        end
    end,
})
hl.gesture({
    fingers   = vars.gestureFingersMore,
    direction = "down",
    action    = function()
        hl.exec_cmd(vars.sleepGestureCmd)
    end,
})
```

### Fix 2 - Switch grid to linear + style it (session 2)
```lua
hl.config({
    plugin = {
        hyprtasking = {
            layout      = "linear",
            gap_size    = 16,
            border_size = 0,
            bg_color    = 0xFF201f23, -- scheme surfaceContainer
            gestures = { enabled = false },
            linear = {
                top    = true,  -- Mission Control: strip at top
                height = 400,   -- strip height in logical px
                blur   = true,  -- blur the desktop behind the strip
            },
        },
    },
})
```

### Apply
```bash
hyprctl reload
```

## Verification
- `hyprctl configerrors` -> no errors
- `hyprctl getoption plugin:hyprtasking:layout` -> "linear", set true
- `hyprctl getoption plugin:hyprtasking:border_size` -> 0
- `hyprctl getoption plugin:hyprtasking:gap_size` -> 16
- `hyprctl plugin list` -> Hyprtasking loaded
- Overview toggle open/close via eval succeeded

## Key Files
| Path | Purpose |
| --- | --- |
| `~/.config/hypr/hyprland.lua` | Config entry point (Lua config) |
| `~/.config/hypr/hyprland/gestures.lua` | Active gesture + overview config |
| `~/.config/caelestia/hypr/hyprland/gestures.lua` | Mirror copy (keep in sync) |
| `~/.local/share/hyprland/plugins/hyprtasking.so` | Built plugin binary |
| `~/.config/hypr/variables.lua` | Touchpad vars (`gestureFingers=3`, `workspaceSwipeFingers=4`) |
| `~/.config/hypr/scheme/current.lua` | Material design colors (bg_color source) |