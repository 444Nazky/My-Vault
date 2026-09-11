# 01 — Base system

- **Distro:** Arch Linux (rolling), with the **BlackArch repository** layered on top for security tooling. See `Personal/Cybersecurity/Blackarch/` for the install guide, post-install checklist, and cheat sheet.
- **GPU:** NVIDIA (`GPU-0`). Wayland needs explicit DRM/GLX env vars — see `code/caelestia/hypr/hyprland/env.lua`:
  - `GBM_BACKEND=nvidia-drm`, `__GLX_VENDOR_LIBRARY_NAME=nvidia`, `NVIDIA_VISIBLE_DEVICES=GPU-0`, `NVIDIA_DRIVER_CAPABILITIES=all`
- **Machine:** laptop with `eDP-1` / `eDP-2` panels plus an external `HDMI-A-1` at `1920x1080@60` (`code/hypr/monitors.conf`).
- **Touchpad:** `elan06fa:00-04f3:327e-touchpad`, sensitivity `7.5` (`code/hypr/hyprland.conf`); pointer accel `adaptive`, sensitivity `0.6` (`code/hypr/userprefs.conf`).
- **Session:** Wayland via `uwsm` (managed in the dotter package list), `XDG_CURRENT_DESKTOP=Hyprland`.

## Tags
#note-base-system
