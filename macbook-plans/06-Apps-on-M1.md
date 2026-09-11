# Aplikasi Sehari-hari di M1 Asahi

## Lancar Native ARM64

- Browser: Firefox, Chromium, Brave, Vivaldi.
- Editor dan IDE: VS Code ARM64, Neovim, JetBrains via Java ARM64.
- Terminal: Alacritty, Kitty, Tmux, Zsh, Bash.
- Container: Docker ARM64, Podman, QEMU.
- Produktif dan media: LibreOffice, Obsidian, VLC, GIMP, Inkscape, Discord via web.

## Butuh Emulasi

- Binary proprietary x86_64 only seperti Steam game tertentu dan Spotify resmi: via FEX-Emu atau Box64, performa lumayan berkat CPU M1.

## Bermasalah

- DRM ketat dan anticheat kernel x86.
- Wine dan Proton untuk Windows x86 butuh emulasi ganda Box64 plus Wine: aplikasi ringan bisa, game berat kurang stabil.

## Intel vs M1 Singkat

- Dev tools, browser, media: keduanya 100 persen native.
- Docker x86: Intel native, M1 butuh emulasi.
- Binary x86 lama: Intel langsung jalan, M1 via Box64 atau FEX-Emu.
- VM x86: Intel kencang KVM native, M1 sangat lambat emulasi penuh.

Fokus coding, CLI, web dev, dan security harian: M1 Asahi cukup dan nyaman. Butuh VM x86 murni atau aplikasi x86 tua: Intel unggul.

Tags: #apps #arm
