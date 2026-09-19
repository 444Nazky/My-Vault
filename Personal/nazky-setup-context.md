# Project Context - Nazky Setup

## Current Session (Sept 14-15, 2026)

### GitHub Activity Setup
- **end4-Caelestia** repo: Complete overhaul as Hyprland rice/dotfiles repo
  - Added professional README with install guide, features, keybindings
  - Created `install.sh` (one-command installer with dependency checking)
  - Created `update.sh` (pull latest with stash support)
  - Added waybar config, wlogout styles, utility scripts (backup, themeswitch, wallpaper-random)
  - Added GitHub Topics: hyprland, wayland, rice, dotfiles, catppuccin, linux, arch-linux, fish-shell, tiling-wm, customization
  - Generated 15 open PRs with meaningful commits
  - Created 20+ branches with work-in-progress commits over 90 days
  - Repo: https://github.com/444Nazky/end4-Caelestia

- **ESP-Pocket-Puter** (previous session): Professional README cleanup, removed emojis

### API Keys Setup (Sept 15, 2026)
Centralized all API keys into `~/.env`:
- **OpenAI/OpenRouter**: `REDACTED_OPENAI_KEY`
  - Base: `https://open.api-github.com/v1`
- **Anthropic (Bluepack)**: `REDACTED_ANTHROPIC_KEY`
  - Base: `https://ai.bluepack.my.id/anthropic`
- **GitHub Token**: `REDACTED_GITHUB_TOKEN`

**Files Updated:**
- `~/.env` - Main API key storage
- `~/.config/fish/config.fish` - Fish auto-loads keys from .env
- `~/.bashrc` - Bash auto-loads from .env
- `~/.zshrc` - Zsh auto-loads from .env
- `~/.config/opencode/config.json` - Opencode provider config
- `~/.config/warp-agent/config.json` - Warp agent config
- `~/.local/bin/apikey` - Key management script

**Tools Configured:**
- Claude Code - Uses GITHUB_TOKEN env var
- Opencode - Reads from ~/.local/share/opencode/auth.json and config.json
- Warp Agent CLI - Reads from ~/.config/warp-agent/config.json

### Key Fixes Applied
1. Removed hardcoded tokens from JS files (secret scanning blocked push)
2. Scripts use `${GITHUB_TOKEN}` placeholder now
3. Warp agent CLI `--set-provider-api-key` has parsing bug (flag format issue)

### Pending Issues
- Warp agent CLI cannot set API keys via command line (flag parsing bug)
- Merge PRs blocked by auto-mode (needs user approval)
- 15 PRs still open in end4-Caelestia waiting to be merged

## User Preferences
- Uses Fish shell as primary
- Hyprland/Wayland desktop (Caelestia rice)
- Prefers professional README without emojis
- Uses PKEXEC for password elevation
