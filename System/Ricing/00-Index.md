# Ricing — Arch + BlackArch + Caelestia

My desktop setup: Arch Linux with the BlackArch repo on top, Hyprland as compositor, and the Caelestia dotfiles as the shell. This folder holds the story and the curated code. Full upstream defaults are not copied here — only my modifications and key configs.

## Map

- [[01-Base-System]] — Arch, BlackArch repo, NVIDIA, laptop hardware
- [[02-Caelestia-Shell]] — upstream checkout + my local modifications
- [[03-Hyprland]] — compositor bootstrap, input, monitors
- [[04-Terminal-Stack]] — foot + fish + starship
- [[05-Restore-Guide]] — rebuild this setup from zero
- `code/` — the actual files, copied verbatim (secret-scanned, clean)

## Related (already in the vault)

- `System/Caelestia/` — architecture, keybinds, lock settings, transparency notes
- `Personal/Cybersecurity/Blackarch/` — install guide, checklist, cheat sheet, troubleshooting
- `Personal/Session-Logs/2026-08-29-Caelestia-Session/` — session log of a Caelestia fix session

## Live paths (source of truth)

| What | Path |
|---|---|
| Caelestia checkout | `~/.config/caelestia` (upstream `caelestia-dots/caelestia`) |
| Active hypr config | `~/.config/hypr` |
| Fish / foot / starship | `~/.config/fish`, `~/.config/foot/foot.ini`, `~/.config/starship.toml` |
| Dotter deployment | `~/.config/caelestia/.dotter/` |
