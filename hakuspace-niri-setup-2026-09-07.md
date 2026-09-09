# Haku Space Niri Setup

Date: 2026-09-07

## What Was Done

Installed Haku Space dotfiles for Niri window manager from [hakuimaku/hakuspace](https://github.com/hakuimaku/hakuspace) (v2.3.0).

### Config Files Copied

| Config      | Path                            |
| ----------- | ------------------------------- |
| Niri        | `~/.config/niri/`               |
| Waybar      | `~/.config/waybar/`             |
| Rofi        | `~/.config/rofi/`               |
| Kitty       | `~/.config/kitty/`              |
| Fish shell  | `~/.config/fish/`               |
| SwayNC      | `~/.config/swaync/`             |
| Cava        | `~/.config/cava/`               |
| Starship    | `~/.config/starship.toml`       |
| XDG Portals | `~/.config/xdg-desktop-portal/` |
| Thunar      | `~/.config/Thunar/`             |
| GTK         | `~/.config/gtk-3.0/`            |
| MPV         | `~/.config/mpv/`                |

### Scripts Installed

- 58 scripts copied to `~/.local/bin/`
- Theme generated: `~/.local/state/haku_theme/`
- Control directory created: `~/hakuspace-control/`

### Missing Dependencies

- **swaync**: Needs manual install with `yay -S swaync`
- **Fish shell**: Need to run `chsh -s /usr/bin/fish` after logging out/in

## Key Niri Keybindings

| Key | Action |
|-----|--------|
| `Super+Q` | Open Kitty terminal |
| `Super+R` | App launcher (Rofi) |
| `Super+Tab` | Haku menu |
| `Super+Grave` | Toggle overview |
| `Super+P` | Screenshot |
| `Super+V` | Clipboard menu |
| `Super+Y` | Wallpaper select |
| `Super+Z` | Toggle floating |
| `Super+W` | Toggle dockbar |
| `Super+L` | Nightlight/brightness |
| `Super+1-9` | Switch workspace |
| `Mod+Left/Right` | Focus column left/right |

## Customization

Edit `~/hakuspace-control/niri-custom.kdl` to override defaults without modifying the main config.

## Notes

- Dotfiles cloned to `~/hakuspace`
- Update with `cd ~/hakuspace && ./update.sh`
- Rollback with `cd ~/hakuspace && ./rollback.sh`
