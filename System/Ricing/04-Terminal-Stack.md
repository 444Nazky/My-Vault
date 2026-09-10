# 04 — Terminal stack

## foot (`code/foot/foot.ini`)

- Shell: `fish`. Font: JetBrains Mono Nerd Font 12, padding `25x25`.
- Beam cursor (1.5px), 10000-line scrollback, `alpha=0.78` + blur on dark colors.
- `Ctrl+Shift+f` starts search; `PageUp/PageDown` scroll.

## fish (`code/fish/config.fish`)

Interactive-only setup:

- Greeting replaced with `fastfetch`; prompt via **starship**.
- `direnv` + `zoxide` (`cd` jumps); `eza` aliased to `ls` with icons.
- PATH: `~/.local/bin`, `~/.cargo/bin`, `~/go/bin`. Wayland env: `GTK_USE_PORTAL=1`, `MOZ_ENABLE_WAYLAND=1`, `QT_QPA_PLATFORMTHEME=qt6ct`, `DOTNET_ROOT=$HOME/.dotnet`.
- Git abbreviations (`gs`, `gd`, `ga`, `gc`, `gl`, `gp`…), listing shortcuts (`ll`, `la`), plus personal ones (`haku`, `menu`, `openconfig`, `pacsize`).
- Caelestia integration: sources Material You ANSI sequences into every PTY and emits foot prompt marks (`133;A`).
- Extras: `conf.d/uv.env.fish` (uv env), `functions/blackbox.fish` (blackbox-ai wrapper).

## starship (`code/starship.toml`)

Catppuccin Mocha powerline, single line: mauve `username` → blue `directory` (truncated to 3) → surface `time` with ♡.
