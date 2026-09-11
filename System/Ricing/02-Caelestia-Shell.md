# 02 — Caelestia shell

`~/.config/caelestia` is a git checkout of upstream [`caelestia-dots/caelestia`](https://github.com/caelestia-dots/caelestia). I run close to upstream — my local delta is small and deliberate:

## My modifications (tracked diff)

- `code/caelestia/hypr/hyprland/env.lua` — added the NVIDIA/DRM block (GBM backend, GLX vendor, visible devices, driver capabilities). Without this, the NVIDIA GPU doesn't initialize under Hyprland.
- `code/caelestia/hypr/hyprland/input.lua` — no functional change (whitespace only).

## My local files (untracked in upstream)

- `code/caelestia/shell.json` — my shell choices: transparency **on**, **persistent** bar with workspace window icons (max 5, shown), sidebar **enabled**, tray without background.
- `code/caelestia/monitors/{eDP-1,eDP-2,HDMI-A-1}/shell.json` — per-output overrides, currently empty (`{}`) = defaults everywhere.
- `code/caelestia/hypr-vars.lua` — variable overrides, currently `return {}` (none).
- `code/caelestia/hypr-user.lua` — user hook, currently empty.
- `code/caelestia/dotter/` — dotter deployment: packages `hypr, foot, fish, starship, uwsm, micro, fastfetch, btop`.

## Notes

- Upstream moves fast; before pulling, `git stash` the env/input diff or it conflicts.
- Deeper Caelestia internals live in `System/Caelestia/` (architecture, keybinds, lock, transparency).

## Tags
#note-caelestia-shell
