# Roblox via Sober

Date: 2026-09-09

## Overview

Installed **Sober** — the Vapor/Vinegar team's official Roblox client for Linux — via Flatpak. Sober runs Roblox on Linux through Wine with native Wayland support (Hyprland-compatible).

**Note:** This is distinct from the system `sober` CLI (`/usr/bin/sober`), which is the **Sober Raccoon** repo-governance security tool. The Roblox runner is `org.vinegarhq.Sober`.

## Installation

```bash
flatpak install -y flathub org.vinegarhq.Sober
```

- **Flatpak ID**: `org.vinegarhq.Sober`
- **Version**: 1.7.1 (stable)
- **Runtime**: org.gnome.Platform/x86_64/50
- **Installed Size**: 18.5 MB

## Run

### Desktop Entry
`org.vinegarhq.Sober.desktop` is installed at `/var/lib/flatpak/exports/share/applications/` — appears in the app launcher.

### CLI Wrapper
`~/.local/bin/sober` — fish wrapper calling `flatpak run org.vinegarhq.Sober`

```bash
sober                         # launch GUI
sober --help                  # show options
sober launch_uri rblox://...  # launch a Roblox game URI
```

## Requirements

- `flatpak` configured with flathub remote
- Wayland compositor (Hyprland, working)
- No Wine needed on host (bundled in flatpak runtime)

## Notes

- The flatpak Roblox client uses its own Wine/proton environment — no separate Wine installation required on the host.
- GPU passthrough works (RTX 5050 confirmed).
- See: https://sober.vinegarhq.org/