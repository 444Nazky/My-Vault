# Reference: hyprtasking Plugin Details

Source: https://github.com/raybbian/hyprtasking (build from git main; AUR `hyprtasking` version 0.4-1 is out-of-date).

## Compatibility (ABI)
- hyprtasking pins Hyprland commits in `hyprpm.toml`.
- The pin for `v0.56.2` is the exact running commit here:
  `efb50993780079460b0cbed1363e2166a2de1d9f`.
- Build locally against installed headers at `/usr/include/hyprland` (matching `hyprland.pc` version 0.56.2). No root needed.

## Build Command (reference)
```bash
cd /tmp/ht
meson setup build --prefix=/usr --buildtype=release
meson compile -C build
cp build/libhyprtasking.so ~/.local/share/hyprland/plugins/hyprtasking.so
```

## Load / Unload
```bash
hyprctl plugin load ~/.local/share/hyprland/plugins/hyprtasking.so   # load now
hyprctl plugin unload <handle>                                        # unload (get handle from hyprctl plugin list)
```
Auto-load on start is done in `gestures.lua` with `hl.plugin.load(...)`.

## Config Options (all prefixed plugin:hyprtasking:)
| Option | Type | Default | Notes |
| --- | --- | --- | --- |
| layout | string | grid | `grid` or `linear` |
| bg_color | int | 0x000000FF | overlay strip background color |
| gap_size | float | 8 | gap between workspace cards |
| border_size | float | 4 | card border width |
| exit_on_hovered | int | false | exit to hovered workspace on hide |
| warp_on_move_window | int | 1 | warp cursor on movewindow |
| close_overview_on_reload | int | true | close overview if reload |
| drag_button | int | 0x110 | left mouse |
| select_button | int | 0x111 | right mouse |
| gestures:enabled | int | true | internal swipe engine (set false to use hl.gesture) |
| gestures:move_fingers | int | 3 | internal swipe move fingers |
| gestures:move_distance | float | 300 | swipe distance |
| gestures:open_fingers | int | 4 | internal swipe open fingers |
| gestures:open_distance | float | 300 | swipe open distance |
| gestures:open_positive | int | true | swipe up opens |
| grid:rows | int | 3 | rows in grid layout |
| grid:cols | int | 3 | cols in grid layout |
| grid:loop | int | false | wrap navigation |
| grid:layers | int | 1 | third dimension |
| grid:loop_layers | int | true | wrap layers |
| grid:gaps_use_aspect_ratio | int | false | scale vertical gaps |
| linear:top | int | false | strip at top |
| linear:blur | int | true | blur dim area |
| linear:height | float | 300 | strip height logical px |
| linear:scroll_speed | float | 1 | scroll modifier |

## Lua API (exposed by plugin)
- `hl.plugin.hyprtasking.toggle("cursor")` - open/close overview on cursor monitor
- `hl.plugin.hyprtasking.toggle("all")` - toggle overview on all monitors
- `hl.plugin.hyprtasking.is_active()` - returns boolean
- `hl.plugin.hyprtasking.move("up"/"down"/"left"/"right"/"in"/"out")` - switch workspace
- `hl.plugin.hyprtasking.movewindow(...)` - move hovered window
- `hl.plugin.hyprtasking.killhovered()` - close hovered window
- `hl.plugin.hyprtasking.setlayer(...)` / `setlayerwindow(...)` - grid layers

## Border/rounding caveat
- Card borders are drawn via Hyprland `CBorderPassElement/SBorderData`.
- `SBorderData` has `box`, `grad1`, `grad2`, `borderSize`, `roundingPower` - NO `rounding`.
- Therefore workspace card corners CANNOT be rounded by hyprtasking. Window content inside a card is rounded by normal `decoration:rounding`.

## Linear layout empty-workspace behavior
`HTLayoutLinear::build_overview_layout` (src/layout/linear.cpp):
1. Collect all workspaces on this monitor (skips special workspaces).
2. Sort by workspace id.
3. Append exactly ONE synthetic "new" workspace = highest id + 1 (skipping ids that already exist).
4. Render each as a card in a horizontal row.

Result: only occupied + one new slot. No wallpaper-tile grids.