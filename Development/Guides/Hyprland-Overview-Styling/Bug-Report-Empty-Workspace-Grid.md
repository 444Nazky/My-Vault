# Bug Report: Overview UI Shows Empty Workspace Grid

## Summary
- **Component**: Hyprland workspace overview (hyprtasking plugin)
- **Severity**: Medium (visual/cosmetic, not a crash)
- **Status**: Fixed

## Symptom
The overview (3-finger swipe up) renders a full 3x3 workspace grid. Every empty workspace shows a duplicated wallpaper tile, and the active workspace has a prominent border, producing harsh blue grid boxes.

## Reproduction Steps
1. Open the overview with 3-finger swipe up (or `hyprctl dispatch`).
2. Observe empty workspaces render wallpaper tiles.

## Root Cause
The hyprtasking plugin was configured with `layout = "grid"` and default `grid:rows = 3, grid:cols = 3`.

In grid layout, `HTLayoutGrid::refresh_workspace_cache()` (`/tmp/ht/src/layout/grid.cpp`) unconditionally fills every grid slot. Empty slots get synthetic workspace IDs via `next_synth()`:
- All 9 slots (3x3) are populated
- Empty slots render the wallpaper/background layers (see `render_workspace_at_box`)
- The active slot gets a border drawn from `general:col.active_border`

There is no grid option to hide empty slots, no blur behind the grid, and `CBorderPassElement/SBorderData` has no `rounding` field so card corners cannot be rounded.

## Misconception
Thought to fix it in Caelestia config (`shell.json`, `hypr-vars.lua`, `shell-tokens.json`). None of those control the overview:
- `shell.json` = bar/sidebar/launcher/dashboard settings
- `hypr-vars.lua` = empty overrides table (`return {}`)
- `shell-tokens.json` = does not exist on this machine

The overview is rendered 100% by the hyprtasking Hyprland plugin. Caelestia never had an overview UI.

## The Fix
Switch from `grid` to `linear` layout, which:
- Only includes occupied workspaces plus ONE synthetic new-workspace slot (see `HTLayoutLinear::build_overview_layout`, `/tmp/ht/src/layout/linear.cpp`)
- Renders a horizontal strip that can sit at the top of the screen
- Has built-in desktop blur (`linear:blur = true`) and dimming
- Set `border_size = 0` to remove the border grid entirely

## Verification
```bash
hyprctl getoption plugin:hyprtasking:layout   # -> "linear"
hyprctl getoption plugin:hyprtasking:border_size  # -> 0
hyprctl reload                                  # no config errors
```

## Prevention
- Do not use `grid` layout unless you explicitly want to see all workspace slots.
- Keep the mirror config copies in sync:
  - `~/.config/hypr/hyprland/gestures.lua`
  - `~/.config/caelestia/hypr/hyprland/gestures.lua`
- Run `diff` between the two after edits.