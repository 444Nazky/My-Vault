# 03 — Hyprland

## Bootstrap (`code/hypr/hyprland.lua`)

Entry point that wires everything without overwriting user state:

1. `maybe_copy` — seeds `scheme/current.lua` from `scheme/default.lua` on first run only.
2. `maybe_create` — ensures `hypr-vars.lua` / `hypr-user.lua` exist, then applies `hypr-vars` overrides onto `variables`.
3. Sets a fallback monitor (`preferred, auto, scale 1`), loads the Caelestia modules (`env, general, input, misc, animations, decoration, group, execs, rules, gestures, keybinds`), then loads `hypr-user` last.

## Device + monitors

- `code/hypr/hyprland.conf` — touchpad block (elan06fa, sensitivity `7.5`) + `monitor=HDMI-A-1, 1920x1080@60, auto, 1`. Same monitor line duplicated in `code/hypr/monitors.conf`.
- `code/hypr/userprefs.conf` — pointer `sensitivity 0.6`, `accel_profile adaptive`.
- Per-output shell overrides exist but are empty (see [[02-Caelestia-Shell]]).

## Reference

- Keybinds table: `System/Caelestia/Caelestia-Hyprland-Keybinds`
- Transparency tweak history: `System/Caelestia/Hyprland - Reduce Transparency`
- Lock behavior: `System/Caelestia/Caelestia-Lock-Settings`

## Tags
#note-hyprland
