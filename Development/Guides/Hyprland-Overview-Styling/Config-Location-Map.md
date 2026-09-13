# Config Location Map

Where everything lives for this setup (Arch + Hyprland 0.56.2 + Caelestia shell).

## Hyprland (Lua config)
Hyprland 0.56 uses a Lua config. `~/.config/hypr/hyprland.conf` only contains a device block + monitor line; real config is Lua.

| Config | Path | Notes |
| --- | --- | --- |
| Entry point | `~/.config/hypr/hyprland.lua` | loads all `hyprland.*` modules |
| Gestures + overview | `~/.config/hypr/hyprland/gestures.lua` | contains hyprtasking block + hl.gesture binds |
| Input/touchpad | `~/.config/hypr/hyprland/input.lua` | natural_scroll, sensitivity |
| General/borders | `~/.config/hypr/hyprland/general.lua` | col.active_border, col.inactive_border |
| Decoration | `~/.config/hypr/hyprland/decoration.lua` | rounding = 15, blur, shadow |
| Variables | `~/.config/hypr/variables.lua` | gestureFingers=3, workspaceSwipeFingers=4, border colors |
| Color scheme | `~/.config/hypr/scheme/current.lua` | Material design tokens (bg_color source) |
| Startup execs | `~/.config/hypr/hyprland/execs.lua` | shell start, clipboard daemons |

## Mirror copy (Caelestia dotter)
`~/.config/caelestia/hypr/` mirrors the Hyprland config. Keep in sync:
- `~/.config/caelestia/hypr/hyprland/gestures.lua`
- `~/.config/caelestia/hypr/hyprland.lua`

Sync with:
```bash
diff ~/.config/hypr/hyprland/gestures.lua ~/.config/caelestia/hypr/hyprland/gestures.lua
```

## Caelestia shell
| Config | Path | Notes |
| --- | --- | --- |
| Shell settings | `~/.config/caelestia/shell.json` | bar/sidebar/launcher - NO overview keys |
| User overrides | `~/.config/caelestia/hypr-vars.lua` | empty by default (`return {}`) |
| User config | `~/.config/caelestia/hypr-user.lua` | empty by default |
| Shell modules | `/etc/xdg/quickshell/caelestia/modules/` | launcher, bar, sidebar, dashboard, nexus... |
| shell-tokens.json | DOES NOT EXIST | no such file in this setup |

Caelestia modules: areapicker, background, bar, dashboard, drawers, launcher, lock, nexus, notifications, osd, session, sidebar, utilities, windowinfo.
There is NO overview module.

## Plugin
| Item | Path |
| --- | --- |
| hyprtasking binary | `~/.local/share/hyprland/plugins/hyprtasking.so` |
| Build source | `/tmp/ht` (temporary, wiped on reboot) |
| ABI pins | `hyprpm.toml` in repo (v0.56.2 pin = efb50993) |

## Useful commands
```bash
hyprctl version                  # ABI string
hyprctl plugin list              # loaded plugins + handles
hyprctl plugin load <path>       # load a plugin
hyprctl reload                   # reload config
hyprctl configerrors             # config parse errors
hyprctl getoption plugin:hyprtasking:layout
hyprctl binds                    # registered binds (gesture binds are NOT listed here)
```