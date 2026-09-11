# 05 — Restore guide

Rebuild this rice on a fresh Arch + BlackArch install:

1. **Base** — install Arch, add the BlackArch repo (see `Personal/Cybersecurity/Blackarch/BlackArch Installation Guide`), install Hyprland + uwsm + NVIDIA drivers.
2. **Caelestia** — clone `caelestia-dots/caelestia` to `~/.config/caelestia`; re-apply the NVIDIA block to `hypr/hyprland/env.lua` (copy from `code/caelestia/hypr/hyprland/env.lua`).
3. **Dotter** — deploy with the package list in `code/caelestia/dotter/local.toml`: `hypr, foot, fish, starship, uwsm, micro, fastfetch, btop`.
4. **Hypr user config** — place `code/hypr/hyprland.conf` (touchpad + HDMI monitor), `userprefs.conf`, `monitors.conf`; `hyprland.lua` bootstraps the rest.
5. **Shell + terminal** — copy `code/caelestia/shell.json`; install foot, fish + `code/fish/config.fish`, starship + `code/starship.toml`, JetBrains Mono Nerd Font.
6. **Verify** — `echo $GBM_BACKEND` → `nvidia-drm`; external monitor at 1080p60; foot opens with blurred transparency; prompt renders the Mocha powerline.

> `code/` is a snapshot. The live configs are the source of truth — re-copy after any change worth keeping.

## Tags
#note-restore-guide
