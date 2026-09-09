# Terminal Configuration Backup

Date: 2026-09-09

## Source Configs

| Component   | Path                                   |
| ----------- | -------------------------------------- |
| Foot        | `~/.config/foot/foot.ini`              |
| Fish        | `~/.config/fish/config.fish`           |
| Fastfetch   | `~/.config/fastfetch/config.jsonc`     |
| Starship    | `~/.config/starship.toml`              |

## Backup Location

All configs backed up to `~/.config.bak/`:

| Component   | Backup Path                              |
| ----------- | ---------------------------------------- |
| Foot        | `~/.config.bak/foot/foot.ini`            |
| Fish        | `~/.config.bak/fish/config.fish`         |
| Fastfetch   | `~/.config.bak/fastfetch/config.jsonc`   |
| Starship    | `~/.config.bak/starship.toml`            |

## Restore Command

```bash
cp ~/.config.bak/foot/foot.ini ~/.config/foot/foot.ini
cp ~/.config.bak/fish/config.fish ~/.config/fish/config.fish
cp ~/.config.bak/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
cp ~/.config.bak/starship.toml ~/.config/starship.toml
```

## Current Configuration

### Foot (`~/.config/foot/foot.ini`)

```ini
shell=fish
title=foot
font=JetBrains Mono Nerd Font:size=12
letter-spacing=0
dpi-aware=no
pad=25x25
bold-text-in-bright=no
gamma-correct-blending=no

[scrollback]
lines=10000

[cursor]
style=beam
beam-thickness=1.5

[colors-dark]
alpha=0.78
blur=yes

[key-bindings]
scrollback-up-page=Page_Up
scrollback-down-page=Page_Down
search-start=Control+Shift+f

[search-bindings]
cancel=Escape
find-prev=Shift+F3
find-next=F3 Control+G
```

### Fish (`~/.config/fish/config.fish`)

- Suppresses default greeting: `set -g fish_greeting`
- Runs fastfetch on shell start: `fastfetch`
- Initializes Starship prompt: `starship init fish | source`
- Sources caelestia ANSI color sequences for foot terminal
- Loads user overrides from `~/.config/caelestia/user-config.fish`
- Initializes direnv, zoxide, eza
- Defines git and system abbreviations

### Fastfetch (`~/.config/fastfetch/config.jsonc`)

- Logo: `amebuu.png` rendered as Kitty graphics protocol (width 24)
- Format: bordered single-card layout with emoji keys
- Colors: Mauve `#cba6f7` (ANSI 35) for keys/borders, yellow `#f9e2af` (ANSI 33) for title, white for values
- Modules: OS (BlackArch), Kernel (version only), CPU (i7-13650HX), GPU (NVIDIA RTX 5050 — integrated filtered out), Memory, Uptime, Shell

### Starship (`~/.config/starship.toml`)

- Catppuccin Mocha powerline pill layout
- Segments: Mauve `░▒▓` → username → Blue `` → directory → Mocha `` → time → ``
- Time format: `♡ HH:MM` in Mocha background with light text
- Prompt: `❯` colored by success/failure (green/mauve)

## Notes

- No `fish_greeting.fish` file currently present (greeting is inlined in `config.fish`)
- Image asset `amebuu.png` located at `~/Documents/...` and `~/.config/fastfetch/amebuu.png`
- Related context: [[hakuspace-niri-setup-2026-09-07]]